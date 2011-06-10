require 'test/unit'
require 'app_config'

# sudo gem install technicalpickles-jeweler -s http://gems.github.com

class AppConfigTest < Test::Unit::TestCase
  
  # everything has to be tested in this one file test case since we 
  # can only have one ApplicationConfiguration instance (Settings)
  def test_everything
    case_missing_files
    
    case_empty_files
    
    case_reload
    
    case_nested_settings
    case_array_settings
    case_erb_settings
    
    case_recursive_merge
    
    case_non_existant_values
    
    # FIXME: these test cases do not want to pass
#    case_environments 
#    case_use_environment_override_with
#    case_use_environment_override_with_no_file
  end

private

  def case_missing_files
    ApplicationConfiguration.setup { |c|
      c.add_file("not_here1")
      c.add_file("not_here2")
    }
    
    assert_equal OpenStruct.new, Settings
  end
  
  def case_empty_files
    Settings.add_file 'test/empty1.yml'
    Settings.add_file 'test/empty2.yml'
    Settings.reload!
    
    assert_equal OpenStruct.new, Settings
  end
  
  def case_reload
    Settings.add_file 'test/development.yml'
    Settings.reload!

    assert_equal 4, Settings.to_h.size
  end
  
  def case_nested_settings
    Settings.add_file 'test/development.yml'
    Settings.reload!

    assert_equal 3, Settings.section.size
  end
  
  def case_array_settings
    Settings.add_file 'test/development.yml'
    Settings.reload!

    assert_equal 'yahoo.com', Settings.section.servers[0].name
    assert_equal 'amazon.com', Settings.section.servers[1].name
  end

  def case_erb_settings
    assert_equal 6, Settings.computed
  end

  def case_recursive_merge
    Settings.add_file 'test/app_config.yml'
    Settings.add_file 'test/development.yml'
    Settings.reload!
  
    assert_equal 'support@domain.com', Settings.emails.support
    assert_equal 'webmaster@domain.com', Settings.emails.webmaster
    assert_equal 'feedback@domain.com', Settings.emails.feedback
  end

  def case_non_existant_values
    Settings.add_file 'test/app_config.yml'
    Settings.reload!

    assert_raise(NoMethodError){ Settings.not_here1 = "blah" }
    assert_raise(NoMethodError){ Settings.not_here2 }
  end

  def case_environments
    Settings.add_file 'test/environments.yml'
    Settings.use_environment!("development")
    Settings.reload!
    
    assert_equal 2, Settings.size
    assert_equal "google.com", Settings.server
    assert_equal 6, Settings.computed
    assert_equal 3, Settings.section.size
    assert_equal "yahoo.com", Settings.section.servers[0].name
    assert_equal "amazon.com", Settings.section.servers[1].name
    assert_equal "webmaster@domain.com", Settings.emails.webmaster
    assert_equal "feedback@domain.com", Settings.emails.feedback
    assert_raise(NoMethodError){ Settings.emails.support }
  end

  def case_use_environment_override_with
    Settings.add_file 'test/environments.yml'
    Settings.use_environment!("development", :override_with => "test/override_with.yml")
    Settings.reload!

    assert_equal 10, Settings.size
    assert_equal "over.com", Settings.section.servers[0].name
    assert_equal "ride.com", Settings.section.servers[1].name
    assert_equal "google.com", Settings.server
    assert_equal 6, Settings.computed
    assert_equal "webmaster@domain.com", Settings.emails.webmaster
    assert_equal "feedback@domain.com", Settings.emails.feedback
    assert_raise(NoMethodError){ Settings.emails.support }
  end
  
  def case_use_environment_override_with_no_file
    Settings.add_file 'test/environments.yml'
    Settings.use_environment!("development", :override_with => "test/non_existant.yml")
    Settings.reload!

    assert_equal 2, Settings.size
    assert_equal "google.com", Settings.server
    assert_equal 6, Settings.computed
    assert_equal 3, Settings.section.size
    assert_equal "yahoo.com", Settings.section.servers[0].name
    assert_equal "amazon.com", Settings.section.servers[1].name
    assert_equal "webmaster@domain.com", Settings.emails.webmaster
    assert_equal "feedback@domain.com", Settings.emails.feedback
    assert_raise(NoMethodError){ Settings.emails.support }
  end
  
end
