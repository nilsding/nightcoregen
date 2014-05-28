#!/bin/sh
#
# post-vid.sh
#   the script that runs after the nightcore video has been rendered
#
# This file is part of nightcoregen
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

VIDEO_FILE=$1

if [ ! $VIDEO_FILE ]; then
    printf "\033[01;31m==================================================================\n"
    printf            "===  THIS FILE IS \033[04mNOT\033[00;01;31m INTENDED TO RUN OUTSIDE OF NIGHTCOREGEN  ===\n"
    printf            "==================================================================\033[0m\n"
    exit 1
fi

# Your code goes here, this one commented out here will move the file into a
# folder where my webserver has access to.
# You can use $VIDEO_FILE for the output video file

mv $VIDEO_FILE /var/www/nilsding.org/nightcore/output
echo $VIDEO_FILE > .last