function current_commit --wraps="'git rev-parse HEAD'" --wraps='git rev-parse HEAD' --description 'alias current_commit=git rev-parse HEAD'
  git rev-parse HEAD $argv
        
end
