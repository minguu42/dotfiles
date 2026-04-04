function abbr_subcommand
    set -l main_command $argv[1]
    set -l abbreviation $argv[2]
    set -l expansion "$argv[3..-1]"

    set -l fn "_abbr_"$main_command"_"$abbreviation
    function "$fn" --inherit-variable main_command --inherit-variable abbreviation --inherit-variable expansion
        set -l cmd (commandline -op)
        if test (count $cmd) -eq 2 -a "$cmd[1]" = "$main_command" -a "$cmd[2]" = "$abbreviation"
            echo $expansion
            return 0
        end
        return 1
    end

    abbr -a "$fn" --regex $abbreviation --position anywhere --function "$fn"
end

function abbr_subsubcommand
    set -l main_command $argv[1]
    set -l sub_command $argv[2]
    set -l abbreviation $argv[3]
    set -l expansion "$argv[4..-1]"

    set -l fn "_abbr_"$main_command"_"$sub_command"_"$abbreviation
    function "$fn" --inherit-variable main_command --inherit-variable sub_command --inherit-variable abbreviation --inherit-variable expansion
        set -l cmd (commandline -op)
        if test (count $cmd) -eq 3 -a "$cmd[1]" = "$main_command" -a "$cmd[2]" = "$sub_command" -a "$cmd[3]" = "$abbreviation"
            echo $expansion
            return 0
        end
        return 1
    end

    abbr -a "$fn" --regex $abbreviation --position anywhere --function "$fn"
end
