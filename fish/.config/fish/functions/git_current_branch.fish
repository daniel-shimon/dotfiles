function git_current_branch --wraps='fish_git_prompt \\* | cut -d\\* -f2' --wraps='git rev-parse --abbrev-ref HEAD' --description 'alias git_current_branch=git rev-parse --abbrev-ref HEAD'
  git rev-parse --abbrev-ref HEAD $argv
        
end
