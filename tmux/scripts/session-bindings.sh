#!/bin/bash

sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)
count=0

for session in $sessions; do
    if [ $count -lt 10 ]; then
        tmux bind-key $count switch-client -t "$session" -n
        echo "Bound $count -> $session"
        count=$((count + 1))
    fi
done