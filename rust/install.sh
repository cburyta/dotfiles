#!/bin/sh
if command -v rustup >/dev/null 2>&1; then
  rustup default stable 2>/dev/null || true
fi
