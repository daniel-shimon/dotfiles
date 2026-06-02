if status is-interactive
    # Commands to run in interactive sessions can go here
    scheme set default
    fzf_configure_bindings --directory=ctrl-t
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

export EDITOR=nvim

export SDKROOT=$(xcrun --show-sdk-path)

pyenv init - fish | source

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
export PATH="/Applications/PyCharm.app/Contents/MacOS:$PATH"

set -x LESS "--mouse --wheel-lines=1"
set -x BAT_PAGER "less --mouse --wheel-lines=1 -RF"

# Work-specific env + functions load from a private repo via conf.d/ (auto-sourced).
# Secrets load from conf.d/secrets.fish (gitignored).
