use ratatui::layout::{Constraint, Layout, Position, Rect};
use ratatui::style::{Color, Modifier, Style, Stylize};
use ratatui::text::{Line, Span};
use ratatui::widgets::{Block, BorderType, Borders, Cell, Paragraph, Row, Table};
use ratatui::Frame;

use crate::app::{App, Mode};

/// Braille spinner for agents that are actively working; one frame per
/// `App::spinner_tick` (~100ms).
const SPINNER: [&str; 10] = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];

pub fn draw(frame: &mut Frame, app: &mut App) {
    let [main_area, footer_area] =
        Layout::vertical([Constraint::Min(1), Constraint::Length(1)]).areas(frame.area());
    let [picker_area, preview_area] =
        Layout::horizontal([Constraint::Percentage(50), Constraint::Percentage(50)])
            .areas(main_area);

    draw_picker(frame, app, picker_area);
    draw_preview(frame, app, preview_area);
    draw_footer(frame, app, footer_area);
}

/// Left panel: filter input and agent list inside a single block, so the
/// picker reads as one surface instead of two stacked boxes.
fn draw_picker(frame: &mut Frame, app: &mut App, area: Rect) {
    let count = format!(" {}/{} ", app.filtered.len(), app.agents.len());
    let block = Block::bordered()
        .border_type(BorderType::Rounded)
        .border_style(Style::new().dim())
        .title(" Agents ")
        .title(Line::from(count).right_aligned().dim());
    let inner = block.inner(area);
    frame.render_widget(block, area);

    let [input_area, rule_area, list_area] = Layout::vertical([
        Constraint::Length(1),
        Constraint::Length(1),
        Constraint::Min(1),
    ])
    .areas(inner);

    draw_input(frame, app, input_area);
    frame.render_widget(
        Block::new()
            .borders(Borders::TOP)
            .border_style(Style::new().dim()),
        rule_area,
    );
    draw_list(frame, app, list_area);
}

fn draw_input(frame: &mut Frame, app: &App, area: Rect) {
    let line = match app.mode {
        Mode::Search => Line::from(vec![
            Span::styled("❯ ", Style::new().cyan().bold()),
            Span::raw(app.filter.as_str()),
        ]),
        Mode::Navigate => Line::from(vec![
            Span::styled("❯ ", Style::new().dim()),
            Span::styled("/ to filter", Style::new().dim().italic()),
        ]),
    };
    frame.render_widget(Paragraph::new(line), area);
    if app.mode == Mode::Search {
        let filter_width = u16::try_from(app.filter.chars().count()).unwrap_or(u16::MAX);
        frame.set_cursor_position(Position::new(
            area.x.saturating_add(2).saturating_add(filter_width),
            area.y,
        ));
    }
}

fn draw_list(frame: &mut Frame, app: &mut App, area: Rect) {
    if app.agents.is_empty() {
        empty_state(frame, area, "No agent panes found", "r reload · q close");
        return;
    }
    if app.filtered.is_empty() {
        let message = format!("No matches for \"{}\"", app.filter);
        empty_state(frame, area, &message, "esc clears the filter");
        return;
    }

    let tick = app.spinner_tick();
    // Rows borrow the cached per-agent strings, so take the table state out
    // for the stateful render instead of fighting the borrow checker.
    let mut table_state = std::mem::take(&mut app.table_state);
    let rows = app.filtered.iter().enumerate().map(|(row, &i)| {
        let agent = &app.agents[i];
        let kind = agent.kind();
        let label = app.label(i);
        let location = app.location(i);
        let cwd = app.cwd(i);

        // Cached matched-char indices into the search text, which
        // concatenates the same strings as the visible columns:
        // "kind label location cwd".
        let indices = app.highlights(row);
        let label_offset = kind.chars().count() + 1;
        let location_offset = label_offset + label.chars().count() + 1;
        let cwd_offset = location_offset + location.chars().count() + 1;

        let mut label_line = highlight_line(label, label_offset, indices, Style::new());
        if agent.focused {
            label_line.push_span(Span::styled(" (focused)", Style::new().dim()));
        }

        Row::new(vec![
            Cell::from(Span::styled(
                status_glyph(agent.status(), tick),
                status_style(agent.status()),
            )),
            Cell::from(highlight_line(
                location,
                location_offset,
                indices,
                Style::new(),
            )),
            Cell::from(highlight_line(kind, 0, indices, Style::new().dim())),
            Cell::from(label_line),
            Cell::from(highlight_line(cwd, cwd_offset, indices, Style::new().dim())),
        ])
    });

    let table = Table::new(
        rows,
        [
            Constraint::Length(1),
            Constraint::Fill(2),
            Constraint::Length(6),
            Constraint::Fill(3),
            Constraint::Fill(2),
        ],
    )
    .column_spacing(1)
    .row_highlight_style(Style::new().add_modifier(Modifier::REVERSED));

    frame.render_stateful_widget(table, area, &mut table_state);
    app.table_state = table_state;
}

fn draw_preview(frame: &mut Frame, app: &App, area: Rect) {
    let block = Block::bordered()
        .border_type(BorderType::Rounded)
        .border_style(Style::new().dim());
    if let Some(index) = app.selected_index() {
        let agent = &app.agents[index];
        let title = Line::from(vec![
            Span::raw(" "),
            Span::styled(
                status_glyph(agent.status(), app.spinner_tick()),
                status_style(agent.status()),
            ),
            Span::raw(format!(" {} · {} ", agent.kind(), agent.status())),
        ]);
        let cwd = Line::from(format!(" {} ", app.cwd(index)))
            .right_aligned()
            .dim();
        let preview =
            Paragraph::new(app.preview.as_str()).block(block.title(title).title_bottom(cwd));
        frame.render_widget(preview, area);
    } else {
        let inner = block.inner(area);
        frame.render_widget(block.title(Line::from(" Preview ").dim()), area);
        empty_state(frame, inner, "Nothing to preview", "");
    }
}

fn draw_footer(frame: &mut Frame, app: &App, area: Rect) {
    let line = match &app.error {
        Some(error) => Line::from(vec![
            Span::styled(" ✗ ", Style::new().fg(Color::Red).bold()),
            Span::styled(error.as_str(), Style::new().fg(Color::Red)),
        ]),
        None => match app.mode {
            Mode::Navigate => hint_line(&[
                ("enter", "focus"),
                ("j/k", "move"),
                ("/", "filter"),
                ("r", "reload"),
                ("q", "close"),
            ]),
            Mode::Search => hint_line(&[
                ("enter", "focus"),
                ("esc", "cancel"),
                ("↑/↓", "move"),
                ("^u", "clear"),
                ("^w", "delete word"),
            ]),
        },
    };
    frame.render_widget(Paragraph::new(line), area);
}

/// Key hints: keys at normal brightness, actions dimmed, so the keys are what
/// the eye lands on when scanning the footer.
fn hint_line(hints: &[(&'static str, &'static str)]) -> Line<'static> {
    let mut spans = Vec::with_capacity(hints.len() * 4 + 1);
    spans.push(Span::raw(" "));
    for (i, &(key, action)) in hints.iter().enumerate() {
        if i > 0 {
            spans.push(Span::raw("  "));
        }
        spans.push(Span::raw(key));
        spans.push(Span::raw(" "));
        spans.push(Span::styled(action, Style::new().dim()));
    }
    Line::from(spans)
}

/// Centered placeholder for empty list/preview areas, with an optional dimmed
/// hint on how to get out of the state.
fn empty_state(frame: &mut Frame, area: Rect, message: &str, hint: &str) {
    let mut lines = vec![Line::raw(""); usize::from(area.height / 3)];
    lines.push(Line::from(message));
    if !hint.is_empty() {
        lines.push(Line::raw(""));
        lines.push(Line::from(hint).dim());
    }
    frame.render_widget(Paragraph::new(lines).centered(), area);
}

/// Render `text` with fuzzy-matched chars emphasized. `offset` is where
/// `text` starts (in chars) inside the string `indices` was computed against.
/// Spans borrow byte ranges of `text`, so this never copies the string.
fn highlight_line<'a>(text: &'a str, offset: usize, indices: &[usize], base: Style) -> Line<'a> {
    if indices.is_empty() {
        return Line::from(Span::styled(text, base));
    }
    let matched_style = Style::new().fg(Color::Cyan).add_modifier(Modifier::BOLD);
    let style_for = |matched: bool| if matched { matched_style } else { base };

    let mut spans: Vec<Span<'a>> = Vec::new();
    let mut run_start = 0;
    let mut run_matched = false;
    for (i, (byte_start, _)) in text.char_indices().enumerate() {
        let matched = indices.binary_search(&(offset + i)).is_ok();
        if i == 0 {
            run_matched = matched;
        } else if matched != run_matched {
            spans.push(Span::styled(
                &text[run_start..byte_start],
                style_for(run_matched),
            ));
            run_start = byte_start;
            run_matched = matched;
        }
    }
    if !text.is_empty() {
        spans.push(Span::styled(&text[run_start..], style_for(run_matched)));
    }
    Line::from(spans)
}

/// Status shapes differ (not just colors) so states stay distinguishable
/// without color vision: spinner=working, ●=blocked, ✓=done, ○=idle.
fn status_glyph(status: &str, tick: usize) -> &'static str {
    match status {
        "working" => SPINNER[tick % SPINNER.len()],
        "blocked" => "●",
        "done" => "✓",
        "idle" => "○",
        _ => "·",
    }
}

fn status_style(status: &str) -> Style {
    let color = match status {
        "working" => Color::Yellow,
        "blocked" => Color::Red,
        "done" => Color::Green,
        "idle" => Color::Blue,
        _ => Color::DarkGray,
    };
    Style::new().fg(color)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::herdr::parse_agent_list;
    use ratatui::backend::TestBackend;
    use ratatui::Terminal;

    fn sample_app() -> App {
        let agents = parse_agent_list(
            r#"{"result":{"agents":[
                {"agent":"claude","agent_status":"working","cwd":"/w/dotfiles","focused":true,
                 "pane_id":"w1:p1","terminal_id":"term_1","terminal_title_stripped":"dotfiles work"},
                {"agent":"codex","agent_status":"idle","cwd":"/w/dealon",
                 "pane_id":"w2:p1","terminal_id":"term_2","terminal_title_stripped":"dealon review"}
            ]}}"#,
        )
        .unwrap();
        let mut app = App::new(None, None);
        app.set_agents(agents);
        app
    }

    fn render(app: &mut App, width: u16, height: u16) -> String {
        let mut terminal = Terminal::new(TestBackend::new(width, height)).unwrap();
        let frame = terminal.draw(|frame| draw(frame, app)).unwrap();
        frame
            .buffer
            .clone()
            .content
            .iter()
            .map(ratatui::buffer::Cell::symbol)
            .collect()
    }

    #[test]
    fn draws_the_agent_list_with_status_and_count() {
        let mut app = sample_app();
        let screen = render(&mut app, 200, 20);
        assert!(screen.contains("2/2"));
        assert!(screen.contains("dotfiles work"));
        assert!(screen.contains("(focused)"));
        assert!(screen.contains("○")); // idle codex
    }

    #[test]
    fn draws_empty_and_no_match_states() {
        let mut app = App::new(None, None);
        let screen = render(&mut app, 100, 20);
        assert!(screen.contains("No agent panes found"));
        assert!(screen.contains("Nothing to preview"));

        let mut app = sample_app();
        app.enter_search();
        for c in "zzz".chars() {
            app.push_char(c);
        }
        let screen = render(&mut app, 100, 20);
        assert!(screen.contains("No matches for \"zzz\""));
    }

    #[test]
    fn search_mode_shows_the_filter_and_hints() {
        let mut app = sample_app();
        app.enter_search();
        for c in "deal".chars() {
            app.push_char(c);
        }
        let screen = render(&mut app, 100, 20);
        assert!(screen.contains("❯ deal"));
        assert!(screen.contains("1/2"));
        assert!(screen.contains("esc cancel"));
    }

    #[test]
    fn survives_tiny_terminals() {
        let mut app = sample_app();
        render(&mut app, 8, 3);
        render(&mut app, 1, 1);
    }
}
