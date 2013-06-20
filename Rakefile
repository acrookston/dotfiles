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

namspace :config do

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
