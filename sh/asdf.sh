#!/bin/bash

function asdf.install-plugins() {
    awk '{print $1}' <"${ASDF_DEFAULT_TOOL_VERSIONS_FILENAME}" | xargs -n 1 asdf plugin add
}

function asdf.list-all() {
    for plugin in $(asdf plugin-list); do
        echo "$plugin"
        asdf list "$plugin"
    done
}

function asdf.reshim() {
    asdf_data_dir=${ASDF_DATA_DIR:-~/.asdf}
    rm -rf "${asdf_data_dir}/shims"
    asdf reshim
}

function all-node() {
    for version in $(asdf list nodejs); do
        echo "--NODEJS $version--"
        ASDF_NODE_VERSION=$version "$@"
    done
}

function all-python() {
    for version in $(asdf list python); do
        echo "--PYTHON $version--"
        ASDF_PYTHON_VERSION=$version "$@"
    done
}

function all-ruby() {
    for version in $(asdf list ruby); do
        echo "--RUBY $version--"
        ASDF_RUBY_VERSION=$version "$@"
    done
}

function all-rust() {
    for version in $(asdf list rust); do
        echo "--RUST $version--"
        ASDF_RUST_VERSION=$version "$@"
    done
}

function all-yarn() {
    for version in $(asdf list yarn); do
        echo "--YARN $version--"
        ASDF_YARN_VERSION=$version "$@"
    done
}
