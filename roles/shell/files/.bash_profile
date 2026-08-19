# ~/.bash_profile
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# fastfetch is installed by the `terminal` role; guard it so login shells on
# boxes without it don't print a command-not-found every login.
command -v fastfetch >/dev/null 2>&1 && fastfetch
