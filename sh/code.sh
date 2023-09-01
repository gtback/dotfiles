#!/bin/bash

code.dump-extensions() {
    cog.py -r .vscode/extensions.json
}

code.install-extensions() {
    # 1. Parse the VSCode Extensions (jsonc) file into something that jq can
    #    handle.
    # 2. Extract the Recommended Extensions with jq.
    # 3. Prefix each extension with `--install-extension`, so we can invoke
    #    `code` just once rather than once per extension (with `xargs -n 1`).
    #    Massive performance improvement!
    # 4. Invoke `code` to install all the extensions.
    # 5. Strip out the part of lines that tells you how to force installing a specific version. We only care out the part of the output that says the extension is installed.
    npx json5 <.vscode/extensions.json \
        | jq -r '.recommendations[]' \
        | awk '{print "--install-extension"; print $1}' \
        | xargs code \
        | sd " Use '--force'.*" ""
}
