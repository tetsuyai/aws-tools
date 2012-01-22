#------------------------------------------------------------------------------
# load_config.rb
#
# === DESCRIPTION
# Loads configuration from ./config.yml for AWS.
#
# Copyright (c) 2012 Tetsuya Imamura
#
#------------------------------------------------------------------------------
require 'rubygems'
require 'yaml'
require 'aws-sdk'

config_file = File.join(File.dirname(__FILE__), 'config.yml')
unless File.exist?(config_file)
  puts <<-EOS
Put your credentials in config.yml as follows:

access_key_id:     <YOUR_ACCESS_KEY_ID>
secret_access_key: <YOUR_SECRET_ACCESS_KEY>
s3_endpoint:       <YOUR_ENDPOINT>

  EOS
  exit 1
end

config = YAML.load(File.read(config_file))
unless config.kind_of?(Hash)
  puts <<-EOS
config.yml is formatted incorrectly.  Please use the following format:

access_key_id:     <YOUR_ACCESS_KEY_ID>
secret_access_key: <YOUR_SECRET_ACCESS_KEY>
s3_endpoint:       <YOUR_ENDPOINT>

  EOS
  exit 1
end

AWS.config(config)
