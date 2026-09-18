# Claude Code Guidelines

## Git Operations

Always get explicit confirmation from the user before performing non-read-only
git operations. This includes commits, pushes, rebases, merges, branch
creation/deletion, resets, checkouts that discard changes, and any other
operation that modifies git state. Always describe the intended operation and
wait for confirmation before running it.

## Commit Conventions

@~/.config/agents/commit-messages.md

In the `Assisted-by` trailer, use `Claude` as the agent name.
