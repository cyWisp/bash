#!/usr/bin/env bash

GHA_TEMPLATE=$(cat <<EOF

name: Basic Example
on:
  push:
    branches:
      - main
    paths:
      - ".github/workflows"
  workflow_dispatch:

jobs:
  setup:
    name: Setup
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Run bash
        run: |
          echo "this is just an example run"

EOF
)


function log () {
  echo "${BASHPID} $(date '+%d-%m-%Y %H:%M:%S'): $1 $2"
}

function init () {
  echo "$GHA_TEMPLATE" > "template.yaml"
}

init