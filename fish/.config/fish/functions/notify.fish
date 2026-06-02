function notify --description 'Persistent macOS notification dialog (stays on top until dismissed)'
    set -l message "🚀✅🔥🎉"
    set -l title "Done!"
    if set -q argv[1]
        set message $argv[1]
    end
    if set -q argv[2]
        set title $argv[2]
    end
    osascript -e 'beep 2' -e "tell application \"System Events\" to display dialog \"$message\" buttons {\"Dismiss\"} default button \"Dismiss\" with title \"$title\" giving up after 0" &
end
