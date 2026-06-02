function copy-ssh-key --wraps="'cat ~/.ssh/id_ed25519.pub | pbcopy'" --wraps='cat ~/.ssh/id_ed25519.pub | pbcopy' --description 'alias copy-ssh-key=cat ~/.ssh/id_ed25519.pub | pbcopy'
  cat ~/.ssh/id_ed25519.pub | pbcopy $argv
        
end
