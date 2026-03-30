function la --wraps=ls --wraps='ls -ah1 --color=auto --goup-directories-first' --wraps='ls -ah1 --color=auto --group-directories-first' --description 'alias la=ls -ah1 --color=auto --group-directories-first'
    ls -ah1 --color=auto --group-directories-first $argv
end
