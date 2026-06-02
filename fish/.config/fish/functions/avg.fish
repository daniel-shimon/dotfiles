function avg --wraps='pyp "sum(map(float, lines))/len(lines)"' --description 'alias avg=pyp "sum(map(float, lines))/len(lines)"'
  pyp "sum(map(float, lines))/len(lines)" $argv
        
end
