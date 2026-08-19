package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"syscall"
)

const (
	reset       = "\033[0m"
	boldRed     = "\033[1;31m"
	boldGreen   = "\033[1;32m"
	boldYellow  = "\033[1;33m"
	boldMagenta = "\033[1;35m"
)

func main() {
	if len(os.Args) < 3 {
		fmt.Fprintln(os.Stderr, "usage: fish-prompt-git-status <file> <parent_pid> <prev_info>")
		os.Exit(2)
	}
	file := os.Args[1]
	pid, err := strconv.Atoi(os.Args[2])
	if err != nil {
		os.Exit(2)
	}
	prevStatus := ""
	if len(os.Args) > 3 {
		prevStatus = os.Args[3]
	}

	wd := pwd()
	if _, err := os.Stat(wd); err != nil {
		return
	}

	var parts []string
	if _, ok := git(wd, "--no-optional-locks", "rev-parse", "--is-inside-work-tree"); ok {
		// ブランチ or コミットハッシュ
		if branch, ok := git(wd, "--no-optional-locks", "symbolic-ref", "--short", "HEAD"); ok && branch != "" {
			parts = append(parts, "on "+boldMagenta+"\uE0A0 "+branch+reset)
		} else if hash, ok := git(wd, "--no-optional-locks", "rev-parse", "--short", "HEAD"); ok && hash != "" {
			parts = append(parts, boldGreen+"("+hash+")"+reset)
		}

		// 進行中の操作（リベース・マージなど）
		if state := operationState(wd); state != "" {
			parts = append(parts, boldYellow+"("+state+")"+reset)
		}

		// ワークツリー・インデックスの状態
		if symbols := statusSymbols(wd); symbols != "" {
			parts = append(parts, boldRed+"["+symbols+"]"+reset)
		}
	}

	status := strings.Join(parts, " ")
	if status == prevStatus {
		return
	}
	if err := os.WriteFile(file, []byte(status), 0o600); err != nil {
		os.Exit(1)
	}
	_ = syscall.Kill(pid, syscall.SIGUSR1)
}

func operationState(wd string) string {
	gitDir, _ := git(wd, "rev-parse", "--absolute-git-dir")
	if gitDir == "" {
		return ""
	}

	exists := func(name string) bool {
		_, err := os.Stat(filepath.Join(gitDir, name))
		return err == nil
	}
	readTrim := func(name string) string {
		data, err := os.ReadFile(filepath.Join(gitDir, name))
		if err != nil {
			return ""
		}
		return strings.TrimSpace(string(data))
	}
	switch {
	case exists("rebase-merge"):
		return "REBASING " + readTrim("rebase-merge/msgnum") + "/" + readTrim("rebase-merge/end")
	case exists("rebase-apply"):
		return "REBASING " + readTrim("rebase-apply/next") + "/" + readTrim("rebase-apply/last")
	case exists("MERGE_HEAD"):
		return "MERGING"
	case exists("CHERRY_PICK_HEAD"):
		return "CHERRY-PICKING"
	case exists("REVERT_HEAD"):
		return "REVERTING"
	case exists("BISECT_LOG"):
		return "BISECTING"
	}
	return ""
}

func statusSymbols(wd string) string {
	var conflicted, deleted, renamed, modified, staged, untracked, hasUpstream bool
	var ahead, behind int
	out, _ := git(wd, "--no-optional-locks", "status", "--porcelain=v2", "--branch")
	for line := range strings.SplitSeq(out, "\n") {
		switch {
		case strings.HasPrefix(line, "# branch.ab "):
			fields := strings.Fields(line)
			if len(fields) < 4 {
				continue
			}
			hasUpstream = true
			ahead, _ = strconv.Atoi(strings.TrimPrefix(fields[2], "+"))
			behind, _ = strconv.Atoi(strings.TrimPrefix(fields[3], "-"))
		case strings.HasPrefix(line, "u "):
			conflicted = true
		case strings.HasPrefix(line, "1 "), strings.HasPrefix(line, "2 "):
			fields := strings.SplitN(line, " ", 3)
			if len(fields) < 2 || len(fields[1]) < 2 {
				continue
			}
			xy := fields[1]
			if line[0] == '2' {
				renamed = true
			}
			if strings.ContainsRune(xy, 'D') {
				deleted = true
			}
			if xy[0] != '.' {
				staged = true
			}
			if xy[1] != '.' {
				modified = true
			}
		case strings.HasPrefix(line, "? "):
			untracked = true
		}
	}

	var b strings.Builder
	if conflicted {
		b.WriteString("~")
	}
	if _, ok := git(wd, "rev-parse", "--verify", "--quiet", "refs/stash"); ok {
		b.WriteString("$")
	}
	if deleted {
		b.WriteString("✘")
	}
	if renamed {
		b.WriteString("»")
	}
	if modified {
		b.WriteString("!")
	}
	if staged {
		b.WriteString("+")
	}
	if untracked {
		b.WriteString("?")
	}
	if hasUpstream {
		switch {
		case ahead > 0 && behind > 0:
			b.WriteString("⇕")
		case ahead > 0:
			b.WriteString("⇡")
		case behind > 0:
			b.WriteString("⇣")
		default:
			b.WriteString("=")
		}
	}
	return b.String()
}

func pwd() string {
	// シンボリックリンクを解決しないため、$PWDを優先する
	if dir := os.Getenv("PWD"); dir != "" {
		return dir
	}
	dir, _ := os.Getwd()
	return dir
}

func git(dir string, args ...string) (string, bool) {
	cmd := exec.Command("git", args...)
	cmd.Dir = dir
	out, err := cmd.Output()
	if err != nil {
		return "", false
	}
	return strings.TrimSpace(string(out)), true
}
