function select_repository
	set --local selected (ghq list --full-path | peco --query (commandline))
	if test -n "$selected"
		cd $selected
		commandline -f repaint
	end
	commandline ''
end
