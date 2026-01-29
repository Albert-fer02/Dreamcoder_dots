use ratatui::{
    layout::{Constraint, Direction, Layout, Alignment},
    style::{Color, Modifier, Style},
    text::{Line, Span},
    widgets::{Block, Borders, List, ListItem, Paragraph, Wrap},
    Frame,
};
use crate::ui::App;

pub fn draw(f: &mut Frame, app: &mut App) {
    let size = f.area();
    
    // Theme Colors
    let cyan = Color::Rgb(0, 229, 255);
    let gold = Color::Rgb(255, 209, 102);
    let gray = Color::Rgb(100, 100, 100);

    let chunks = Layout::default()
        .direction(Direction::Vertical)
        .constraints([
            Constraint::Length(3),
            Constraint::Min(10),
            Constraint::Length(3),
        ])
        .split(size);

    // --- Header ---
    let header_text = format!("🚀 DREAMCODER INSTALLER v6.0 | Host: {}", app.sys_info.hostname);
    let header = Paragraph::new(header_text)
        .style(Style::default().fg(cyan).add_modifier(Modifier::BOLD))
        .alignment(Alignment::Center)
        .block(Block::default().borders(Borders::ALL).border_style(Style::default().fg(cyan)));
    f.render_widget(header, chunks[0]);

    // --- Body ---
    if !app.installing {
        let body_chunks = Layout::default()
            .direction(Direction::Horizontal)
            .constraints([Constraint::Percentage(50), Constraint::Percentage(50)])
            .split(chunks[1]);

        // Module List
        let items: Vec<ListItem> = app.modules.iter().map(|m| {
            let checkbox = if m.selected { "[x] " } else { "[ ] " };
            let style = if m.selected { Style::default().fg(gold) } else { Style::default().fg(gray) };
            ListItem::new(Line::from(vec![
                Span::styled(checkbox, style),
                Span::raw(&m.name),
            ]))
        }).collect();

        let list = List::new(items)
            .block(Block::default().title(" Modules ").borders(Borders::ALL))
            .highlight_style(Style::default().bg(Color::Rgb(30, 30, 30)).add_modifier(Modifier::BOLD))
            .highlight_symbol(">> ");
        
        f.render_stateful_widget(list, body_chunks[0], &mut app.state);

        // System Info & Description
        let selected_idx = app.state.selected().unwrap_or(0);
        let desc = &app.modules[selected_idx].description;
        
        let sys_status = format!(
            "OS: {}\nArch: {}\nWSL: {}\n\n💡 Advice: {}\n\n--- Module ---\n{}\n\n[Space] Toggle | [Enter] Deploy",
            app.sys_info.os, app.sys_info.arch, app.sys_info.is_wsl, app.sys_info.get_senior_advice(), desc
        );

        let info = Paragraph::new(sys_status)
            .wrap(Wrap { trim: true })
            .block(Block::default().title(" System & Details ").borders(Borders::ALL).border_style(Style::default().fg(gold)));
        f.render_widget(info, body_chunks[1]);

    } else {
        // Installation Progress & Logs
        let progress_chunks = Layout::default()
            .direction(Direction::Vertical)
            .constraints([Constraint::Length(3), Constraint::Min(5)])
            .split(chunks[1]);

        let progress_block = Paragraph::new(format!("Deploying modules: {}%", app.progress))
            .alignment(Alignment::Center)
            .block(Block::default().title(" Installation ").borders(Borders::ALL).border_style(Style::default().fg(cyan)));
        f.render_widget(progress_block, progress_chunks[0]);

        let log_content: String = app.logs.join("\n");
        let logs = Paragraph::new(log_content)
            .block(Block::default().title(" Deployment Logs ").borders(Borders::ALL).border_style(Style::default().fg(gray)));
        f.render_widget(logs, progress_chunks[1]);
    }

    // --- Footer ---
    let footer_text = if !app.installing {
        " [Space] Toggle | [Enter] Install | [t] Trainer | [q] Quit "
    } else {
        " [q] Quit Installation Overview "
    };

    let footer = Paragraph::new(footer_text)
        .style(Style::default().fg(gray).add_modifier(Modifier::DIM))
        .alignment(Alignment::Center)
        .block(Block::default().borders(Borders::TOP));
    f.render_widget(footer, chunks[2]);
}
