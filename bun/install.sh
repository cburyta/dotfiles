#!/bin/sh
if command -v bun >/dev/null 2>&1; then
  bun upgrade 2>/dev/null || true
else
  curl -fsSL https://bun.sh/install | bash
fi