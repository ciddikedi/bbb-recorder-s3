#!/usr/bin/ruby

require 'yaml'
require 'rubygems'
require 'aws-sdk-s3'
require 'fileutils'
require 'optparse'

playback = nil
meeting_id = nil
OptionParser.new do |opts|
  opts.on('-m', '--meeting-id MEETING_ID', 'Internal Meeting ID') do |v|
    meeting_id = v
  end
  opts.on('-p', '--playback PLAYBACK', 'Recording Format') do |v|
    playback = v
  end
end.parse!

unless meeting_id
  msg = 'Meeting ID was not provided'
  puts(msg) && raise(msg)
end


if !Dir.exist?('/var/bigbluebutton/record_mp4')
  FileUtils.mkdir_p '/var/bigbluebutton/record_mp4/temp/'
  FileUtils.mkdir_p '/var/bigbluebutton/record_mp4/uploaded/'
end

#playback = opts[:playback]
creds = YAML::load(File.open('/usr/local/bigbluebutton/core/scripts/s3_creds.yml'))
endpoint = creds['endpoint']
access_key_id = creds['access_key_id']
secret_access_key = creds['secret_access_key']
bucket = creds['bucket']
region = creds['region']

s3Client = Aws::S3::Client.new(endpoint: endpoint, access_key_id: access_key_id, secret_access_key: secret_access_key, region: region)
s3Resource = Aws::S3::Resource.new(client: s3Client)
bucketObj = s3Resource.bucket(bucket)

puts("node export.js \"" + playback +  "\" " + meeting_id + ".webm 0 true")
system("node export.js \"" + playback +  "\" " + meeting_id + ".webm 0 true")

file_name = '/var/bigbluebutton/record_mp4/temp/' + meeting_id + '.mp4'
key = File.basename(file_name)
puts "Uploading file #{file_name} to bucket #{bucket}..."

s3Client.put_object(
  :bucket => bucket,
  :key    => bucket + '/' + key,
  :body   => IO.read(file_name),
  :acl    => 'public-read'
)

if(bucketObj.object(bucket + '/' + meeting_id + '.mp4').exists?)
  File.delete('/var/bigbluebutton/record_mp4/temp/' + meeting_id + '.mp4')
  FileUtils.touch('/var/bigbluebutton/record_mp4/uploaded/' + meeting_id + '.done')
  system "curl https://apilb.uzep.org/api/Meeting/S3Ready?id=" + meeting_id
  puts "success"
end

puts "ended"
