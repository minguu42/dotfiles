#!/usr/bin/env bash
set -uo pipefail

notify() {
  terminal-notifier -title 'Claude Code' -message 'Claude has completed the task.' -sound 'Boop'
}

# stdin は一度しか読めないため、まず全体を変数へ取り込む
input=$(cat)

# 無限ループ防止: 既に Stop hook がブロック済みなら再チェックせず素通り
if [ "$(printf '%s' "$input" | jq -r '.stop_hook_active // false')" = "true" ]; then
  notify
  exit 0
fi

# 直近のターンでClaudeがGoファイルを編集したかどうかを判定する
transcript_path=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
edited_go=false
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  edited_go=$(jq -s '
    [ range(0; length) as $i
      | select(.[$i].type == "user"
          and (((.[$i].message.content | type) == "string")
               or (((.[$i].message.content | type) == "array")
                   and ([.[$i].message.content[]?.type] | index("tool_result") | not))))
      | $i ] as $prompts
    | [ .[(($prompts | last) // -1) + 1:][]
        | select(.type == "assistant")
        | .message.content[]?
        | select(.type == "tool_use")
        | select(.name == "Edit" or .name == "Write" or .name == "MultiEdit" or .name == "NotebookEdit")
        | (.input.file_path // .input.notebook_path // "") ]
    | any(.[]; endswith(".go"))
  ' "$transcript_path" 2>/dev/null)
fi

if [ "$edited_go" = "true" ] && [ -f go.mod ]; then
  if go tool 2>/dev/null | grep -qFx staticcheck; then
    lint_output=$({ go vet ./... && go tool staticcheck ./...; } 2>&1)
  else
    lint_output=$(go vet ./... 2>&1)
  fi
  lint_status=$?
  test_output=$(go test -shuffle=on ./... 2>&1)
  test_status=$?
  if [ $lint_status -ne 0 ] || [ $test_status -ne 0 ]; then
    jq -n --arg l "$lint_output" --arg t "$test_output" \
      '{
        decision: "block",
        reason: (
          "静的解析またはテストが失敗しています。修正してください。\n\n"
          + "静的解析:\n" + $l + "\n\n"
          + "テスト:\n" + $t
        )
      }'
    exit 0
  fi
fi

notify
