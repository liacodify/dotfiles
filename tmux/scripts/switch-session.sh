#!/bin/bash
session_num=$1
session=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | sed -n "${session_num}p")
if [ -n "$session" ]; then
    tmux switch-client -t "$session"
fi