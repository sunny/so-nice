### Config Settings
# ENV['SONICE_CONTROLS'] = '0'   # Disable controls
# ENV['SONICE_VOTING'] = '0'     # Disable voting

require File.join(File.dirname(__FILE__), 'sonice.rb')
run Sinatra::Application

