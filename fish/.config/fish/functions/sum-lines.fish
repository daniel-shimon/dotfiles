function sum-lines --wraps="'pyp '\\''sum(map(lambda l: int(l.strip()), lines))'\\'" --wraps="pyp 'sum(map(lambda l: int(l.strip()), lines))'" --description "alias sum-lines=pyp 'sum(map(lambda l: int(l.strip()), lines))'"
  pyp 'sum(map(lambda l: int(l.strip()), lines))' $argv
        
end
