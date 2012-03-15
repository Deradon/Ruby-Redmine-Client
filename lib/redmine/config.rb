module Redmine
  class Config
    include Redmine::Debug
    require 'fileutils'
    require 'yaml'

    DEFAULT_PATH = File.join(Dir.home, ".redmine")
    DEFAULT_FILE = "config.yml"

    DEFAULT_CONFIG = {
      :key => nil
    }

    # Constructor
    def initialize(options = {})
      options = {
        :debug    => false,
        :domain   => nil,
        :key      => nil,
        :config   => File.join(DEFAULT_PATH, DEFAULT_FILE),
        :path     => nil,
        :protocol => "http"
      }.merge(options)

      @debug        = options[:debug]
      @config_path  = options[:config] ||
                      File.join(options[:path] || DEFAULT_PATH, DEFAULT_FILE)
      config        = read_config(@config_path)

      @config = {
        :key      => options[:key] || config[:key],
        :domain   => options[:domain] || config[:domain],
        :protocol => options[:protocol] || config[:protocol],
        :path     => DEFAULT_PATH  || config[:path]
      }
      update if @config != config
    end

    def key
      @config[:key]
    end

    def domain
      @config[:domain]
    end

    def protocol
      @config[:protocol]
    end

    # Path where to store data
    def path
      @config[:path]
    end

    def location
      @config_path
    end

    # Write current config to disc
    def update
      update_config(@config, @config_path)
    end

    def to_hash
      {
        :debug    => debug?,
        :key      => key,
        :domain   => domain,
        :protocol => protocol
      }
    end



    private
      def read_config(path)
        create_config_file(path) unless File.exist?(path)
        YAML::load(File.open(path))
      end

      def create_config_file(path)
        write_config_file(DEFAULT_CONFIG, path)
      end

      def update_config(config, path)
        write_config_file(config, path)
      end

      def write_config_file(config, path)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w') do |f|
          f.write(YAML::dump(config))
        end
      end
  end
end

