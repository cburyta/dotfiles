# # iTerm2 Status bar helpers
# # ------------------------
# # See https://www.iterm2.com/3.3/documentation-scripting-fundamentals.html
# function iterm2_print_user_vars() {
#   iterm2_set_user_var phpVersion $(php -v | awk '/^PHP/ { print $2 }')
#   iterm2_set_user_var rubyVersion $(ruby -v | awk '{ print $2 }')
#   iterm2_set_user_var nodeVersion $(node -v)
#   iterm2_set_user_var pythonVersion $(python --version)
# }

# iTerm2: Fix tab title control
# export DISABLE_AUTO_TITLE="true"
