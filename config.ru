# You can start sonice using this configuration file by typing:
#     bundle exec thin start

### Configuration Settings
#
# ENV['SONICE_CONTROLS'] = '0'   # Disable controls
# ENV['SONICE_VOTING'] = '0'     # Disable voting

require "sonice"
run Sonice::App

