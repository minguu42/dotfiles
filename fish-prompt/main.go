package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

const (
	reset      = "\033[0m"
	boldRed    = "\033[1;31m"
	boldGreen  = "\033[1;32m"
	boldYellow = "\033[1;33m"
	boldCyan   = "\033[1;36m"
)

func main() {
	args := os.Args[1:]
	for len(args) < 3 {
		args = append(args, "")
	}
	lastStatus, _ := strconv.Atoi(args[0])
	var duration time.Duration
	if rawDuration, err := strconv.Atoi(args[1]); err == nil {
		duration = time.Duration(rawDuration) * time.Millisecond
	}
	gitStatus := args[2]

	var b strings.Builder
	fmt.Fprintf(&b, "%s%s%s ", boldCyan, currentDir(), reset)
	if gitStatus != "" {
		b.WriteString(gitStatus + " ")
	}
	if duration >= 2*time.Second {
		fmt.Fprintf(&b, "took %s%s%s ", boldYellow, formatDuration(duration), reset)
	}
	fmt.Fprintf(&b, "at %s%s%s\n", boldYellow, time.Now().Format(time.TimeOnly), reset)
	color := boldGreen
	if lastStatus != 0 {
		color = boldRed
	}
	fmt.Fprintf(&b, "%s❯ %s", color, reset)
	fmt.Print(b.String())
}

func currentDir() string {
	wd := pwd()
	if toplevel, ok := git(wd, "rev-parse", "--show-toplevel"); ok && toplevel != "" {
		parent := filepath.Dir(toplevel)
		if parent != "/" && strings.HasPrefix(wd, parent+"/") {
			return ".../" + strings.TrimPrefix(wd, parent+"/")
		}
	}

	dir := wd
	if home := os.Getenv("HOME"); home != "" {
		switch {
		case wd == home:
			dir = "~"
		case strings.HasPrefix(wd, home+"/"):
			dir = "~" + strings.TrimPrefix(wd, home)
		}
	}

	if parts := strings.Split(dir, "/"); len(parts) > 5 {
		return ".../" + strings.Join(parts[len(parts)-5:], "/")
	}
	return dir
}

func formatDuration(d time.Duration) string {
	secs := int(d.Seconds())
	s := ""
	if secs >= 3600 {
		s = strconv.Itoa(secs/3600) + "h"
	}
	if secs >= 60 {
		s += strconv.Itoa(secs/60%60) + "m"
	}
	return s + strconv.Itoa(secs%60) + "s"
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
