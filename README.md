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

* [Documentation on RelishApp](https://www.relishapp.com/clnclarinet/compatriot)
* In firefox and chrome, visits a list of paths to a Rack app and takes a screenshot on each page.
* Stores the screenshot in `tmp/results/_timestamp_/_browser_/`
* Creates `tmp/results/_timestamp_/index.html` that shows thumbnails of each screenshot plus a diff of the two in a table for easy comparison.


What it will do in the future
-----------------------------

* Have more documentation (a start is [on RelishApp](https://www.relishapp.com/clnclarinet/compatriot)!)
* Have a screenshot of sample results in the README
* Have more and better tests
* Find the largest, darkest contiguous region in the image diff and have a threshold of pass/fail based on that
* Perform better on the image processing (by sampling/resizing, using oily_png, etc)
* Given a list of URLs/paths to visit, will take a screenshot of each and display which URL it came from in the index
* Given a test command that uses capybara, runs those tests and takes screenshots
* Automatically compare the screenshots across browsers and flags those that are more than some configurable threshold different
* Allow configuration of which browsers to use
* Connect to virtual machines so that you don't have to have all the browsers on the machine you're running the tests on
* Steal some of VCR's relish rake tasks


How To Use
----------

**Requirements**

* Ruby v2.1.7
* [Firefox](http://getfirefox.net)
* [chromedriver](http://code.google.com/p/selenium/wiki/ChromeDriver)

There are setup examples in the examples directory and [documentation on RelishApp](https://www.relishapp.com/clnclarinet/compatriot)

When you run a file similar to the examples it will save results in `_current-directory_/tmp/results/_timestamp_/_browser_`


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

This is a very rough proof-of-concept at this point, so there are many opportunities for improvement. Feel free to:

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
* [relishapp](https://www.relishapp.com/) for documentation
* [vcr](https://github.com/myronmarston/vcr) for having such awesome documentation that it inspired me to use Relishapp


Contributors
------------
* Carol Nichols ([twitter](http://twitter.com/carols10cents), [website](http://carol-nichols.com))
* Andrew Cox ([twitter](https://twitter.com/coxandrew), [website](http://andrewcox.org/))
* Kurtis Rainbolt-Greene ([twitter](https://twitter.com/krainboltgreene), [website](http://kurtisrainboltgreene.name/))
* Steve Klabnik ([twitter](https://twitter.com/steveklabnik), [website](http://www.steveklabnik.com/))
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
