use color_eyre::Result;
use ratatui::{
    layout::{Constraint, Direction, Layout},
    style::{Color, Modifier, Style},
    widgets::{Block, Borders, Paragraph},
    DefaultTerminal,
};
use crossterm::event::{self, Event, KeyCode};

fn main() -> Result<()> {
    color_eyre::install()?;
    let mut terminal = ratatui::init();
    let app_result = run_app(&mut terminal);
    ratatui::restore();
    app_result
}

fn run_app(terminal: &mut DefaultTerminal) -> Result<()> {
    loop {
        terminal.draw(|f| {
            let size = f.area();
            let chunks = Layout::default()
                .direction(Direction::Vertical)
                .margin(2)
                .constraints([
                    Constraint::Length(3),
                    Constraint::Min(0),
                    Constraint::Length(3),
                ])
                .split(size);

            let header = Paragraph::new("🚀 DREAMCODER INSTALLER v5.0 (RUST EDITION)")
                .style(Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD))
                .block(Block::default().borders(Borders::ALL));
            
            f.render_widget(header, chunks[0]);

            let body = Paragraph::new("Welcome, Dreamcoder.\n\nThis installer is powered by Rust & Ratatui.\nPress 'q' to exit the preview.")
                .block(Block::default().title(" Status ").borders(Borders::ALL));
            
            f.render_widget(body, chunks[1]);

            let footer = Paragraph::new("Built with ❤️ for Arch Linux Softwart Engineering")
                .style(Style::default().fg(Color::DarkGray))
                .block(Block::default().borders(Borders::TOP));
            
            f.render_widget(footer, chunks[2]);
        })?;

        if let Event::Key(key) = event::read()? {
            if let KeyCode::Char('q') = key.code {
                return Ok(());
            }
        }
    }
}