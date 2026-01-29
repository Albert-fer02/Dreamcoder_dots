use os_info;
use sysinfo::System;

#[derive(Debug)]
pub struct SystemInfo {
    pub os: String,
    pub arch: String,
    pub hostname: String,
    pub is_wsl: bool,
}

impl SystemInfo {
    pub fn new() -> Self {
        let info = os_info::get();
        let mut sys = System::new_all();
        sys.refresh_all();

        let os_str = format!("{}", info.os_type());
        let is_wsl = std::fs::metadata("/proc/sys/fs/binfmt_misc/WSLInterop").is_ok() 
                  || std::env::var("WSL_DISTRO_NAME").is_ok();

        Self {
            os: os_str,
            arch: format!("{}", info.architecture().unwrap_or("unknown")),
            hostname: System::host_name().unwrap_or_else(|| "dreamcoder-host".to_string()),
            is_wsl,
        }
    }

    pub fn get_senior_advice(&self) -> String {
        let os_lower = self.os.to_lowercase();
        if self.is_wsl {
            "WSL Detected: I'll optimize win32yank for seamless clipboard sharing.".to_string()
        } else if os_lower.contains("arch") {
            "Arch Linux: The Master Race. I'll enable parallel pacman downloads.".to_string()
        } else if os_lower.contains("darwin") || os_lower.contains("mac") {
            "macOS Detected: Using Homebrew for package management. Optimizing for Retina display.".to_string()
        } else {
            "Universal Linux: Applying standard engineering optimizations.".to_string()
        }
    }
}
