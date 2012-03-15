require 'redmine'
require 'optparse'

# This hash will hold all of the options
# parsed from the command-line by OptionParser.
options = {}

optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top of the help screen.
  opts.banner = "Usage: redmine [options]"

  # Define the options, and what they do
  opts.on( '-d', '--debug', 'View debug messages' ) do
    options[:debug] = true
  end

  opts.on( '-k', '--key KEY', 'Your key used.' ) do |key|
    options[:key] = key
  end

  opts.on( '-do', '--domain domain', 'Your domain used.' ) do |domain|
    options[:domain] = domain
  end

  opts.on( '-p', '--protocol PROTOCOL', 'Your protocol used.' ) do |protocol|
    options[:protocol] = protocol
  end

  options[:config] = File.join(Dir.home, ".redmine", "config.yml")
  opts.on( '-c', '--config FILE', 'Path to your config-file. (Default: ~/.redmine/config.yml)' ) do |config|
    options[:config] = config
  end

  options[:path] = File.join(Dir.home, ".redmine")
  opts.on('--path PATH', 'Path to your config directory. (Default: ~/.redmine/)' ) do |path|
    options[:path] = path
  end

  # This displays the help screen, all programs are assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

# Parse the command-line. Remember there are two forms
# of the parse method. The 'parse' method simply parses
# ARGV, while the 'parse!' method parses ARGV and removes
# any options found there, as well as any parameters for
# the options. What's left is the list of files to resize.
optparse.parse!

config = Redmine::Config.new(options)
client = Redmine::Client.new(config)

issues = client.my_issues

issues.each do |project, issues|
  puts "\n[#{project}]"

  issues.each do |i|
    puts "* #{i[:title]}"
  end
end

