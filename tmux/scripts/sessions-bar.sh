#!/bin/bash
s=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)
c=$(tmux display-message -p '#{session_name}')
n=1
for s in $s; do
    [ "$s" = "$c" ] && echo -n "#[fg=green]>${n}:${s}< " || echo -n "#[fg=cyan]${n}:${s} "
    n=$((n+1))
done