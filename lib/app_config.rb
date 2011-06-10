require 'closed_struct'
require 'yaml'
require 'erb'


module ApplicationConfiguration 
  class << self
    # ensures the setup only gets run once
    @@ran_once = false

    @@config_paths = []
    
    attr_reader :config_name
    @@config_name = "Settings"
    
    def config_name=(name)
      return if @@ran_once == true
      @@config_name = name
    end
    
    def setup
      yield self if @@ran_once == false
      @@ran_once = true
      reload!
    end
    
    def add_file(file_path)
      @@config_paths << file_path
      true
    end
    
    # Rereads your configuration files and rebuilds your ApplicationConfiguration object.  This is useful
    # for when you edit your config files, but don't want to restart your web server.
    def reload!
      @config_hash = {}
      @@config_paths.each { |conf_path| 
        conf_file = load_conf_file(conf_path) 
        @config_hash = recursive_merge(@config_hash, conf_file) unless (conf_file.empty? && conf_file.nil?)
      }
      
      @config = ClosedStruct.r_new(@config_hash)
      set_global_config(@config)
    end

    def use_environment!(environment, options = {})
      raise ArgumentError, "environment doesn't exist in app config: #{environment}" \
        unless @config_hash.has_key?(environment.to_s)

      @config_hash = @config_hash[environment.to_s]
      @config = @config.send(environment)

      if options[:override_with] and File.exist?(options[:override_with])
        overriding_config = load_conf_file(options[:override_with])
        @config_hash = recursive_merge(@config_hash, overriding_config)  
        @config = ClosedStruct.r_new(@config_hash)
        set_global_config(@config)     
      end
    end

  private

    def set_global_config(config)
      Kernel.send(:remove_const, @@config_name) if Kernel.const_defined?(@@config_name)
      Kernel.const_set(@@config_name, config)
      
      Kernel.const_get(@@config_name)
    end
    
    def method_missing(name, *args)
      if @config.respond_to?(name)
        @config.send(name, *args)
      else
        super
      end
    end

    def load_conf_file(conf_path)
      return {} if !conf_path or conf_path.empty? or !File.exist?(conf_path)
      File.open(conf_path, "r") do |file|
        YAML.load(ERB.new(file.read).result) || {}
      end
    end

    # Recursively merges hashes.  h2 will overwrite h1.
    def recursive_merge(h1, h2) #:nodoc:
      h1.merge(h2){ |k, v1, v2| v2.kind_of?(Hash) ? recursive_merge(v1, v2) : v2 }
    end
  
  end
end