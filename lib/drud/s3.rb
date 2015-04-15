require 'aws-sdk'
require 'base64'
require 'humanize-bytes'

module Drud
  # s3 class
  class S3
    attr_accessor :aws_access_key
    attr_accessor :aws_secret_key
    attr_accessor :aws_bucket
    attr_accessor :aws_prefix
    attr_accessor :aws_utf_symmetric_key

    def initialize(args)
      @aws_access_key = args[:aws_access_key]
      @aws_secret_key = args[:aws_secret_key]
      @aws_bucket = args[:aws_bucket]
      @aws_prefix = args[:aws_prefix]
      @aws_utf_symmetric_key = args[:aws_utf_symmetric_key]
      AWS.config(
        access_key_id: args[:aws_access_key],
        secret_access_key: args[:aws_secret_key]
      )
    end

    # Return the latest s3Object based on a regex filename match.
    def latest(pattern)
      s3 = AWS::S3.new
      objects = s3.buckets[@aws_bucket].objects
      latest = nil
      objects.with_prefix(@aws_prefix).each do |o|
        latest = o if latest.nil?
        old_latest = Regexp.new(pattern).match(latest.key)[1]
        this_latest = Regexp.new(pattern).match(o.key)[1]
        latest = o if this_latest > old_latest
      end
      latest
    end

    def load(key)
      s3 = AWS::S3.new
      s3.buckets[@aws_bucket].objects[key]
    end

    # Get a client encrypted s3Object
    def get(s3Object, destination)
      key = Base64.decode64(@aws_utf_symmetric_key).encode('ascii-8bit')
      options = { encryption_key: key }
      dest = File.join(destination, s3Object.key.split('/').last)
      cl = Humanize::Byte.new(s3Object.content_length)
      mb = "#{cl.to_m}".to_f.round(2)
      gb = "#{cl.to_g}".to_f.round(2)
      size = "#{gb} GB" if mb >= 1000.00
      size = "#{mb} MB" if mb < 1000.00
      count = 0

      $stdout.sync = true
      print "#{s3Object.key} (#{size}) > "
      File.open(dest, 'wb') do |file|
        s3Object.read(options) do |chunk|
          print '=' if count % 1000 == 0
          file.write(chunk)
          count += 1
        end
      end
      print " > #{dest}\n"
    end

    # Describe an s3Object
    def describe(s3Object)
      if s3Object.exists?
        puts "content-type:                       #{s3Object.content_type}" unless s3Object.content_type == ''
        cl = Humanize::Byte.new(s3Object.content_length)
        puts "content bytes:                      #{cl.to_b}"
        puts "content megabytes:                  #{cl.to_m}"
        puts "content gigabytes:                  #{cl.to_g}"
        puts "key:                                #{s3Object.key}" unless s3Object.key.nil?
        puts "bucket:                             #{s3Object.bucket.name}" unless s3Object.bucket.nil?
        puts "etag:                               #{s3Object.etag}" unless s3Object.etag.nil?
        puts "expiration_date:                    #{s3Object.expiration_date}" unless s3Object.expiration_date.nil?
        puts "last modified:                      #{s3Object.last_modified}"
        puts "public url:                         #{s3Object.public_url}"
        puts "24 hour access link:                #{s3Object.url_for(:read)}"
        puts "x-amz-iv:                           #{s3Object.metadata['x-amz-iv']}" unless s3Object.metadata['x-amz-iv'].nil?
        puts "x-amz-key:                          #{s3Object.metadata['x-amz-key']}" unless s3Object.metadata['x-amz-key'].nil?
        puts "x-amz-matdesc:                      #{s3Object.metadata['x-amz-matdesc']}" unless s3Object.metadata['x-amz-matdesc'].nil?
        puts "x-amz-unencrypted-content-length:   #{s3Object.metadata['x-amz-unencrypted-content-length']}" unless s3Object.metadata['x-amz-unencrypted-content-length'].nil?
        puts "server side encryption:             #{s3Object.server_side_encryption}"
      else
        puts "#{s3Object} does not exist."
      end
    end
  end
end
