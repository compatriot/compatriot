Feature: list_of_urls

  Passing a list of URLs to Compatriot.run will visit each of them in each browser and take a screenshot.

  Scenario: List of URLs
    Given a Sinatra app named "simple_app.rb" with:
      """ruby
        get '/' do
          'Hello'
        end

        get '/goodbye' do
          'Goodbye'
        end
      """
    And a file named "compatriot_urls.rb" with:
      """ruby
      $:.unshift(File.expand_path('../../lib', File.dirname(__FILE__)))
      require 'compatriot'
      require_relative 'simple_app'
      Compatriot.app = SimpleApp
      Compatriot.run(%w[
        /
        /goodbye
      ])

      """
    And the directory "tmp/results" does not exist
    When I run `ruby compatriot_urls.rb`
    Then "tmp/results" should have 1 subdirectory
    And there should be results for 2 screenshots
