$env.config = {
  show_banner: false
  keybindings: []
  shell_integration: true
}
$env.PATH = ($env.PATH | split row (char esep))
$env.PATH = ($env.PATH | prepend  "${homeDirectory}/.local/bin")

def ghash [] {git rev-parse HEAD | tr -d '\\n' | wl-copy; git rev-parse HEAD}