status is-interactive; or exit

set --global _git_prompt_info ""
set --local tmpdir /tmp
test -n "$TMPDIR"; and set tmpdir (string trim --right --chars=/ -- $TMPDIR)
set --global _git_prompt_file $tmpdir/fish_git_prompt_$fish_pid

# Git情報をバックグラウンドで取得する。完了するとSIGUSR1が送られてくる
function _git_prompt_update
    command --query fish-prompt-git-status; or return
    fish-prompt-git-status $_git_prompt_file $fish_pid "$_git_prompt_info" </dev/null >/dev/null 2>&1
end

function _git_prompt_startup --on-event fish_prompt
    functions --erase _git_prompt_startup # 初回のプロンプト表示時だけ実行されるようにする
    _git_prompt_update
end

# Ctrl+Lでの画面クリア時にGit情報を更新する
bind ctrl-l '_git_prompt_update; commandline --function clear-screen'

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
    command kill (command cat $_git_prompt_file.pid 2>/dev/null) 2>/dev/null
    command rm -f $_git_prompt_file $_git_prompt_file.pid
end
