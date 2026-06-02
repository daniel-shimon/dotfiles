function notify3 --wraps='notify && sleep 1 && notify && sleep 1 && notify' --description 'alias notify3=notify && sleep 1 && notify && sleep 1 && notify'
  notify && sleep 1 && notify && sleep 1 && notify $argv
        
end
