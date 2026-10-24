#!/usr/bin/env python3
import json, subprocess, os, socket, sys, time

WAYBAR_CONFIG = os.path.expanduser("~/.config/waybar/config.jsonc")

def get_ipc_socket():
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if not sig:
        raise RuntimeError("HYPRLAND_INSTANCE_SIGNATURE not set")
    xdg_runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    path = os.path.join(xdg_runtime, "hypr", sig, ".socket2.sock")

    for attempt in range(10):
        try:
            sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            sock.connect(path)
            sock.sendall(b"2\n")
            return sock
        except (ConnectionRefusedError, FileNotFoundError):
            time.sleep(0.05)
    raise RuntimeError(f"Could not connect to {path}")   

def check_fullscreen():
    result = subprocess.run("hyprctl clients -j", shell=True, capture_output=True, text=True)
    for m in json.loads(result.stdout):
        if m.get("fullscreen", 0) > 1:
            return True
    return False

def set_all_outputs(value):
    with open(WAYBAR_CONFIG, "r") as f:
        content = f.read()
    old = '"all-outputs": true' if not value else '"all-outputs": false'
    new = '"all-outputs": false' if not value else '"all-outputs": true'
    if old in content:
        content = content.replace(old, new)
        with open(WAYBAR_CONFIG, "w") as f:
            f.write(content)
        subprocess.run(["pkill", "-SIGUSR2", "waybar"])

def main():
    sock = get_ipc_socket()
    last_state = check_fullscreen()
    buf = b""
    while True:
        data = sock.recv(4096)
        if not data:
            break
        buf += data
        while b"\n" in buf:
            line, buf = buf.split(b"\n", 1)
            event = line.decode(errors="ignore")
            if event.startswith("fullscreen"):
                state = check_fullscreen()
                if state != last_state:
                    set_all_outputs(state)
                    last_state = state

if __name__ == "__main__":
    main()
