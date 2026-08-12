# Commit Conventions

When making git commits, always append an `Assisted-by` trailer in the format
specified by the Linux kernel coding-assistants guidelines:

```
Assisted-by: pi:<model-id>
```

Use the actual model ID for the current session (e.g. `claude-opus-4-8`). This
trailer goes after any `Co-Authored-By` lines, at the end of the commit message
body.

Do NOT add `Signed-off-by` tags — only humans can certify the Developer
Certificate of Origin.
