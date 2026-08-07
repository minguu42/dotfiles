function fish_prompt
    set -l last_status $status

    # ディレクトリ
    set -l dir (string replace --regex '^'(string escape --style=regex -- $HOME)'($|/)' '~$1' -- $PWD)
    set -l truncated 0
    set -l toplevel (command git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$toplevel"
        set -l parent (path dirname -- $toplevel)
        if test "$parent" != /; and string match --quiet "$parent/*" -- $PWD
            set dir (string replace -- "$parent/" "" $PWD)
            set truncated 1
        end
    end
    set -l parts (string split -- / $dir)
    if test (count $parts) -gt 5
        set parts $parts[-5..]
        set truncated 1
    end
    set dir (string join -- / $parts)
    test $truncated -eq 1; and set dir ".../$dir"
    echo -n "$(set_color --bold cyan)$dir$(set_color normal) "

    # Git情報
    if test -n "$_git_prompt_info"
        echo -n "$_git_prompt_info "
    end

    # 直前のコマンドの実行時間
    if test -n "$CMD_DURATION"; and test $CMD_DURATION -ge 2000
        set -l secs (math --scale=0 $CMD_DURATION / 1000)
        set -l duration ""
        test $secs -ge 3600; and set duration (math --scale=0 $secs / 3600)h
        test $secs -ge 60; and set duration "$duration"(math --scale=0 $secs / 60 % 60)m
        set duration "$duration"(math --scale=0 $secs % 60)s
        echo -n "took $(set_color --bold yellow)$duration$(set_color normal) "
    end

    # 時刻
    echo -n "at $(set_color --bold yellow)$(date +%T)$(set_color normal) "

    echo
    if test $last_status -eq 0
        echo -n "$(set_color --bold green)❯ $(set_color normal)"
    else
        echo -n "$(set_color --bold red)❯ $(set_color normal)"
    end
end
