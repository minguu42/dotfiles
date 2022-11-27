function select_repository
    set selected_repository $(ghq list | peco)

    if [ -n "$selected_repository" ]
        cd "$HOME/ghq/$selected_repository"
        echo "$selected_repository"
        commandline -f repaint
    end
end
