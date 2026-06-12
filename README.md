- clone this repo
- install packages dependencies; install `oh-my-zsh`, `zsh-completions` and `zsh-autosuggestions` following the instructions on their repos
- delete all relevant files in `~` and `~/.config/` that are present in this repo
- run `stow --dotfiles -t ~ <configs>` in this repo, with `<configs>` a space-separated list of subdirectories
for example `stow --dotfiles -t ~ zsh kitty micro starship`

`-t ~` sets the target directory, change it from `~` if your configs are somewhere else