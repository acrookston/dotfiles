require File.expand_path('../support/dotfile', __FILE__)
require 'fileutils'

SYMLINKS = %w[
  ackrc
  gemrc
  irbrc
  git_template
  railsrc
  rspec
  tmux.conf
  vimrc.before
  vimrc.after
  tm_properties
  profile
]
FILES = []

GIT_ALIASES = {
  :unadd => 'reset HEAD',
  :a  => 'add',
  :aa => 'add --all',
  :ap => 'add --patch',
  :amend => 'commit --amend',
  :fix => 'commit --amend -C HEAD',
  :s   => 'status',
  :w   => 'whatchanged',
  :d   => 'diff',
  :dc  => 'diff --cached',
  :ds  => 'diff --stat',
  :dom => 'diff origin/master',
  :b   => 'branch',
  :l   => 'log',
  :g   => "log --all --decorate --graph --pretty=format:'%C(yellow)%h %C(red)%ad %C(blue)%an%C(green)%d %C(reset)%s' --date=short --abbrev-commit",
  :lo  => "log --pretty=format:'%C(yellow)%h %C(red)%ad %C(blue)%an%C(green)%d %C(reset)%s' --date=short",
  :go  => "log --pretty=format:'%C(yellow)%h %C(red)%ad %C(blue)%an%C(green)%d %C(reset)%s' --date=short -i origin/master --grep",
  :lb  => 'log --format=oneline origin/master',
  :lg  => 'log --grep',
  :lf  => 'log -i --format=oneline origin/master --grep',
  :ll  => 'log -p',
  :c   => 'commit',
  :co  => 'checkout',
  :pr  => 'pull --rebase',
  :r   => 'rebase',
  :rom => 'rebase origin/master',
  :rn  => 'revert --no-commit',
  :sp  => 'stash pop',
  :sl  => 'stash list',
  :hist  => 'log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short new = !sh -c \'git log $1@{1}..$1@{0} \"$@\"\' prune = !git remote | xargs -n 1 git remote prune ',
  :new   => %(!sh -c 'git log $1@{1}..$1@{0} "$@"'),
  :prune => %(!git remote | xargs -n 1 git remote prune)
}

HOMEBREW_FORMULAE = %w[
  ack
  advancecomp
  curl
  elasticsearch
  gist
  git
  gnutls
  growlnotify
  hiredis
  imagemagick
  intltool
  libevent
  links
  macvim
  mongodb
  mysql
  nginx
  ngrep
  nmap
  node
  optipng
  pngcrush
  pngout
  redis
  sphinx
  the_silver_searcher
  wget
]

namespace :config do

SYMLINKS.each do |file|
  desc "Installs #{file} by symlinking it inside your home"
  task file do
    Dotfile.new(file).install_symlink
  end
end

FILES.each do |file|
  desc "Installs #{file} by copying it to your home"
  task file do
    Dotfile.new(file).install_copy
  end
end

desc "Installs the global gitignore file"
task :gitignore do
  Dotfile.new('gitignore').install_symlink
  unless system('git config --global core.excludesfile "$HOME/.gitignore"')
    STDERR.puts "Could not set git excludesfile. Continuing..."
  end
end

desc "Does some basic Git setup"
task :gitconfig do
  exec = lambda { |command| system(*command) or STDERR.puts "Command failed: #{command.join(' ')}" }
  config = lambda { |setting, value| exec[['git', 'config', '--global', setting, value]] }

  config["push.default", "tracking"]
  config["color.ui", "true"]

  confirm = 'n'
  while (confirm != 'y')
    puts "Git config setup:"
    print "What's your name? "
    name = $stdin.gets.chomp
    print "What's your email? "
    email = $stdin.gets.chomp
    print "What's your Github username? "
    username = $stdin.gets.chomp

    puts "\nName: #{name}\nEmail: #{email}\nGithub username: #{username}"
    print "Is this information correct? [y/n] "
    confirm = $stdin.gets.chomp
  end
  config["user.name", name]
  config["user.email", email]
  config["github.user", username]

  config["gist.private", "yes"]

  config["color.branch.current", "bold green"]
  config["color.branch.local", "green"]
  config["color.branch.remote", "blue"]

  config["merge.conflictstyle", "diff3"]
  config["merge.fugitive.cmd", 'mvim -f -c "Gdiff" "$MERGED"']
  config["merge.tool", "fugitive"]

  config["rebase.autosquash", "true"]
  config["rebase.stat", "true"]

  config["init.templatedir", "~/.git_template"]

  GIT_ALIASES.each do |short, command|
    config["alias.#{short}", command]
  end
end

desc "Installs all files"
task :install => (SYMLINKS + FILES + %w[gitignore gitconfig]) do
  puts "All done!"
end

desc "Clears all 'legacy' files (like old symlinks)"
task :cleanup do
  Dotfile.new('screenrc').delete_target(:only_symlink => true)
  Dotfile.new('pentadactylrc').delete_target(:only_symlink => true)
end

desc "Install and clean up old files"
task :update => [:install, :cleanup]

desc "Clears all symlinks"
task :clear_symlinks do
  SYMLINKS.each do |file|
    Dotfile.new(file).delete_target
  end
end
end


namespace :system do

task :confirm_xcode do
  print "Did you install Xcode AND Xcode CLI Tools? [y/n] "
  answer = $stdin.gets || 'y'

  if answer.chomp != 'y'
    puts "Install Xcode from Mac App Store and CLI Tools from https://developer.apple.com/downloads/index.action"
    system 'open https://developer.apple.com/downloads/index.action'
    system 'open https://itunes.apple.com/se/app/xcode/id497799835?l=en&mt=12'
    exit
  end
end

task :pause do
  puts "Please adress any issues above manually (in a different terminal window) then press enter to continue."
  $stdin.gets
end

desc "Install Homebrew"
task :install_homebrew do
  puts "=> Installing Homebrew"
  system 'ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"'
  puts "Installed. Checking Homebrew doctor"
  system 'brew doctor'
end

desc "Install Homebrew formulae"
task :install_formulae do
  puts "=> Homebrew installing #{HOMEBREW_FORMULAE.join(' ')}"
  system "brew install #{HOMEBREW_FORMULAE.join(' ')}"
end

desc "Install Janus"
task :install_janus do
  puts "Installing Janus"
  system 'curl -Lo- https://bit.ly/janus-bootstrap | bash'

  janus_dir = "#{ENV['HOME']}/.janus"
  FileUtil.mkdir janus_dir unless File.directory?(janus_dir)
  system "cd #{janus_dir} && git clone http://github.com/flazz/vim-colorschemes colorschemes"
end

desc "Start installation of a new system"
task :install => [:confirm_xcode,
                  :install_homebrew,
                  :pause,
                  :install_formulae,
                  :pause,
                  :install_janus] do
end
end
