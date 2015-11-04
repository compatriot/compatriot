module CompatriotHelpers
  def create_sinatra_app(file_name, content)
    app_class = camelize(file_name.gsub(/\.rb$/, ''))
    beginning_sinatra_app = <<-HERE
require 'sinatra/base'
require 'rack'
require 'yaml'

class #{app_class} < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :static, true
HERE

    ending_sinatra_app = <<-HERE

end

if __FILE__ == $0
  Rack::Handler::WEBrick.run #{app_class}, :Port => 8070
end
HERE
    beginning_sinatra_app + content + ending_sinatra_app
  end

  def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      lower_case_and_underscored_word.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end
end
World(CompatriotHelpers)

Given /^a Sinatra app named "([^"]*)" with:$/ do |file_name, content|
  write_file(file_name, create_sinatra_app(file_name, content))
end

Then /^"([^"]*)" should have (\d+) subdir/ do |directory, subdirectory_count|
  in_current_dir do
    (Dir.entries(directory) - [".", ".."]).size.should == subdirectory_count.to_i
  end
end

Then /^there should be results for (\d+) screenshots?$/ do |screenshot_count|
  screenshot_count = screenshot_count.to_i
  results_tmp_dir = "tmp/results"
  in_current_dir do
    current_results_dir = (Dir.entries(results_tmp_dir) - [".", ".."]).first
    current_results_dir = File.join(results_tmp_dir, current_results_dir)

    firefox_dir = File.join(current_results_dir, "firefox")
    chrome_dir  = File.join(current_results_dir, "chrome")
    diffs_dir   = File.join(current_results_dir, "diffs")

    Dir.glob(File.join(firefox_dir, "*.png")).size.should == 2
    Dir.glob(File.join(chrome_dir, "*.png")).size.should == 2
    Dir.glob(File.join(diffs_dir, "*.png")).size.should == 2
  end
end
