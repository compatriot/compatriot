Compatriot
==========

**Compat**ibility + **riot**! It's the *friend** that helps with browser compatibility!
This Ruby gem makes cross-browser testing less painful.
It's goal is to help identify pages that appear to have significant variations when rendered in different browsers.
You can spend your time fixing the cross-browser problems rather than looking for them.
Don't let your users find the inconsistencies and get to them first.


What it does now
----------------

* Goes to the root path of a Rack app in firefox and chrome and takes a screenshot in each.
* Stores the screenshot in `tmp/results/_timestamp_/_browser_/`
* Creates `tmp/results/_timestamp_/index.html` that shows thumbnails of each screenshot plus a diff of the two in a table for easy comparison.


What it will do in the future
-----------------------------

* Have documentation
* Have a screenshot of sample results in the README
* Have unit tests and better tests
* Be on travis-ci
* Not have a diff that's a different size than the originals
* Find the largest, darkest contiguous region in the image diff and have a threshold of pass/fail based on that
* Perform better on the image processing (by sampling/resizing, using oily_png, etc)
* Given a list of URLs/paths to visit, will take a screenshot of each and display which URL it came from in the index
* Given a test command that uses capybara, runs those tests and takes screenshots
* Automatically compare the screenshots across browsers and flags those that are more than some configurable threshold different
* Allow configuration of which browsers to use
* Connect to virtual machines so that you don't have to have all the browsers on the machine you're running the tests on


How To Use
----------

**Requirements**
1. Ruby v1.9.2
1. [Firefox]() vX.Y
2. [chromedriver](http://code.google.com/p/selenium/wiki/ChromeDriver) vX.Y.Z

When you run a file similar to the examples it will save results in `_current-directory_/tmp/results/_timestamp_/_browser_`


What to do to run its tests
---------------------------

Using at least ruby 1.9.2:

    bundle install
    bundle exec rake test

This is using minispec for testing.


How You Can Contribute
----------------------

* [Issues](https://github.com/krainboltgreene/tardis/issues)

Remember that we really want to know if something is wrong, so use the Issue List if you have a problem.
This is a very rough proof-of-concept at this point, so there are many opportunities for improvement. Feel free to:

* **Fork** the repository
* **Clone the repository** locally, or **edit via Github**
* Create a **new branch** using the [Git Flow Standard](http://yakiloo.com/getting-started-git-flow/) conventions
* Commit **often** and **when important**
* **DO NOT CHANGE** ANY OF THESE (without making a new branch for *that* change):
  * `*.gemspec`
  * `Rakefile`
  * `.rvmrc`
  * `.gitignore`
  * Any part of the git history
* **Push** your feature or hotfix branch to Github.
* Make a **Pull Request**


Standing on the shoulders of giants
-----------------------------------

Many thanks to the wonderful libraries that make this gem possible:

* [capybara](https://github.com/jnicklas/capybara)
* [selenium-webdriver](http://seleniumhq.org/docs/01_introducing_selenium.html#selenium-2-aka-selenium-webdriver)
* [chunky_png](https://github.com/wvanbergen/chunky_png) (and especially [this blog post about using chunky_png to create image diffs](http://jeffkreeftmeijer.com/2011/comparing-images-and-creating-image-diffs/?utm_source=rubyweekly&utm_medium=email) by Jeff Kreeftmeijer)


Contributors
------------
* Carol Nichols ([twitter](http://twitter.com/carols10cents), [website](http://carol-nichols.com))
* Andrew Cox ([twitter](https://twitter.com/coxandrew), [website](http://andrewcox.org/))
* Kurtis Rainbolt-Greene ([twitter](https://twitter.com/krainboltgreene)) ([website](http://kurtisrainboltgreene.name/))
* Steve Klabnik ([twitter](https://twitter.com/steveklabnik)) ([website](http://www.steveklabnik.com/))
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