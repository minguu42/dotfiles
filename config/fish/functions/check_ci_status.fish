function check_ci_status
  if set pr_json (gh pr view --json headRepository,headRepositoryOwner,number 2>/dev/null)
    set pr_owner (echo $pr_json | jq -r '.headRepositoryOwner.login')
    set pr_repository (echo $pr_json | jq -r '.headRepository.name')
    set pr_number (echo $pr_json | jq -r '.number')
  else
    echo "no pull requests found for current branch"
    return 1
  end

  while true
    gh pr checks >/dev/null 2>&1
    if test $status -eq 8
      sleep 5
      continue
    end

    gh pr checks
    terminal-notifier -title "GitHub CLI" -message "All checks are complete for pull request $pr_owner/$pr_repository#$pr_number" -sound "Boop"
    break
  end
end
