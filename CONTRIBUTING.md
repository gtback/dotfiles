# Contributing

## Commit messages

`scope: Imperative description` — colon delimiter, per
<https://scopedcommits.com/>.

Commits before 2026-08 use `[scope] Description`. That bracket form is **not**
the convention going forward; ignore it when inferring style from `git log`.

Scope is usually the top-level directory touched (`vscode`, `git`, `brew`,
`sh`, `mise`). For changes spanning several, use a broader scope or list them
comma-separated; use `global` or `all` only for genuinely tree-wide changes.
