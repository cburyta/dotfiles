# GPG Quick Reference

## List existing keys
gpg-list
# Shows secret keys with key IDs (e.g., sec   rsa4096/ABC123DEF4567890...)

## Generate new key
gpg-generate
# Follow prompts: RSA 4096, no expiry, name, email

## Export key (for GitHub)
gpg-export <key-id>
# Example: gpg-export ABC123DEF4567890
# Copy output to GitHub > Settings > SSH and GPG keys > New GPG key

## Add to Git config
git config --global user.signingkey <key-id>
git config --global commit.gpgsign true
