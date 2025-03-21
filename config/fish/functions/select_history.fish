function select_history
	set --local selected (history | peco --query (commandline))
	commandline "$selected"
end
