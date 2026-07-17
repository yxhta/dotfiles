mod app;
mod fuzzy;
mod herdr;
mod ui;

use std::env;
use std::process::{Command, ExitCode};
use std::time::{Duration, Instant};

use ratatui::crossterm::event::{self, Event, KeyCode, KeyEventKind, KeyModifiers};
use ratatui::DefaultTerminal;

use app::{App, Mode};
use herdr::Client;

/// Redraw cadence; 100ms keeps the working-status spinner at ~10fps.
const POLL_INTERVAL: Duration = Duration::from_millis(100);
const LIST_REFRESH: Duration = Duration::from_secs(2);
const PREVIEW_REFRESH: Duration = Duration::from_secs(1);

fn main() -> ExitCode {
    let args: Vec<String> = env::args().skip(1).collect();
    match args.first().map(String::as_str) {
        None => run_picker(),
        Some("--open") => open_picker_pane(),
        Some("--help" | "-h") => {
            println!("agents-picker          run the picker TUI (inside a herdr plugin pane)");
            println!("agents-picker --open   open the picker pane via the herdr CLI");
            ExitCode::SUCCESS
        }
        Some(other) => {
            eprintln!("agents-picker: unknown argument: {other}");
            ExitCode::from(2)
        }
    }
}

/// Action entrypoint: ask herdr to open our own picker pane. This is what a
/// `plugin_action` keybinding invokes.
fn open_picker_pane() -> ExitCode {
    let bin = env::var("HERDR_BIN_PATH").unwrap_or_else(|_| "herdr".to_string());
    let plugin = env::var("HERDR_PLUGIN_ID").unwrap_or_else(|_| "yxhta.agents-picker".to_string());
    let status = Command::new(&bin)
        .args([
            "plugin",
            "pane",
            "open",
            "--plugin",
            &plugin,
            "--entrypoint",
            "picker",
            "--focus",
        ])
        .status();
    match status {
        Ok(status) if status.success() => ExitCode::SUCCESS,
        Ok(_) => ExitCode::FAILURE,
        Err(error) => {
            eprintln!("agents-picker: failed to run {bin}: {error}");
            ExitCode::FAILURE
        }
    }
}

fn run_picker() -> ExitCode {
    let client = Client::from_env();
    let mut app = App::new(env::var("HOME").ok(), env::var("HERDR_PANE_ID").ok());
    if let Ok(index) = client.workspace_index() {
        app.set_workspace_index(index);
    }
    match client.list_agents() {
        Ok(agents) => app.set_agents(agents),
        Err(error) => app.error = Some(error.to_string()),
    }

    let mut terminal = ratatui::init();
    let result = event_loop(&mut terminal, &mut app, &client);
    ratatui::restore();

    match result {
        Ok(Some(target)) => match client.focus_agent(&target) {
            Ok(()) => ExitCode::SUCCESS,
            Err(error) => {
                eprintln!("agents-picker: {error}");
                ExitCode::FAILURE
            }
        },
        Ok(None) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("agents-picker: {error}");
            ExitCode::FAILURE
        }
    }
}

/// Runs until the user picks an agent (returns its target) or cancels
/// (returns None). The agent list and pane preview refresh periodically.
fn event_loop(
    terminal: &mut DefaultTerminal,
    app: &mut App,
    client: &Client,
) -> std::io::Result<Option<String>> {
    let mut listed_at = Instant::now();
    // `preview_for` starts as None, so the first draw with a selection
    // refreshes immediately; no need to backdate the timestamp.
    let mut previewed_at = Instant::now();
    let mut preview_for: Option<String> = None;

    loop {
        refresh_preview(app, client, &mut preview_for, &mut previewed_at);
        terminal.draw(|frame| ui::draw(frame, app))?;

        if event::poll(POLL_INTERVAL)? {
            if let Event::Key(key) = event::read()? {
                if key.kind != KeyEventKind::Press {
                    continue;
                }
                let ctrl = key.modifiers.contains(KeyModifiers::CONTROL);
                if ctrl && matches!(key.code, KeyCode::Char('c' | 'g')) {
                    return Ok(None);
                }
                if key.code == KeyCode::Enter {
                    if let Some(target) = app.selected_agent().and_then(|a| a.target()) {
                        return Ok(Some(target.to_string()));
                    }
                    continue;
                }
                match app.mode {
                    Mode::Navigate => match key.code {
                        KeyCode::Esc | KeyCode::Char('q') => return Ok(None),
                        KeyCode::Char('/') => app.enter_search(),
                        KeyCode::Up | KeyCode::Char('k') => app.move_selection(-1),
                        KeyCode::Down | KeyCode::Char('j') => app.move_selection(1),
                        KeyCode::Char('p') if ctrl => app.move_selection(-1),
                        KeyCode::Char('n') if ctrl => app.move_selection(1),
                        KeyCode::Char('r') => {
                            reload_agents(app, client);
                            listed_at = Instant::now();
                        }
                        KeyCode::Char('u') if ctrl => app.clear_filter(),
                        _ => {}
                    },
                    Mode::Search => match key.code {
                        KeyCode::Esc => app.cancel_search(),
                        KeyCode::Up => app.move_selection(-1),
                        KeyCode::Down => app.move_selection(1),
                        KeyCode::Char('p' | 'k') if ctrl => app.move_selection(-1),
                        KeyCode::Char('n' | 'j') if ctrl => app.move_selection(1),
                        KeyCode::Char('r') if ctrl => {
                            reload_agents(app, client);
                            listed_at = Instant::now();
                        }
                        KeyCode::Char('u') if ctrl => app.clear_filter(),
                        KeyCode::Char('w') if ctrl => app.pop_word(),
                        KeyCode::Backspace => app.pop_char(),
                        KeyCode::Char(c) if !ctrl => app.push_char(c),
                        _ => {}
                    },
                }
            }
        }

        if listed_at.elapsed() >= LIST_REFRESH {
            reload_agents(app, client);
            listed_at = Instant::now();
        }
    }
}

fn reload_agents(app: &mut App, client: &Client) {
    // Best-effort: a stale workspace/tab index just shows an old label, so
    // errors here don't need to surface through `app.error`.
    if let Ok(index) = client.workspace_index() {
        app.set_workspace_index(index);
    }
    match client.list_agents() {
        Ok(agents) => {
            app.set_agents(agents);
            app.error = None;
        }
        Err(error) => app.error = Some(error.to_string()),
    }
}

fn refresh_preview(
    app: &mut App,
    client: &Client,
    preview_for: &mut Option<String>,
    previewed_at: &mut Instant,
) {
    // Compare as &str first so the unchanged-selection fast path (every
    // 100ms tick) never allocates.
    let wanted = app.selected_agent().and_then(|agent| agent.target());
    let stale = previewed_at.elapsed() >= PREVIEW_REFRESH;
    if wanted == preview_for.as_deref() && !stale {
        return;
    }
    let preview = match wanted {
        Some(target) => client
            .read_agent(target)
            .unwrap_or_else(|error| format!("preview unavailable: {error}")),
        None => String::new(),
    };
    *preview_for = wanted.map(str::to_string);
    app.preview = preview;
    *previewed_at = Instant::now();
}
