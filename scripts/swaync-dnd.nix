{ pkgs, ... }:
pkgs.writeShellScriptBin "auto-dnd" ''
  exec 1> >(tee -a /tmp/auto-dnd.log)
  exec 2>&1
  
  set -x

  echo "Script started at $(date)"
  
  for pid in $(pidof -o %PPID -x auto-dnd); do
    echo "Killing old process $pid"
    kill $pid
  done

  trap 'toggle_dnd off; echo "Script terminated at $(date)"' EXIT

  toggle_dnd() {
    if [ "$1" = "on" ]; then
      swaync-client --dnd-on
      echo "DND turned on at $(date)"
    else
      swaync-client --dnd-off
      echo "DND turned off at $(date)"
    fi
  }

  check_sharing() {
    local pw_output
    pw_output=$(${pkgs.pipewire}/bin/pw-cli ls)
    echo "pw-cli output: $pw_output"
    
    echo "$pw_output" | grep -q "media.class = \"Stream/Input/Video\"\|media.class = \"Stream/Input/Screen\""
    local result=$?
    echo "check_sharing returned $result at $(date)"
    return $result
  }

  SOCKET_PATH="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
  echo "Looking for socket at: $SOCKET_PATH"

  if [ ! -S "$SOCKET_PATH" ]; then
    echo "Socket not found!"
    ls -la "$XDG_RUNTIME_DIR/hypr/" || echo "Cannot list hypr directory"
    exit 1
  fi

  echo "Socket found, starting monitoring..."

  # Initial state check
  if check_sharing; then
    toggle_dnd on
  else
    toggle_dnd off
  fi

  echo "Starting socat to monitor events..."
  ${pkgs.socat}/bin/socat -v -u UNIX-CONNECT:"$SOCKET_PATH" - | while read -r line; do
    echo "$(date): Received event: $line"
    
    # Check for screencast events
    if [[ ''${line} == *"screencast>>"* ]]; then
      echo "Detected screencast event, checking state"
      if [[ ''${line} == *"screencast>>0,0"* ]]; then
        echo "Screencast stopped, checking sharing status"
        sleep 1
        if ! check_sharing; then
          echo "No active sharing detected, turning DND off"
          toggle_dnd off
        fi
      fi
    elif [[ ''${line} == *"screenshare"* ]] || 
         [[ ''${line} == *"screen share"* ]] || 
         [[ ''${line} == *"Screen Share"* ]] || 
         [[ ''${line} == *"capture"* ]] || 
         [[ ''${line} == *"Capture"* ]]; then
      echo "Detected screen sharing related event"
      if check_sharing; then
        toggle_dnd on
      fi
    fi
  done &

  # Keep the script running and log PID
  echo "Script running with PID $$"
  wait
''
