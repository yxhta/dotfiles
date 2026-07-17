use std::collections::HashMap;
use std::process::Command;

use serde::Deserialize;

/// Failures from talking to the herdr CLI or decoding its output.
#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("failed to run {bin}: {source}")]
    Spawn { bin: String, source: std::io::Error },
    #[error("herdr {command} failed: {stderr}")]
    Command { command: String, stderr: String },
    #[error("invalid {what} JSON: {source}")]
    Parse {
        what: &'static str,
        source: serde_json::Error,
    },
}

/// One detected agent pane, as reported by `herdr agent list`.
// Field names mirror the herdr CLI JSON payload keys verbatim.
#[expect(clippy::struct_field_names)]
#[derive(Debug, Clone, Deserialize)]
pub struct Agent {
    pub agent: Option<String>,
    pub agent_status: Option<String>,
    pub cwd: Option<String>,
    pub name: Option<String>,
    pub pane_id: Option<String>,
    pub terminal_id: Option<String>,
    pub terminal_title_stripped: Option<String>,
    pub workspace_id: Option<String>,
    pub tab_id: Option<String>,
    #[serde(default)]
    pub focused: bool,
}

impl Agent {
    /// Focus/read target. Herdr accepts either id; prefer the terminal id
    /// because pane ids compact when panes close.
    pub fn target(&self) -> Option<&str> {
        non_empty(self.terminal_id.as_deref()).or_else(|| non_empty(self.pane_id.as_deref()))
    }

    pub fn kind(&self) -> &str {
        non_empty(self.agent.as_deref()).unwrap_or("-")
    }

    pub fn status(&self) -> &str {
        non_empty(self.agent_status.as_deref()).unwrap_or("unknown")
    }

    /// User-assigned agent name plus the terminal title, when both exist.
    pub fn label(&self) -> String {
        let name = non_empty(self.name.as_deref());
        let title = non_empty(self.terminal_title_stripped.as_deref());
        match (name, title) {
            (Some(name), Some(title)) => format!("{name} · {title}"),
            (Some(name), None) => name.to_string(),
            (None, Some(title)) => title.to_string(),
            (None, None) => "-".to_string(),
        }
    }

    pub fn short_cwd(&self, home: Option<&str>) -> String {
        let Some(cwd) = non_empty(self.cwd.as_deref()) else {
            return "-".to_string();
        };
        match home.filter(|home| !home.is_empty()) {
            Some(home) if cwd == home => "~".to_string(),
            Some(home) => cwd
                .strip_prefix(home)
                .and_then(|rest| rest.strip_prefix('/'))
                .map_or_else(|| cwd.to_string(), |rest| format!("~/{rest}")),
            None => cwd.to_string(),
        }
    }
}

fn non_empty(value: Option<&str>) -> Option<&str> {
    value.filter(|value| !value.is_empty())
}

#[derive(Deserialize)]
struct AgentListResponse {
    result: Option<AgentListResult>,
}

#[derive(Deserialize)]
struct AgentListResult {
    #[serde(default)]
    agents: Vec<Agent>,
}

pub fn parse_agent_list(raw: &str) -> Result<Vec<Agent>, Error> {
    let response: AgentListResponse = parse_json(raw, "agent list")?;
    Ok(response.result.map(|r| r.agents).unwrap_or_default())
}

#[derive(Deserialize)]
struct ReadResponse {
    result: Option<ReadResult>,
}

#[derive(Deserialize)]
struct ReadResult {
    read: Option<ReadPayload>,
}

#[derive(Deserialize)]
struct ReadPayload {
    text: Option<String>,
}

pub fn parse_read_text(raw: &str) -> Result<String, Error> {
    let response: ReadResponse = parse_json(raw, "read")?;
    Ok(response
        .result
        .and_then(|r| r.read)
        .and_then(|r| r.text)
        .unwrap_or_default())
}

fn parse_json<'a, T: Deserialize<'a>>(raw: &'a str, what: &'static str) -> Result<T, Error> {
    serde_json::from_str(raw).map_err(|source| Error::Parse { what, source })
}

#[derive(Deserialize)]
struct WorkspaceListResponse {
    result: Option<WorkspaceListResult>,
}

#[derive(Deserialize)]
struct WorkspaceListResult {
    #[serde(default)]
    workspaces: Vec<WorkspaceEntry>,
}

#[derive(Deserialize)]
struct WorkspaceEntry {
    workspace_id: String,
    label: String,
    #[serde(default)]
    tab_count: u32,
}

#[derive(Deserialize)]
struct TabListResponse {
    result: Option<TabListResult>,
}

#[derive(Deserialize)]
struct TabListResult {
    #[serde(default)]
    tabs: Vec<TabEntry>,
}

#[derive(Deserialize)]
struct TabEntry {
    tab_id: String,
    label: String,
    #[serde(default)]
    number: u32,
}

#[derive(Debug, Clone)]
struct WorkspaceInfo {
    label: String,
    tab_count: u32,
}

#[derive(Debug, Clone)]
struct TabInfo {
    label: String,
    /// True when the label is just the tab's own number ("1", "2", …), i.e.
    /// the user never renamed it. Precomputed so `location_for` stays
    /// allocation-free on the lookup path.
    auto_named: bool,
}

/// Workspace/tab labels, as shown in the built-in sidebar's "agents" panel:
/// workspace name, plus the tab name when the workspace has more than one
/// tab or the tab was given a custom (non-numeric) name.
#[derive(Debug, Clone, Default)]
pub struct WorkspaceIndex {
    workspaces: HashMap<String, WorkspaceInfo>,
    tabs: HashMap<String, TabInfo>,
}

impl WorkspaceIndex {
    fn parse(workspaces_raw: &str, tabs_raw: &str) -> Result<Self, Error> {
        let workspaces: WorkspaceListResponse = parse_json(workspaces_raw, "workspace list")?;
        let tabs: TabListResponse = parse_json(tabs_raw, "tab list")?;
        let workspaces = workspaces
            .result
            .map(|r| r.workspaces)
            .unwrap_or_default()
            .into_iter()
            .map(|w| {
                let info = WorkspaceInfo {
                    label: w.label,
                    tab_count: w.tab_count,
                };
                (w.workspace_id, info)
            })
            .collect();
        let tabs = tabs
            .result
            .map(|r| r.tabs)
            .unwrap_or_default()
            .into_iter()
            .map(|t| {
                let info = TabInfo {
                    auto_named: t.label == t.number.to_string(),
                    label: t.label,
                };
                (t.tab_id, info)
            })
            .collect();
        Ok(Self { workspaces, tabs })
    }

    /// Mirrors the built-in sidebar's default agent row: workspace name,
    /// plus " · tab name" when the tab is worth distinguishing.
    pub fn location_for(&self, agent: &Agent) -> String {
        let workspace = agent
            .workspace_id
            .as_deref()
            .and_then(|id| self.workspaces.get(id));
        let workspace_label = workspace.map_or("-", |w| w.label.as_str());

        let tab = agent.tab_id.as_deref().and_then(|id| self.tabs.get(id));
        let multi_tab = workspace.is_some_and(|w| w.tab_count > 1);
        match tab {
            Some(tab) if multi_tab || !tab.auto_named => {
                format!("{workspace_label} · {}", tab.label)
            }
            _ => workspace_label.to_string(),
        }
    }
}

/// Thin client over the herdr CLI (`HERDR_BIN_PATH`), the documented way for
/// plugins to talk back to the running herdr instance.
pub struct Client {
    bin: String,
}

impl Client {
    pub fn from_env() -> Self {
        let bin = std::env::var("HERDR_BIN_PATH")
            .ok()
            .filter(|bin| !bin.is_empty())
            .unwrap_or_else(|| "herdr".to_string());
        Self { bin }
    }

    pub fn list_agents(&self) -> Result<Vec<Agent>, Error> {
        parse_agent_list(&self.run(&["agent", "list"])?)
    }

    pub fn workspace_index(&self) -> Result<WorkspaceIndex, Error> {
        let workspaces = self.run(&["workspace", "list"])?;
        let tabs = self.run(&["tab", "list"])?;
        WorkspaceIndex::parse(&workspaces, &tabs)
    }

    pub fn read_agent(&self, target: &str) -> Result<String, Error> {
        parse_read_text(&self.run(&[
            "agent", "read", target, "--source", "visible", "--format", "text",
        ])?)
    }

    pub fn focus_agent(&self, target: &str) -> Result<(), Error> {
        self.run(&["agent", "focus", target]).map(|_| ())
    }

    fn run(&self, args: &[&str]) -> Result<String, Error> {
        let output = Command::new(&self.bin)
            .args(args)
            .output()
            .map_err(|source| Error::Spawn {
                bin: self.bin.clone(),
                source,
            })?;
        if !output.status.success() {
            return Err(Error::Command {
                command: args.join(" "),
                stderr: String::from_utf8_lossy(&output.stderr).trim().to_string(),
            });
        }
        // Reuse the stdout buffer when it is valid UTF-8 (the normal case);
        // `from_utf8_lossy(..).into_owned()` would always copy it.
        Ok(String::from_utf8(output.stdout)
            .unwrap_or_else(|invalid| String::from_utf8_lossy(invalid.as_bytes()).into_owned()))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = r#"{"id":"cli:agent:list","result":{"agents":[
        {"agent":"claude","agent_status":"working","cwd":"/Users/me/ghq/dotfiles",
         "focused":false,"pane_id":"w2:p1","terminal_id":"term_abc",
         "terminal_title_stripped":"agents-picker plugin","workspace_id":"w2","tab_id":"w2:t1"},
        {"agent":"codex","agent_status":"idle","cwd":"/Users/me",
         "focused":true,"name":"impl-1.2","pane_id":"w7:p2","terminal_id":"",
         "terminal_title_stripped":"","workspace_id":"w7","tab_id":"w7:t1"}
    ],"type":"agent_list"}}"#;

    #[test]
    fn parses_agent_list() {
        let agents = parse_agent_list(SAMPLE).unwrap();
        assert_eq!(agents.len(), 2);
        assert_eq!(agents[0].kind(), "claude");
        assert_eq!(agents[0].status(), "working");
        assert!(agents[1].focused);
    }

    #[test]
    fn target_prefers_terminal_id_and_falls_back_to_pane_id() {
        let agents = parse_agent_list(SAMPLE).unwrap();
        assert_eq!(agents[0].target(), Some("term_abc"));
        assert_eq!(agents[1].target(), Some("w7:p2"));
    }

    #[test]
    fn label_combines_name_and_title() {
        let agents = parse_agent_list(SAMPLE).unwrap();
        assert_eq!(agents[0].label(), "agents-picker plugin");
        assert_eq!(agents[1].label(), "impl-1.2");
    }

    #[test]
    fn short_cwd_replaces_home_prefix() {
        let agents = parse_agent_list(SAMPLE).unwrap();
        assert_eq!(agents[0].short_cwd(Some("/Users/me")), "~/ghq/dotfiles");
        assert_eq!(agents[1].short_cwd(Some("/Users/me")), "~");
        assert_eq!(agents[0].short_cwd(None), "/Users/me/ghq/dotfiles");
    }

    #[test]
    fn short_cwd_does_not_shorten_sibling_prefix() {
        let agents = parse_agent_list(SAMPLE).unwrap();
        // "/Users/me…" must not match home "/Users/m".
        assert_eq!(agents[1].short_cwd(Some("/Users/m")), "/Users/me");
    }

    #[test]
    fn parses_empty_and_read_payloads() {
        assert!(parse_agent_list(r#"{"result":{"agents":[]}}"#)
            .unwrap()
            .is_empty());
        assert!(parse_agent_list("not json").is_err());
        assert_eq!(
            parse_read_text(r#"{"result":{"read":{"text":"hello"}}}"#).unwrap(),
            "hello"
        );
        assert_eq!(parse_read_text(r#"{"result":{}}"#).unwrap(), "");
    }

    #[test]
    fn parse_error_names_the_payload() {
        let err = parse_agent_list("not json").unwrap_err();
        assert!(err.to_string().starts_with("invalid agent list JSON:"));
    }

    const WORKSPACES: &str = r#"{"result":{"workspaces":[
        {"workspace_id":"w1","label":"dotfiles","tab_count":1},
        {"workspace_id":"w2","label":"dealon","tab_count":2}
    ]}}"#;
    const TABS: &str = r#"{"result":{"tabs":[
        {"tab_id":"w1:t1","workspace_id":"w1","label":"1","number":1},
        {"tab_id":"w2:t1","workspace_id":"w2","label":"1","number":1},
        {"tab_id":"w2:t2","workspace_id":"w2","label":"skills","number":2}
    ]}}"#;

    fn agent_with(workspace_id: &str, tab_id: &str) -> Agent {
        parse_agent_list(&format!(
            r#"{{"result":{{"agents":[{{"pane_id":"p1","terminal_id":"t1",
             "workspace_id":"{workspace_id}","tab_id":"{tab_id}"}}]}}}}"#
        ))
        .unwrap()
        .remove(0)
    }

    #[test]
    fn location_hides_tab_for_single_auto_named_tab() {
        let index = WorkspaceIndex::parse(WORKSPACES, TABS).unwrap();
        assert_eq!(index.location_for(&agent_with("w1", "w1:t1")), "dotfiles");
    }

    #[test]
    fn location_shows_auto_named_tab_when_workspace_has_multiple_tabs() {
        let index = WorkspaceIndex::parse(WORKSPACES, TABS).unwrap();
        assert_eq!(index.location_for(&agent_with("w2", "w2:t1")), "dealon · 1");
    }

    #[test]
    fn location_shows_custom_named_tab_even_when_only_tab() {
        let index = WorkspaceIndex::parse(WORKSPACES, TABS).unwrap();
        assert_eq!(
            index.location_for(&agent_with("w2", "w2:t2")),
            "dealon · skills"
        );
    }

    #[test]
    fn location_falls_back_to_dash_for_unknown_workspace() {
        let index = WorkspaceIndex::parse(WORKSPACES, TABS).unwrap();
        assert_eq!(index.location_for(&agent_with("wZ", "wZ:t1")), "-");
    }
}
