require_relative '../config/environment'
require_relative '../lib/api_communicator.rb'

new_cli = CommandLineInterface.new
new_cli.greet
new_cli.gets_user_input
