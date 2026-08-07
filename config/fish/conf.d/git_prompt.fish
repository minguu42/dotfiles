status is-interactive; or exit

set --global _git_prompt_fish (status fish-path)

set --global _git_prompt_info ""
set --local tmpdir /tmp
test -n "$TMPDIR"; and set tmpdir (string trim --right --chars=/ -- $TMPDIR)
set --global _git_prompt_file $tmpdir/fish_git_prompt_$fish_pid

# Git情報をバックグラウンドで取得する。完了するとSIGUSR1が送られてくる
function _git_prompt_update
    command kill $_git_prompt_job 2>/dev/null
    $_git_prompt_fish --no-config --command '
        cd $argv[2] 2>/dev/null; or exit
        set parts
        if command git --no-optional-locks rev-parse --is-inside-work-tree &>/dev/null
            # ブランチ（detached HEAD時はコミットハッシュ）
            set branch (command git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
            if test -n "$branch"
                set --append parts "on $(set_color --bold magenta) $branch$(set_color normal)"
            else
                set hash (command git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
                test -n "$hash"; and set --append parts "$(set_color --bold green)($hash)$(set_color normal)"
            end

            # 進行中の操作（リベース・マージなど）
            set git_dir (command git rev-parse --absolute-git-dir 2>/dev/null)
            set state
            if test -d "$git_dir/rebase-merge"
                set state "REBASING $(cat $git_dir/rebase-merge/msgnum 2>/dev/null)/$(cat $git_dir/rebase-merge/end 2>/dev/null)"
            else if test -d "$git_dir/rebase-apply"
                set state "REBASING $(cat $git_dir/rebase-apply/next 2>/dev/null)/$(cat $git_dir/rebase-apply/last 2>/dev/null)"
            else if test -f "$git_dir/MERGE_HEAD"
                set state MERGING
            else if test -f "$git_dir/CHERRY_PICK_HEAD"
                set state CHERRY-PICKING
            else if test -f "$git_dir/REVERT_HEAD"
                set state REVERTING
            else if test -f "$git_dir/BISECT_LOG"
                set state BISECTING
            end
            test -n "$state"; and set --append parts "$(set_color --bold yellow)($state)$(set_color normal)"

            # ワークツリー・インデックスの状態
            set conflicted 0
            set deleted 0
            set renamed 0
            set modified 0
            set staged 0
            set untracked 0
            set has_upstream 0
            set ahead 0
            set behind 0
            for line in (command git --no-optional-locks status --porcelain=v2 --branch 2>/dev/null)
                switch $line
                    case "# branch.ab *"
                        set fields (string split " " -- $line)
                        set has_upstream 1
                        set ahead (string sub --start 2 -- $fields[3])
                        set behind (string sub --start 2 -- $fields[4])
                    case "u *"
                        set conflicted 1
                    case "1 *" "2 *"
                        set xy (string split " " -- $line)[2]
                        string match --quiet "2 *" -- $line; and set renamed 1
                        string match --quiet --regex D -- $xy; and set deleted 1
                        string match --quiet --regex "^[^.]" -- $xy; and set staged 1
                        string match --quiet --regex "^.[^.]" -- $xy; and set modified 1
                    case "? *"
                        set untracked 1
                end
            end
            set symbols ""
            test $conflicted -eq 1; and set symbols "$symbols~"
            command git rev-parse --verify --quiet refs/stash >/dev/null 2>&1; and set symbols "$symbols\$"
            test $deleted -eq 1; and set symbols "$symbols✘"
            test $renamed -eq 1; and set symbols "$symbols»"
            test $modified -eq 1; and set symbols "$symbols!"
            test $staged -eq 1; and set symbols "$symbols+"
            test $untracked -eq 1; and set symbols "$symbols?"
            if test $has_upstream -eq 1
                if test $ahead -gt 0; and test $behind -gt 0
                    set symbols "$symbols⇕"
                else if test $ahead -gt 0
                    set symbols "$symbols⇡"
                else if test $behind -gt 0
                    set symbols "$symbols⇣"
                else
                    set symbols "$symbols="
                end
            end
            test -n "$symbols"; and set --append parts (string join "" -- (set_color --bold red) "[$symbols]" (set_color normal))
        end

        # 親シェルの表示から変化があったときだけ書き込んで通知する
        set info (string join " " -- $parts)
        test "$info" = "$argv[4]"; and exit
        printf %s "$info" > $argv[1]
        command kill -USR1 $argv[3] 2>/dev/null
    ' $_git_prompt_file $PWD $fish_pid "$_git_prompt_info" </dev/null >/dev/null 2>&1 &
    set --global _git_prompt_job $last_pid
    builtin disown $_git_prompt_job 2>/dev/null
end

function _git_prompt_focus --on-event fish_focus_in
    _git_prompt_update
end

function _git_prompt_postexec --on-event fish_postexec
    _git_prompt_update
end

function _git_prompt_cd --on-variable PWD
    set --global _git_prompt_info ""
    _git_prompt_update
end

# Git情報の取得が完了したらプロンプトを再描画する
function _git_prompt_refresh --on-signal SIGUSR1
    set --global _git_prompt_info (command cat $_git_prompt_file 2>/dev/null)
    commandline --function repaint 2>/dev/null
end

function _git_prompt_cleanup --on-event fish_exit
    command kill $_git_prompt_job 2>/dev/null
    command rm -f $_git_prompt_file
end

_git_prompt_update
