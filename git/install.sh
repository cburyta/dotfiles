#!/usr/bin/env bash
#
# Install Git-related tools and configurations

set -e

# Install worktrunk shell integration
if command -v wt &> /dev/null; then
    wt config shell install
fi
