#!/bin/bash
sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)
current=$(tmux display-message -p '#{session_name}')

echo -n "#[fg=brightblue,bold]🖥  "
for session in $sessions; do
    if [ "$session" = "$current" ]; then
        echo -n "#[fg=green,bold]<$session>#[fg=white] "
    else
        echo -n "#[fg=cyan,bold]<#[link=switch-client -t '$session']$session#[none]>#[fg=white] "
    fi
done