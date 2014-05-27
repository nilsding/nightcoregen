#!/usr/bin/env ruby
#
# nightcoregen
#   generate some sick nightcore traxx and prepare videos in a YouTube ready
#   format
# Copyright (C) 2014 nilsding
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'rubygems'
require 'ruby-sox'
require 'securerandom'
require 'taglib'
require 'google-search'
require 'open-uri'
require 'shellwords'

DEFAULT_AMOUNT = 1.25

##
# rapes the song
def nightcorize(infile, outfile, amount=DEFAULT_AMOUNT)
  sox = Sox::Cmd.new()
  sox.add_input infile
  sox.set_output outfile
  sox.set_effects speed: amount
  begin
    puts "[nightcorize] starting SoX"
    sox.run
  rescue Sox::Error => serr
    puts "[nightcorize] SoX error: #{serr.message}"
    raise
  end
end

##
# prepares the song for uploading it to video services
def youtubize(audio_file)
  # generate an UUID
  uuid = SecureRandom.uuid
  
  # get the tags from the audio file, if possible
  puts "[youtubize] called with file: #{audio_file}" if ENV['DEBUG']
  
  search_arg = ''
  
  TagLib::FileRef.open audio_file do |fileref|
    unless fileref.nil?
      if fileref.tag.title.nil?
        search_arg = audio_file.split(/[_ ]/).sample
      else
        search_arg = fileref.tag.title.split(' ').sample
      end
    end
  end
  
  # get a random image based on the search
  puts "[youtubize] searching Google Images for: anime #{search_arg}" if ENV['DEBUG']
  images = []
  Google::Search::Image.new(query: "anime #{search_arg}").each_with_index do |img|
    images << img.uri
  end
  
  if images.length == 0
    puts "[youtubize] No images found using search terms \"anime #{search_arg}\" :("
    raise
  end
  
  image_url = images.sample
  
  puts "[youtubize] image url: #{image_url}" if ENV['DEBUG']
  
  file_ext = image_url.gsub /(.*)(\.\w+)$/, '\2'
  
  image_name = "tmp_nightcoregen-#{uuid}#{file_ext}"
  puts "[youtubize] local image name: #{image_name}" if ENV['DEBUG']
  
  # now save the image to a file
  File.open(image_name, "wb") do |local|
    open(image_url, "rb") do |remote|
      local.write remote.read
    end
  end
  
  # let's start ffmpeg!
  puts "[youtubize] starting ffmpeg"
  cmdline = "ffmpeg -y  -loop 1 -i #{Shellwords.escape image_name} -i #{Shellwords.escape audio_file} -s 1280x720 -vcodec libx264 -preset fast -crf 14 -acodec libmp3lame -q:a 2 -shortest -threads 3 \"out_nightcoregen-#{Shellwords.escape uuid}.mp4\""
  cmdline.gsub(/([\\t\| &`<>)('"])/) do |s|
    '\'' << s
  end
            
  puts "[youtubize] #{cmdline}" if ENV['DEBUG']
  system(cmdline)
  
  return "out_nightcoregen-#{Shellwords.escape uuid}.mp4"
end

if __FILE__ == $PROGRAM_NAME
  unless ARGV[0]
    puts "usage: #{$PROGRAM_NAME} infile [outfile [amount]]"
    exit 127
  end
  
  unless ARGV[1]
    ARGV[1] = ARGV[0].gsub /(\.\w+)$/, '.nc\1'
  end
  
  puts "[main] infile: #{ARGV[0]}" if ENV['DEBUG']
  puts "[main] outfile: #{ARGV[1]}" if ENV['DEBUG'] 
  
  begin
    nightcorize ARGV[0], ARGV[1], (DEFAULT_AMOUNT unless ARGV[2])
  rescue
    exit(63)
  end
  
  begin
    video_file = youtubize ARGV[1] if ENV['VIDEO']
    system("sh #{Shellwords.escape File.expand_path("post-vid.sh")} #{Shellwords.escape video_file}")
  rescue
  end
end

# kate: indent-width 2