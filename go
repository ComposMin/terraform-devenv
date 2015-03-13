#!/bin/sh

function tools_installed() {
    which terraform > /dev/null
}

# Check if required tools are already installed into the current workspace
tools_installed
installed=$?
if [ ${installed} -ne 0 ]; then
    echo "Installing tooling..."
fi



terraform plan layered-web

terraform apply layered-web
