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

HOMEBREW_FORMULAE = %w[
  direnv
  ack
  advancecomp
  elasticsearch
  gist
  git
  gnutls
  hiredis
  imagemagick
  intltool
  libevent
  links
  macvim
  mongodb
  mysql
  mysql-connector-c
  nginx
  ngrep
  nmap
  node
  optipng
  pngcrush
  redis
  sphinx
  the_silver_searcher
  wget
  hub
]
# brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo

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

desc "Install git config"
task :gitconfig do

  file = Dotfile.new('gitconfig')
  file.delete_target
  file.install_copy
  unless system('git config --global core.excludesfile "$HOME/.gitignore"')
    STDERR.puts "Could not set git excludesfile. Continuing..."
  end

  exec = lambda { |command| system(*command) or STDERR.puts "Command failed: #{command.join(' ')}" }
  config = lambda { |setting, value| exec[['git', 'config', '--global', setting, value]] }

  config["push.default", "current"]
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

  puts "Use gpg signing? (y/n)"
  confirm = ''
  while (confirm != 'y' && confirm != 'n')
    confirm = $stdin.gets.chomp
    if confirm == 'y'
      puts "Enter signing key: "
      signingkey = $stdin.gets.chomp
      config["commit.gpgsign", "true"]
      config["user.signingkey", signingkey]
    end
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
  puts ">>> Please adress any issues above manually (in a different terminal window) then press enter to continue."
  $stdin.gets
end

desc "Install Homebrew"
task :install_homebrew do
  puts ">>> Installing Homebrew"
  system 'ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"'
  puts "Installed. Checking Homebrew doctor"
  system 'brew doctor'
end

desc "Install Homebrew formulae"
task :install_formulae do
  puts ">>> Homebrew installing #{HOMEBREW_FORMULAE.join(' ')}"
  system "brew install #{HOMEBREW_FORMULAE.join(' ')}"
end

desc "Show homebrew info for all formuale"
task :show_brew_info do
  system "brew info #{HOMEBREW_FORMULAE.join(' ')}"
end

desc "Install Janus"
task :install_janus do
  puts ">>> Installing Janus"
  system 'curl -Lo- https://bit.ly/janus-bootstrap | bash'

  janus_dir = "#{ENV['HOME']}/.janus"
  FileUtils.mkdir janus_dir unless File.directory?(janus_dir)
  system "cd #{janus_dir} && git clone http://github.com/flazz/vim-colorschemes colorschemes"
end

desc "Start installation of a new system"
task :install => [:confirm_xcode,
                  :install_homebrew,
                  :pause,
                  :install_formulae,
                  :show_brew_info,
                  :pause,
                  :install_janus] do
end
end
