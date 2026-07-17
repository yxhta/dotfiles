use std::time::Instant;

use ratatui::widgets::TableState;

use crate::fuzzy;
use crate::herdr::{Agent, WorkspaceIndex};

/// Input mode, mirroring the built-in workspace picker: plain `j`/`k`
/// navigate by default, and `/` enters incremental search.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Mode {
    Navigate,
    Search,
}

pub struct App {
    pub mode: Mode,
    pub agents: Vec<Agent>,
    pub filter: String,
    /// Indices into `agents`, filter applied, best match first.
    pub filtered: Vec<usize>,
    pub table_state: TableState,
    pub preview: String,
    pub error: Option<String>,
    home: Option<String>,
    /// Our own pane id (`HERDR_PANE_ID`); the picker pane can show up in
    /// `agent list` when opened as a split/tab, and listing itself is noise.
    self_pane: Option<String>,
    workspaces: WorkspaceIndex,
    /// Per-agent display strings, parallel to `agents`. Cached so the
    /// per-keystroke filter pass and the per-frame draw stay allocation-free;
    /// rebuilt only when the agent list or workspace index changes.
    locations: Vec<String>,
    labels: Vec<String>,
    cwds: Vec<String>,
    /// Fuzzy-match haystack per agent, parallel to `agents`; same cache
    /// lifetime as `locations`.
    search_texts: Vec<String>,
    /// Matched-char indices per filtered row, parallel to `filtered`; empty
    /// when the filter is empty. Computed per filter change so the draw path
    /// never re-runs the fuzzy walk.
    highlights: Vec<Vec<usize>>,
    opened_at: Instant,
}

impl App {
    pub fn new(home: Option<String>, self_pane: Option<String>) -> Self {
        Self {
            mode: Mode::Navigate,
            agents: Vec::new(),
            filter: String::new(),
            filtered: Vec::new(),
            table_state: TableState::default(),
            preview: String::new(),
            error: None,
            home,
            self_pane,
            workspaces: WorkspaceIndex::default(),
            locations: Vec::new(),
            labels: Vec::new(),
            cwds: Vec::new(),
            search_texts: Vec::new(),
            highlights: Vec::new(),
            opened_at: Instant::now(),
        }
    }

    /// ~100ms tick since the picker opened; drives the working-status spinner.
    pub fn spinner_tick(&self) -> usize {
        usize::try_from(self.opened_at.elapsed().as_millis() / 100).unwrap_or(0)
    }

    /// Cached workspace/tab label for `agents[index]`, matching the built-in
    /// sidebar's agents panel.
    pub fn location(&self, index: usize) -> &str {
        self.locations.get(index).map_or("-", String::as_str)
    }

    /// Cached `Agent::label` for `agents[index]`.
    pub fn label(&self, index: usize) -> &str {
        self.labels.get(index).map_or("-", String::as_str)
    }

    /// Cached `Agent::short_cwd` for `agents[index]`.
    pub fn cwd(&self, index: usize) -> &str {
        self.cwds.get(index).map_or("-", String::as_str)
    }

    /// Cached matched-char indices into the search text for filtered row
    /// `row`; empty when the filter is empty.
    pub fn highlights(&self, row: usize) -> &[usize] {
        self.highlights.get(row).map_or(&[], Vec::as_slice)
    }

    /// Replace the workspace/tab name lookup used for `location` and
    /// filtering; refreshed on the same cadence as the agent list.
    pub fn set_workspace_index(&mut self, workspaces: WorkspaceIndex) {
        self.workspaces = workspaces;
        self.rebuild_caches();
        self.apply_filter();
    }

    /// Replace the agent list, keeping the current selection when its target
    /// still exists (the list refreshes periodically while the picker is open).
    /// On the very first load, pre-selects the agent the user was already in
    /// when the picker was opened, if any.
    pub fn set_agents(&mut self, mut agents: Vec<Agent>) {
        if let Some(self_pane) = self.self_pane.as_deref() {
            agents.retain(|agent| agent.pane_id.as_deref() != Some(self_pane));
        }
        let keep = self
            .selected_agent()
            .and_then(|agent| agent.target().map(str::to_string));
        self.agents = agents;
        self.rebuild_caches();
        self.apply_filter();
        if let Some(target) = keep {
            let position = self
                .filtered
                .iter()
                .position(|&i| self.agents[i].target() == Some(target.as_str()));
            if let Some(position) = position {
                self.table_state.select(Some(position));
            }
        } else if let Some(position) = self.filtered.iter().position(|&i| self.agents[i].focused) {
            self.table_state.select(Some(position));
        }
    }

    fn rebuild_caches(&mut self) {
        self.locations = self
            .agents
            .iter()
            .map(|agent| self.workspaces.location_for(agent))
            .collect();
        self.labels = self.agents.iter().map(Agent::label).collect();
        self.cwds = self
            .agents
            .iter()
            .map(|agent| agent.short_cwd(self.home.as_deref()))
            .collect();
        // The haystack concatenates the same strings as the visible columns;
        // `highlight` offsets in ui.rs assume this exact order.
        self.search_texts = (0..self.agents.len())
            .map(|i| {
                format!(
                    "{} {} {} {}",
                    self.agents[i].kind(),
                    self.labels[i],
                    self.locations[i],
                    self.cwds[i]
                )
            })
            .collect();
    }

    pub fn apply_filter(&mut self) {
        let mut scored: Vec<(i64, usize)> = self
            .search_texts
            .iter()
            .enumerate()
            .filter_map(|(i, text)| fuzzy::score(&self.filter, text).map(|score| (score, i)))
            .collect();
        if !self.filter.is_empty() {
            scored.sort_by_key(|&(score, _)| std::cmp::Reverse(score));
        }
        self.filtered = scored.into_iter().map(|(_, i)| i).collect();
        self.highlights = if self.filter.is_empty() {
            Vec::new()
        } else {
            self.filtered
                .iter()
                .map(|&i| fuzzy::positions(&self.filter, &self.search_texts[i]).unwrap_or_default())
                .collect()
        };

        if self.filtered.is_empty() {
            self.table_state.select(None);
        } else {
            let selected = self
                .table_state
                .selected()
                .unwrap_or(0)
                .min(self.filtered.len() - 1);
            self.table_state.select(Some(selected));
        }
    }

    /// Index into `agents` of the currently selected row, if any.
    pub fn selected_index(&self) -> Option<usize> {
        self.table_state
            .selected()
            .and_then(|row| self.filtered.get(row).copied())
    }

    pub fn selected_agent(&self) -> Option<&Agent> {
        self.selected_index().map(|i| &self.agents[i])
    }

    pub fn move_selection(&mut self, delta: isize) {
        let len = self.filtered.len();
        if len == 0 {
            return;
        }
        let current = self.table_state.selected().unwrap_or(0).min(len - 1);
        // Wrap-around without sign casts: both branches stay in 0..len.
        let step = delta.unsigned_abs() % len;
        let next = if delta >= 0 {
            (current + step) % len
        } else {
            (current + len - step) % len
        };
        self.table_state.select(Some(next));
    }

    pub fn push_char(&mut self, c: char) {
        self.filter.push(c);
        self.reset_after_filter_change();
    }

    pub fn pop_char(&mut self) {
        self.filter.pop();
        self.reset_after_filter_change();
    }

    pub fn pop_word(&mut self) {
        while self.filter.pop().is_some_and(|c| c == ' ') {}
        while self.filter.chars().last().is_some_and(|c| c != ' ') {
            self.filter.pop();
        }
        self.reset_after_filter_change();
    }

    pub fn clear_filter(&mut self) {
        self.filter.clear();
        self.reset_after_filter_change();
    }

    pub fn enter_search(&mut self) {
        self.mode = Mode::Search;
    }

    /// Leave search mode, discarding the filter (Esc in the built-in picker).
    pub fn cancel_search(&mut self) {
        self.mode = Mode::Navigate;
        self.clear_filter();
    }

    fn reset_after_filter_change(&mut self) {
        self.apply_filter();
        if !self.filtered.is_empty() {
            self.table_state.select(Some(0));
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::herdr::parse_agent_list;

    fn sample_app() -> App {
        let agents = parse_agent_list(
            r#"{"result":{"agents":[
                {"agent":"claude","agent_status":"working","cwd":"/w/dotfiles",
                 "pane_id":"w1:p1","terminal_id":"term_1","terminal_title_stripped":"dotfiles work"},
                {"agent":"codex","agent_status":"idle","cwd":"/w/dealon",
                 "pane_id":"w2:p1","terminal_id":"term_2","terminal_title_stripped":"dealon review"},
                {"agent":"claude","agent_status":"done","cwd":"/w/dealon",
                 "pane_id":"w3:p1","terminal_id":"term_3","terminal_title_stripped":"schema task"}
            ]}}"#,
        )
        .unwrap();
        let mut app = App::new(None, None);
        app.set_agents(agents);
        app
    }

    #[test]
    fn initial_selection_prefers_the_focused_agent() {
        let agents = parse_agent_list(
            r#"{"result":{"agents":[
                {"agent":"claude","pane_id":"w1:p1","terminal_id":"term_1"},
                {"agent":"codex","focused":true,"pane_id":"w2:p1","terminal_id":"term_2"},
                {"agent":"claude","pane_id":"w3:p1","terminal_id":"term_3"}
            ]}}"#,
        )
        .unwrap();
        let mut app = App::new(None, None);
        app.set_agents(agents);
        assert_eq!(app.selected_agent().unwrap().target(), Some("term_2"));
    }

    #[test]
    fn filter_narrows_and_resets_selection_to_best_match() {
        let mut app = sample_app();
        app.move_selection(2);
        for c in "dealon".chars() {
            app.push_char(c);
        }
        assert_eq!(app.filtered.len(), 2);
        assert_eq!(app.table_state.selected(), Some(0));

        app.clear_filter();
        assert_eq!(app.filtered.len(), 3);
    }

    #[test]
    fn selection_survives_agent_refresh() {
        let mut app = sample_app();
        app.move_selection(1);
        assert_eq!(app.selected_agent().unwrap().target(), Some("term_2"));

        // term_1 disappeared; term_2 moved to the front.
        let refreshed = parse_agent_list(
            r#"{"result":{"agents":[
                {"agent":"codex","agent_status":"idle","cwd":"/w/dealon",
                 "pane_id":"w2:p1","terminal_id":"term_2","terminal_title_stripped":"dealon review"},
                {"agent":"claude","agent_status":"done","cwd":"/w/dealon",
                 "pane_id":"w3:p1","terminal_id":"term_3","terminal_title_stripped":"schema task"}
            ]}}"#,
        )
        .unwrap();
        app.set_agents(refreshed);
        assert_eq!(app.selected_agent().unwrap().target(), Some("term_2"));
    }

    #[test]
    fn selection_wraps_both_directions() {
        let mut app = sample_app();
        app.move_selection(-1);
        assert_eq!(app.table_state.selected(), Some(2));
        app.move_selection(1);
        assert_eq!(app.table_state.selected(), Some(0));
    }

    #[test]
    fn cancel_search_returns_to_navigate_and_clears_filter() {
        let mut app = sample_app();
        assert_eq!(app.mode, Mode::Navigate);
        app.enter_search();
        assert_eq!(app.mode, Mode::Search);
        for c in "dealon".chars() {
            app.push_char(c);
        }
        assert_eq!(app.filtered.len(), 2);
        app.cancel_search();
        assert_eq!(app.mode, Mode::Navigate);
        assert!(app.filter.is_empty());
        assert_eq!(app.filtered.len(), 3);
    }

    #[test]
    fn own_pane_is_excluded_from_the_list() {
        let agents = parse_agent_list(
            r#"{"result":{"agents":[
                {"agent":"claude","pane_id":"w1:p1","terminal_id":"term_1"},
                {"pane_id":"w1:p9","terminal_id":"term_self"}
            ]}}"#,
        )
        .unwrap();
        let mut app = App::new(None, Some("w1:p9".to_string()));
        app.set_agents(agents);
        assert_eq!(app.agents.len(), 1);
        assert_eq!(app.agents[0].target(), Some("term_1"));
    }

    #[test]
    fn empty_filter_result_deselects() {
        let mut app = sample_app();
        for c in "nomatchxyz".chars() {
            app.push_char(c);
        }
        assert!(app.filtered.is_empty());
        assert!(app.selected_agent().is_none());
    }

    #[test]
    fn cached_search_text_tracks_agent_and_location() {
        let app = sample_app();
        assert_eq!(app.location(0), "-");
        assert_eq!(app.search_texts[0], "claude dotfiles work - /w/dotfiles");
    }

    #[test]
    fn highlights_are_cached_per_filtered_row() {
        let mut app = sample_app();
        for c in "dealon".chars() {
            app.push_char(c);
        }
        // Cached rows mirror the greedy fuzzy walk over each row's haystack.
        let expected = fuzzy::positions(&app.filter, &app.search_texts[app.filtered[0]]).unwrap();
        assert_eq!(app.highlights(0), expected);

        app.clear_filter();
        assert!(app.highlights(0).is_empty());
    }
}
