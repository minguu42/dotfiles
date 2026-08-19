function fish_prompt
    set -l last_status $status
    if command --query fish-prompt
        fish-prompt $last_status "$CMD_DURATION" "$_git_prompt_info"
    else
        echo -n "$PWD ❯ "
    end
end
