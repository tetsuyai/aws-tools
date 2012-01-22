#!/usr/bin/env ruby
#------------------------------------------------------------------------------
# upload_to_s3.rb
#
# === DESCRIPTION
# This script uploads the file to Amazon S3.
#
# === USAGE
# upload_to_s3.rb -b <bucket name> -f <file name> [-p <directory prefix>] [-n]
# e.g.
#   upload_to_s3.rb -b data -f /tmp/mysql_20120120.dump -p mysql
#   upload_to_s3.rb -b logs -f "/var/log/nginx/access.log-20120120.*.gz" -p nginx -n
#
# Copyright (c) 2012 Tetsuya Imamura
#
#------------------------------------------------------------------------------



#------------------------------------------------------------------------------
# load config
#
#------------------------------------------------------------------------------
require File.expand_path(File.dirname(__FILE__) + '/../load_config')



#------------------------------------------------------------------------------
# parse commanline
#
#------------------------------------------------------------------------------
require File.expand_path(File.dirname(__FILE__) + '/parse_options')
parse_options

if OPTIONS[:dryrun]
  puts <<-END

dry run:

#{OPTIONS.to_yaml}

  END
end



#------------------------------------------------------------------------------
# glob expand
#
#------------------------------------------------------------------------------
file_names = Dir.glob(File.expand_path(OPTIONS[:glob_pattern]))



#------------------------------------------------------------------------------
# upload
#
#------------------------------------------------------------------------------
s3 = AWS::S3.new
bn = OPTIONS[:bucket_name]
dp = OPTIONS[:directory_prefix]

if OPTIONS[:dryrun]
  if s3.buckets.map {|b| b.name }.include?(bn)
    puts "> get bucket <#{bn}>"
  else
    puts "> create bucket <#{bn}>"
  end
else
  bucket = if s3.buckets.map {|b| b.name }.include?(bn)
    s3.buckets[bn]
  else
    s3.buckets.create(bn)
  end
end

file_names.each do |file_name|
  object_name = File.basename(file_name)
  object_name = File.join(dp, object_name) if dp.size > 0
  if OPTIONS[:dryrun]
    puts "> read file <#{file_name}>"
    puts "> write object <#{object_name}>"
  else
    obj = bucket.objects[object_name]
    obj.write(:file => file_name)
  end
end
