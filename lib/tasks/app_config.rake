require File.dirname(__FILE__) + "/rake_helper"

module ApplicationConfiguration
  class Tasks
    include ApplicationConfiguration::Rake
    
    def self.run!
      namespace :app_config do
        desc "Generates the App Config initializer file"
        task :init => :environment do
          copy_initializer_file "The App Config initializer file has been generated."
        end
      end
    end
  end
end

ApplicationConfiguration::Tasks.run!