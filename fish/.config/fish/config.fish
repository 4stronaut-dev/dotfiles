if status is-interactive
    # Commands to run in interactive sessions can go here

end

function fish_greeting
    fastfetch
end

starship init fish | source

set -x LIBVIRT_DEFAULT_URI qemu:///system
