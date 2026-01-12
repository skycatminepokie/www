#!/bin/bash
if [ -z "$VIRTUAL_ENV" ]; then
  echo "Error: VIRTUAL_ENV is not set or is empty." >&2
  echo "Make sure python venv is active" >&2
  exit 1
fi

mkdocks server --livereload