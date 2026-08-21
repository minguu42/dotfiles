package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"
)

const (
	reset   = "\033[0m"
	red     = "\033[31m"
	green   = "\033[32m"
	yellow  = "\033[33m"
	magenta = "\033[35m"
	cyan    = "\033[36m"
)

func main() {
	if err := mainRun(); err != nil {
		fmt.Println("error:", err)
	}
}

type Input struct {
	Model struct {
		DisplayName string `json:"display_name"`
	} `json:"model"`
	Workspace struct {
		ProjectDir string `json:"project_dir"`
	} `json:"workspace"`
	ContextWindow struct {
		ContextWindowSize int `json:"context_window_size"`
		CurrentUsage      *struct {
			InputTokens              int `json:"input_tokens"`
			CacheCreationInputTokens int `json:"cache_creation_input_tokens"`
			CacheReadInputTokens     int `json:"cache_read_input_tokens"`
		} `json:"current_usage"`
	} `json:"context_window"`
	RateLimits struct {
		FiveHour *struct {
			UsedPercentage float64 `json:"used_percentage"`
		} `json:"five_hour"`
		SevenDay *struct {
			UsedPercentage float64 `json:"used_percentage"`
		} `json:"seven_day"`
	} `json:"rate_limits"`
}

func mainRun() error {
	var in Input
	if err := json.NewDecoder(os.Stdin).Decode(&in); err != nil {
		return err
	}

	var b strings.Builder
	fmt.Fprintf(&b, "[%s] %s%s%s",
		in.Model.DisplayName,
		cyan, filepath.Base(in.Workspace.ProjectDir), reset,
	)

	if data, err := os.ReadFile(".git/HEAD"); err != nil && !errors.Is(err, os.ErrNotExist) {
		return err
	} else if err == nil {
		branch := strings.TrimPrefix(strings.TrimSpace(string(data)), "ref: refs/heads/")
		fmt.Fprintf(&b, " on %s\uE0A0 %s%s", magenta, branch, reset)
	}

	// auto-compactが有効な場合はコンテキストウィンドウの一部がバッファとして確保されるため、その分を事前に足す必要がある。
	// バッファサイズは13000+CLAUDE_CODE_MAX_OUTPUT_TOKENSとなる。
	// tokens += 13000 + maxOutputTokens
	if in.ContextWindow.CurrentUsage != nil && in.RateLimits.FiveHour != nil && in.RateLimits.SevenDay != nil {
		u := in.ContextWindow.CurrentUsage
		tokens := u.InputTokens + u.CacheCreationInputTokens + u.CacheReadInputTokens
		used := float64(tokens) * 100 / float64(in.ContextWindow.ContextWindowSize)
		fmt.Fprintf(&b, " used %s (5h: %s, 7d: %s)",
			coloredPercent(used),
			coloredPercent(in.RateLimits.FiveHour.UsedPercentage),
			coloredPercent(in.RateLimits.SevenDay.UsedPercentage),
		)
	}

	fmt.Fprintf(&b, " at %s%s%s", yellow, time.Now().Format(time.TimeOnly), reset)
	fmt.Print(b.String())
	return nil
}

func coloredPercent(used float64) string {
	color := green
	switch {
	case used >= 85:
		color = red
	case used >= 65:
		color = yellow
	}
	return fmt.Sprintf("%s%.0f%%%s", color, used, reset)
}
