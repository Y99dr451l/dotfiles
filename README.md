- clone this repo
- install packages dependencies; install `oh-my-zsh`, `zsh-completions` and `zsh-autosuggestions` following the instructions on their repos
- delete all relevant files in `~` and `~/.config/` that are present in this repo
- run `stow --dotfiles -t ~ <configs>` in this repo to symlink configs, for example `stow --dotfiles -t ~ zsh kitty micro starship`

`-t ~` sets the target directory, change it from `~` if your configs are somewhere else; `stow.sh` symlinks all configs to `~`

dependencies of `zsh`: `zsh`, `oh-my-zsh`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-history-substring-search`, `zoxide`, `starship`, `cbonsai`, (`yazi`, `kitty`)

dependencies of `hypr`: `hyprland`, `hyprlock`, `hypridle`, `hyprsunset`, `hyprpaper`, `hyprlauncher`, `waybar`, `uwsm`, (`kitty`, `dolphin`, `grim`, `slurp`, `hypr-dynamic-cursors`)