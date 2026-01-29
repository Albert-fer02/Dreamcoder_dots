use execute::Execute;
use std::process::Command;

pub fn stow_module(module_name: &str, dotfiles_dir: &str) -> Result<String, String> {
    let mut command = Command::new("stow");
    command.arg("-v")
           .arg("-R")
           .arg("-t")
           .arg(std::env::var("HOME").unwrap_or_else(|_| "/".to_string()))
           .arg("-d")
           .arg(dotfiles_dir)
           .arg(module_name);

    if let Ok(output) = command.execute_output() {
        if output.status.success() {
            Ok(format!("Module {} deployed successfully.", module_name))
        } else {
            Err(format!("Stow failed for {}: {}", module_name, String::from_utf8_lossy(&output.stderr)))
        }
    } else {
        Err(format!("Could not execute 'stow'. Is it installed?"))
    }
}
