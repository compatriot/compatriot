Compatriot
==========
[![Build Status](https://secure.travis-ci.org/carols10cents/compatriot.png?branch=master)](http://travis-ci.org/carols10cents/compatriot)

**Compat**ibility + **riot**! It's the **friend** that helps with browser compatibility!
This Ruby gem makes cross-browser testing less painful.
Its goal is to help identify pages that appear to have significant variations when rendered in different browsers.
You can spend your time fixing the cross-browser problems rather than looking for them.
Don't let your users find the inconsistencies and get to them first.


What it does now
----------------

* Adds a `assert_no_ui_changes` method to your test assertions
* When called from your tests, it takes a screenshot and compares it to a control image to get percentage difference
* If the difference is greater then the threshold, it fails the tests
* Pairs well with [BrowserStacks automation feature](browserstack.com/automate) to run across many environments

What it will do in the future
-----------------------------

* Have a screenshot of sample results in the README
* Have more and better tests
* Perform better on the image processing (by sampling/resizing, using oily_png, etc)
* Show a better image difference

How To Use
----------

**Requirements**

* Ruby v2.1.7
* [Capybara](http://jnicklas.github.io/capybara/)

1. Require `compatriot` in your test helper, 
2. and include `Compatriot::Assertions` in your test class
3. and configure Compatriot

    ```ruby
    require 'compatriot'

    class IntegrationTest
    include Compatriot::Assertions
    
    Minitest::Reporters.use! Compatriot::MinitestReportDriver.new # Optional: if you want html output. See MinitestReporters for more info

      Compatriot.configure do |config|
        screenshot_directory = 
          './test/screenshots/' +
          caps['os'] + '_' +       #caps(Capabilities) is how we tell browserstack what environment to use
          caps['os_version'] + '_' +
          caps['browser'] + '_' +
          caps['browser_version']
        config.screenshot_directory = screenshot_directory.downcase
        config.ui_difference_threshold = 0.05
      end
      ...
    ```

4. Call `assert_no_ui_changes` from your tests

    ```ruby
    it 'does not break the ui' do
      visit some_page_path
      assert_no_ui_changes
    end
    ```

The first time through it will create the control image in `#{screenshot_directory}/control`. You should then review the screenshots and check them into source control as your baseline.
Every run after that, it will take a variable image screenshot in `#{screenshot_directory}/variable` and generate a difference image in `#{screenshot_directory}/diffs`.

`assert_no_ui_changes` takes an optional string parameter to allow you to make multiple assertions in a test and not run into name conflicts.

example:
```ruby
it 'has multiple ui change assertions' do
  visit page_1
  assert_no_ui_changes 'page 1'
  visit page_2
  assert_no_ui_changes 'page 2'
end
```

To see the % difference for every assertion, and get the path the the difference, set `config.show_diffs = true` when you configure Compatriot.


How to run this against multiple environments?
----------------------------------------------

The intentions for running this against multiple environments is that you would run your test suite once for every environment you wish to run it against.
To accomplish this, you should set your `screenshot_directory` to include the current environment name, this way you will store your control images in separate directories.

*Note: The configuration example above shows you how to set the directory using the specified capabilities.*

What to do to run its tests
---------------------------

Using at least ruby 2.1.7:

    bundle install
    bundle exec rake test

This is using minispec for testing.


How You Can Contribute
----------------------

* [Issues](https://github.com/clnclarinet/compatriot/issues)

We'd really like to know if something is wrong, so please file an issue on the Issue List if you have a problem, suggestion, unsupported use case, etc.

There are many opportunities for improvement. Feel free to:

* **Fork** the repository
* **Clone the repository** locally, or **edit via Github**
* Create a **new branch** with a meaningful name of the issue or feature you're working on
* Commit **often** and **when important**
* **Write tests** specifically for the changes you've made (unless you're fixing a failing test. Also: just submitting new tests for untested code is a big help too!)
* **Push** your feature or bug fix branch to your Github fork
* Make a **Pull Request** from your fork to the main repo

Ryan Bates did an awesome [Railscast on contributing to open source](http://railscasts.com/episodes/300-contributing-to-open-source) that walks through this process, but please let us know if you have any questions or problems.

Standing on the shoulders of giants
-----------------------------------

Many thanks to the wonderful libraries that make this gem possible:

* [capybara](https://github.com/jnicklas/capybara)
* [selenium-webdriver](http://seleniumhq.org/docs/01_introducing_selenium.html#selenium-2-aka-selenium-webdriver)
* [chunky_png](https://github.com/wvanbergen/chunky_png) (and especially [this blog post about using chunky_png to create image diffs](http://jeffkreeftmeijer.com/2011/comparing-images-and-creating-image-diffs/?utm_source=rubyweekly&utm_medium=email) by Jeff Kreeftmeijer)
* [travis](http://travis-ci.org/) for CI

Contributors
------------
* [Carol Nichols](https://github.com/carols10cents) ([twitter](http://twitter.com/carols10cents), [website](http://carol-nichols.com))
* Andrew Cox ([twitter](https://twitter.com/coxandrew), [website](http://andrewcox.org/))
* Kurtis Rainbolt-Greene ([twitter](https://twitter.com/krainboltgreene), [website](http://kurtisrainboltgreene.name/))
* [Steve Klabnik](Klabnik) ([twitter](https://twitter.com/steveklabnik), [website](http://www.steveklabnik.com/))
* [Jeff Koenig](https://github.com/thejefe) ([twitter](http://twitter.com/jeffkoenig)
* You???


License
-------

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
