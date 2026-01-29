pub mod renderer;

use ratatui::widgets::ListState;
use crate::system::detect::SystemInfo;

pub struct Module {
    pub name: String,
    pub description: String,
    pub selected: bool,
}

pub struct App {
    pub modules: Vec<Module>,
    pub state: ListState,
    pub installing: bool,
    pub progress: u16,
    pub sys_info: SystemInfo,
    pub logs: Vec<String>,
}

impl App {
    pub fn new(sys_info: SystemInfo) -> App {
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
            sys_info,
            logs: vec!["System Initialized...".to_string()],
        }
    }

    pub fn add_log(&mut self, msg: String) {
        self.logs.push(msg);
        if self.logs.len() > 10 {
            self.logs.remove(0);
        }
    }

    pub fn toggle_selected(&mut self) {
        if let Some(i) = self.state.selected() {
            self.modules[i].selected = !self.modules[i].selected;
        }
    }

    pub fn next(&mut self) {
        let i = match self.state.selected() {
            Some(i) => if i >= self.modules.len() - 1 { 0 } else { i + 1 },
            None => 0,
        };
        self.state.select(Some(i));
    }

    pub fn previous(&mut self) {
        let i = match self.state.selected() {
            Some(i) => if i == 0 { self.modules.len() - 1 } else { i - 1 },
            None => 0,
        };
        self.state.select(Some(i));
    }
}
