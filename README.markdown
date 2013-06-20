DOTFILES
========

Because automation beats manual work every time! ...and versioning your environement is cool.

About this
----------
This is a git repository for my personal dotfiles, e.g. configuration files for Mac OS X.
Configuration might work on *NIX systems but I'd recommend to chekout the original Mange/dotfiles. Mange is better at being strict on *NIX files than I am.

Please note that this repository is very personal, and small changes might be added all the time. If you want to use this for yourself and are not a mental clone of me, you'd want to fork this and merge back changes you like and ignore those you hate. If you have proposals for my repo, just do a pull request so I can check it out.

Preference bias
---------------
I'm biased towards Ruby, Git and VIM so most configurations should be inline with this ecosystem. I use both Linux and Mac systems so no preference will be taken there.

Installation
------------
 * Begin by cloning this repository somewhere on your machine, for example ~/dotfiles.
 * If you're setting up a new computer and want Homebrew + a load of software, Janus etc installed, run:
 * `rake system:install`
 * When you're done. To setup your dot/config files run:
 * `rake config:install`
 * You're done!

Any files found conflicting will be backed up. Check the output of the installer.


Disclaimer
----------
Relaseased under MIT license.

This software is very untested for bugs. It worked on my new OS X 10.8 Mountain Lion.

As always should you choose to use this you do so at your own risk. You can
not hold the creators of this software liable for any harm done to your
computer. Read the LICENSE file for details.
