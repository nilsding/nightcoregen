# nightcoregen

Ever wanted to make some sick nightcore tracks, but you totally suck at music?
No need to worry anymore, as there is now `nightcoregen`!  With `nightcoregen`,
you can finally ~~pretend to~~ be one of the best nightcore artists ever.

## System requirements

Any UNIX-like system will work.  Perfect time for installing Gentoo, I guess.

## Features

* Very simple usage
* Works great!
* Automatically generate a video for uploading to YouTube™

## Installation

First of all, install **Ruby 1.9**, **SoX** and **ffmpeg** using your favourite
package manager, such as `aptitude`, `yum`, `pkg`, anything!  
After installing them, proceed to install the Gem bundle:

    $ bundle install

## Usage

Usage is simple:

    $ ./nightcoregen.rb never_gonna_give_you_up.mp3

If you want to specify the output name of the nightcore version, try this:

    $ ./nightcoregen.rb ohrenkrebs.ogg geil.ogg

You can even set the speed (default is 1.25)!

    $ ./nightcoregen.rb coldpizza.ogg hotpizza.ogg 2.50

If you want to have video output, set the environment variable `VIDEO`:

    sh-4.2$ export VIDEO=1
    [tcsh] % setenv VIDEO 1

Run the script as usual afterwards.  After the creation of the video, the shell
script `post-vid.sh` will be run.