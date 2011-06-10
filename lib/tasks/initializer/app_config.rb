require 'app_config'

ApplicationConfiguration.setup do |conf|
  conf.config_name = "Settings"

  conf.add_file("#{Rails.root}/config/app_config.yml")
  conf.add_file("#{Rails.root}/config/environments/#{Rails.env}.yml")

#  conf.add_file("#{Rails.root}/config/...")
end
