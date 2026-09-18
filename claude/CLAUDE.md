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

## Plan mode

The `ExitPlanMode` approval dialog draws over the text printed immediately
before it. Never put anything I need in order to evaluate the plan in that text
— put it in the plan file, which is what the dialog renders.

When revising a plan, lead the plan file with a short "Changes since your last
review" section.
