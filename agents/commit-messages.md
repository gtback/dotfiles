# Commit messages

Priority order when writing a commit message: (1) an existing local
convention if the repo has one, (2) scoped commits as the default
otherwise, (3) the baseline formatting rules below, which apply
regardless of scope.

## 1. Check for a local convention first

Before writing a message, check, in order:

- `CONTRIBUTING.md` (root, then `docs/CONTRIBUTING.md`) for a commit
  message or commit convention section.
- A **repo-local** commit template: `git config --local commit.template`,
  or a `.gitmessage` / `.gitmessage.txt` committed in the worktree. Do
  **not** use `git config commit.template` without `--local` — it
  resolves the personal global template
  (`~/.config/git/commit-template.txt`) in every repo, which is not
  evidence of a repo convention.
- Recent history (`git log --oneline -30`), but only if the repo has
  enough commits for a real signal — don't infer a convention from a
  handful of commits in a brand-new repo. If there's no documented
  convention and not enough history to detect one, treat this as an
  unestablished repo and use the scoped-commit default below.

If a convention is found (documented or clearly consistent in
history), follow it, including its own subject-line format and
length norms, even where it conflicts with the rules below.

## 2. Default: scoped commits

If no local convention is found, use scope-prefixed subject lines:

    scope: imperative description

See <https://scopedcommits.com/> for the full specification.

- Delimiter is a colon followed by a space.
- Scope is the subsystem, area, or module the commit touches —
  typically the top-level directory or package (e.g. `auth`, `api`,
  `net/http`).
- When a commit covers multiple scopes:
  1. Use a broader scope that encompasses all the relevant areas.
  2. List both scopes, separated by a comma:
     `git, vscode: Unify ignore handling`
  3. If the commit touches the entire tree, use `global` or `all`. Do not use
     `treewide`, or invent placeholders like `*` or `repo`.

## 3. Baseline formatting

Use these additional conventions when writing the commit message:

- Imperative mood ("Add", not "Added" or "Adds").
- Capitalize the subject; no trailing period.
- Subject line: aim for ~65-70 characters including any scope prefix.
  This is a soft target — prioritize clarity and a correct scope over
  hitting an exact count.
- Blank line between subject and body.
- Body wrapped at ~72 characters, explaining what and why, not how.
- Include a body when the subject alone doesn't explain *why* the
  change was made. Omit it for mechanical changes whose reason is
  self-evident: version bumps, renames, typo fixes, adding or removing
  a package. When in doubt, write the body.

Sources:

- <https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html>
- <https://cbea.ms/git-commit/>

## 4. Attribution

Append an `Assisted-by` trailer, per the Linux kernel
[coding-assistants guidelines](https://github.com/torvalds/linux/blob/master/Documentation/process/coding-assistants.rst):

    Assisted-by: <Agent>:<model-id>

The model ID must be the model that **made the code changes** — not
necessarily the model composing the commit message. If the active model
changed mid-session, name the model that wrote the code. If you are not
certain which model did the work, ask rather than guessing.

Place it after any `Co-Authored-By` lines, at the end of the body.
Each agent supplies its own `<Agent>` name.

Do NOT add `Signed-off-by` — only humans can certify the DCO.
