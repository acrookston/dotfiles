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

Shell setup
-----------
`profile` holds everything both shells share: aliases, PATH, exports, and tool
hooks (rbenv, rvm, direnv, Homebrew). It's kept POSIX-compatible, so it must
stay free of bashisms and zshisms.

`zshrc` and `bashrc` each source `~/.profile` first, then add the parts that
can't be shared: prompt, completion, history and key bindings. `bash_profile`
just sources `~/.bashrc`, since login bash skips it otherwise.

zsh is the default shell on modern macOS, so `zshrc` is the one that matters
there. Machine-specific or secret settings go in `~/.profile_private`,
`~/.zshrc_private` or `~/.bashrc_private`, none of which are tracked here.

Git and the default branch
--------------------------
Aliases that used to hardcode `origin/master` (`rom`, `riom`, `dom`, `lb`,
`lf`, `go`, and the `grom`/`gbclean`/`crushpng` shell aliases) now resolve the
branch at runtime via `bin/git-default-branch`, so they work in `master` and
`main` repos alike. It reads `origin/HEAD` first, then falls back to whichever
of main/master/trunk/develop actually exists -- all locally, no network call.

If a repo reports the wrong branch, its `origin/HEAD` is stale or missing:

    git remote set-head origin --auto

`bin/` is symlinked to `~/bin` by `rake config:bin`, which the git aliases
need on PATH.

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
