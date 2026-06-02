function arg --description 'Get n-th argument of each space-delimited line' --no-scope-shadowing --argument-names n
     pyp "line.split()[$n]"; 
end
