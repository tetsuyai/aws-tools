#------------------------------------------------------------------------------
# parse_options.rb
#
# === DESCRIPTION
# Parses commandline options.
#
# Copyright (c) 2012 Tetsuya Imamura
#
#------------------------------------------------------------------------------
require 'optparse'

OPTIONS = {
  :bucket_name      => nil,
  :glob_pattern     => nil,
  :directory_prefix => '',
  :dryrun           => false
}

def usage
  puts <<-EOS

#{File.basename($PROGRAM_NAME)} is a file upload program to Amazon S3.  Use '#{File.basename($PROGRAM_NAME)} --help' to see more information.

  EOS
end

def parse_options
  ARGV.options do |opts|
    opts.version = '0.0.1'
    opts.banner = <<-EOS
Usage:
  #{File.basename($PROGRAM_NAME)} -b <bucket name> -f <file name> [-p <directory prefix>] [-n]
  e.g.
    upload_to_s3.rb -b data -f /tmp/mysql_20120120.dump -p mysql
    upload_to_s3.rb -b logs -f "/var/log/nginx/access.log-20120120.*.gz" -p nginx -n

    EOS
    opts.on('-b', '--bucket-name=BUCKET_NAME', 'All files will be saved to this bucket.') do |bucket_name|
      OPTIONS[:bucket_name] = bucket_name
    end
    opts.on('-f', '--file-name=FILE_NAME', 'This local file will be uploaded to Amazon S3.') do |file_name|
      OPTIONS[:glob_pattern] = file_name
    end
    opts.on('-p', '--directory-prefix=DIRECTORY_PREFIX', 'All files will be saved to this directory.') do |directory_prefix|
      OPTIONS[:directory_prefix] = directory_prefix
    end
    opts.on('-n', '--dry-run', 'Perform a trial run with no changes made.') do
      OPTIONS[:dryrun] = true
    end

    begin
      opts.parse!
    rescue
      usage; exit 1
    end
  end

  unless OPTIONS[:bucket_name] && OPTIONS[:glob_pattern]
    usage; exit 1
  end
end
