pub mod system;
pub mod ui;
pub mod deploy;

use color_eyre::Result;
use crossterm::event::{self, Event, KeyCode};
use ratatui::DefaultTerminal;
use crate::ui::App;

fn main() -> Result<()> {
    color_eyre::install()?;
    let mut terminal = ratatui::init();
    
    // Detect system info on startup
    let sys_info = system::detect::SystemInfo::new();
    let app = App::new(sys_info);
    
    let app_result = run_app(&mut terminal, app);
    ratatui::restore();
    app_result
}

fn run_app(terminal: &mut DefaultTerminal, mut app: App) -> Result<()> {
    loop {
        terminal.draw(|f| ui::renderer::draw(f, &mut app))?;

        if let Event::Key(key) = event::read()? {
            // Handle Ctrl+C to exit immediately
            if key.modifiers.contains(event::KeyModifiers::CONTROL) && key.code == KeyCode::Char('c') {
                return Ok(());
            }

            if app.installing {
                if let KeyCode::Char('q') = key.code { return Ok(()); }
                continue;
            }

            match key.code {
                KeyCode::Char('q') | KeyCode::Esc => return Ok(()),
                KeyCode::Char('t') => {
                    // Placeholder for Trainer mode
                    app.add_log("Trainer Mode coming soon...".to_string());
                }
                KeyCode::Down | KeyCode::Char('j') => app.next(),
                KeyCode::Up | KeyCode::Char('k') => app.previous(),
                KeyCode::Char(' ') => app.toggle_selected(),
                KeyCode::Enter => {
                    app.installing = true;
                    app.add_log("Starting Master Deployment...".to_string());
                }
                _ => {}
            }
        }
        
        if app.installing && app.progress < 100 {
            app.progress += 1;
            
            // Real Deployment Logic hooked to progress percentages
            if app.progress == 20 {
                let dotfiles_dir = std::env::current_dir().unwrap().to_string_lossy().to_string();
                let selected_modules: Vec<String> = app.modules.iter()
                    .filter(|m| m.selected)
                    .map(|m| m.name.clone())
                    .collect();

                // Dependency Check for AI Neovim
                if selected_modules.contains(&"DreamcoderNvim".to_string()) {
                    app.add_log("Checking Neovim AI dependencies...".to_string());
                    let deps = vec!["make", "cargo", "npm", "rg", "fd"];
                    for dep in deps {
                        if std::process::Command::new("which").arg(dep).output().is_err() {
                            app.add_log(format!("⚠️ Missing dependency: {}", dep));
                        }
                    }
                }

                for module in selected_modules {
                    app.add_log(format!("Stowing {}...", module));
                    match crate::deploy::stow_module(&module, &dotfiles_dir) {
                        Ok(msg) => app.add_log(format!("✓ {}", msg)),
                        Err(e) => app.add_log(format!("✗ {}", e)),
                    }
                }
            }

            if app.progress == 90 {
                app.add_log("Running integrity audit...".to_string());
                // In a real scenario, we could call ./verify.sh here
            }

            if app.progress == 100 {
                app.add_log("✨ SYSTEM UPGRADED SUCCESSFULLY!".to_string());
            }

            std::thread::sleep(std::time::Duration::from_millis(20));
        }
    }
}