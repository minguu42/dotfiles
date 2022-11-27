function select_history
    set selected_command $(history | peco)

    if [ -n "$selected_command" ]
        commandline "$selected_command"
    end
end
