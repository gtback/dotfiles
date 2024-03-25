#!/bin/bash

extensions_file="${HOME}/dotfiles/.vscode/extensions.json"

code.dump-extensions() {
    cog -r "$extensions_file"
}

code.install-extensions() {
    # 1. Parse the .extensions.json file
    # 2. Prefix each extension with `--install-extension`, so we can invoke
    #    `code` just once rather than once per extension (with `xargs -n 1`).
    #    Massive performance improvement!
    # 3. Invoke `code` to install all the extensions.
    # 4. Strip out the part of lines that tells you how to force installing a
    #    specific version. We only care out the part of the output that says the
    #    extension is installed.
    code.parse-extensions-file \
        | awk '{print "--install-extension"; print $1}' \
        | xargs code \
        | sd " Use '--force'.*" ""
}

code.parse-extensions-file() {
    # 1. Convert the VSCode Extensions (jsonc) file into something that jq can
    #    handle.
    # 2. Extract the Recommended Extensions with jq.
    npx json5 <"$extensions_file" \
        | jq -r '.recommendations[]'
}
