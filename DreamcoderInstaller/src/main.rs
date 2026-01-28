use color_eyre::Result;
use crossterm::event::{self, Event, KeyCode};
use ratatui::{
    layout::{Constraint, Direction, Layout, Rect},
    style::{Color, Modifier, Style},
    text::{Line, Span},
    widgets::{Block, Borders, List, ListItem, ListState, Paragraph, Wrap},
    DefaultTerminal,
};

struct Module {
    name: String,
    description: String,
    selected: bool,
}

struct App {
    modules: Vec<Module>,
    state: ListState,
    installing: bool,
    progress: u16,
}

impl App {
    fn new() -> App {
        let modules = vec![
            Module { name: "DreamcoderNvim".to_string(), description: "🧠 Senior IDE (LazyVim + Node Fix)".to_string(), selected: true },
            Module { name: "DreamcoderShell".to_string(), description: "🐚 Zsh, Bash, Starship & Aliases".to_string(), selected: true },
            Module { name: "DreamcoderFish".to_string(), description: "🐟 Modern Shell (Fast, Auto-suggest)".to_string(), selected: false },
            Module { name: "DreamcoderZellij".to_string(), description: "🦀 Rust-native Multiplexer (KDL)".to_string(), selected: true },
            Module { name: "DreamcoderGhostty".to_string(), description: "👻 High-perf Terminal & Shaders".to_string(), selected: false },
            Module { name: "DreamcoderKitty".to_string(), description: "🐱 GPU-accelerated Terminal".to_string(), selected: false },
            Module { name: "DreamcoderTmux".to_string(), description: "🗂️ Classic Session Manager".to_string(), selected: false },
            Module { name: "DreamcoderFastfetch".to_string(), description: "📊 System Identity Branding".to_string(), selected: true },
        ];
        let mut state = ListState::default();
        state.select(Some(0));
        App {
            modules,
            state,
            installing: false,
            progress: 0,
        }
    }

    fn toggle_selected(&mut self) {
        if let Some(i) = self.state.selected() {
            self.modules[i].selected = !self.modules[i].selected;
        }
    }

    fn next(&mut self) {
        let i = match self.state.selected() {
            Some(i) => {
                if i >= self.modules.len() - 1 {
                    0
                } else {
                    i + 1
                }
            }
            None => 0,
        };
        self.state.select(Some(i));
    }

    fn previous(&mut self) {
        let i = match self.state.selected() {
            Some(i) => {
                if i == 0 { self.modules.len() - 1 } else { i - 1 }
            }
            None => 0,
        };
        self.state.select(Some(i));
    }
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let mut terminal = ratatui::init();
    let app_result = run_app(&mut terminal, App::new());
    ratatui::restore();
    app_result
}

fn run_app(terminal: &mut DefaultTerminal, mut app: App) -> Result<()> {
    loop {
        terminal.draw(|f| ui(f, &mut app))?;

        if let Event::Key(key) = event::read()? {
            if app.installing {
                if let KeyCode::Char('q') = key.code { return Ok(()); }
                continue;
            }

            match key.code {
                KeyCode::Char('q') => return Ok(()),
                KeyCode::Down | KeyCode::Char('j') => app.next(),
                KeyCode::Up | KeyCode::Char('k') => app.previous(),
                KeyCode::Char(' ') => app.toggle_selected(),
                KeyCode::Enter => {
                    app.installing = true;
                    // Logic for real installation will be hooked here
                }
                _ => {}
            }
        }
        
        if app.installing && app.progress < 100 {
            app.progress += 1;
            // Simulated delay for UI feel
            std::thread::sleep(std::time::Duration::from_millis(20));
        }
    }
}

fn ui(f: &mut ratatui::Frame, app: &mut App) {
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
    let header = Paragraph::new("🚀 DREAMCODER INSTALLER v5.0")
        .style(Style::default().fg(cyan).add_modifier(Modifier::BOLD))
        .alignment(ratatui::layout::Alignment::Center)
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
            .highlight_symbol(">>> ");
        
        f.render_stateful_widget(list, body_chunks[0], &mut app.state);

        // Description Box
        let selected_idx = app.state.selected().unwrap_or(0);
        let desc = &app.modules[selected_idx].description;
        let info = Paragraph::new(format!("\n{}\n\nUse [Space] to toggle\nUse [Enter] to start deployment", desc))
            .wrap(Wrap { trim: true })
            .block(Block::default().title(" Description ").borders(Borders::ALL).border_style(Style::default().fg(gold)));
        f.render_widget(info, body_chunks[1]);

    } else {
        // Installation Progress View
        let install_msg = if app.progress < 100 {
            format!("Deploying modules: {}%", app.progress)
        } else {
            "✨ Deployment Complete! Press 'q' to exit.".to_string()
        };
        
        let progress_block = Paragraph::new(install_msg)
            .alignment(ratatui::layout::Alignment::Center)
            .block(Block::default().title(" Installation ").borders(Borders::ALL).border_style(Style::default().fg(cyan)));
        f.render_widget(progress_block, chunks[1]);
    }

    // --- Footer ---
    let footer = Paragraph::new(" Dreamcoder Logic | Arch Linux | Softwart Engineering ")
        .style(Style::default().fg(gray))
        .alignment(ratatui::layout::Alignment::Center);
    f.render_widget(footer, chunks[2]);
}
