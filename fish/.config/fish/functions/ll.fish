function ll --wraps=ls --wraps='ls -ahlsi --color=auto --group-directories-first' --description 'alias ll=ls -ahlsi --color=auto --group-directories-first'
    ls -ahlsi --color=auto --group-directories-first $argv
end
