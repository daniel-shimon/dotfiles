function grab-session -d "Attach to a tmux session in the current pane via a grouped session"
    if test (count $argv) -lt 1
        echo "Usage: grab-session <tmux-session-name>"
        echo ""
        echo "Attaches to a tmux session in the current pane via a grouped session."
        echo "Ctrl+G, D to detach."
        return 1
    end

    set -l target $argv[1]
    set -l grab_name "grab_{$target}_{$fish_pid}_(random)"

    # Verify target session exists
    if not TMUX= tmux has-session -t "$target" 2>/dev/null
        echo "Error: tmux session '$target' not found"
        echo ""
        echo "Available sessions:"
        TMUX= tmux list-sessions -F '  #{session_name}' 2>/dev/null; or echo "  (none)"
        return 1
    end

    # Create grouped session
    TMUX= tmux new-session -d -s "$grab_name" -t "$target"

    # Configure: no status bar, Ctrl+G prefix
    TMUX= tmux set-option -t "$grab_name" status off
    TMUX= tmux set-option -t "$grab_name" prefix C-g
    TMUX= tmux set-option -t "$grab_name" prefix2 None
    TMUX= tmux bind-key -T prefix d detach-client

    # Show detach instructions briefly (background so it doesn't block attach)
    fish -c "sleep 0.1; TMUX= tmux display-message -t '$grab_name' -d 3000 'Grabbed \'$target\' -- Ctrl+G, D to detach'" &

    # Attach (cleanup on exit)
    TMUX= tmux attach-session -t "$grab_name"
    TMUX= tmux kill-session -t "$grab_name" 2>/dev/null; or true
    exit
end
