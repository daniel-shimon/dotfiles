function timeit --wraps="'python -m timeit'" --description 'alias timeit=python -m timeit'
  python -m timeit $argv
        
end
