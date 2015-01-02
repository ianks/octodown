:octocat: octodown
==================
[![GemVersion](https://badge.fury.io/rb/octodown.svg)](http://badge.fury.io/rb/octodown)
[![Build Status](https://travis-ci.org/ianks/octodown.svg)](https://travis-ci.org/ianks/octodown)

Ever wanted to easily preview what you markdown would look like *exactly* on
Github? Ever wanted to do that from inside of a Terminal? Well this Gem is for
you. Dead simple. Never get caught writing ugly markdown again.

![Octodown GIF](assets/octodown.gif?raw=true)

## Features:

  * Uses the same markdown parsers and CSS as Github for true duplication.
    - Yes emojis *are* included
  * Fast. `octodown` uses native parsers to ensure performance.
  * Multiple CSS styles. Choose from either:
    - `$ octodown --style atom README.md`
    - The `github.com` markdown (default)
    - The `Atom` text editor markdown
  * Properly parses `STDIN`
    - `$ cat README.md | octodown`

## Installation

  1. Install `icu4c` and `cmake`:
    * Mac: `$ brew install icu4c cmake`
    * Apt: `$ sudo apt-get install -y libicu-dev cmake`
  2. If you have a non-system Ruby (*highly recommended*):
    * `$ gem install octodown`
  3. Else:
    * `$ sudo gem install octodown`

## Usage

  1. Basic:
    * `$ octodown README.md`
  2. Markdown preview styling
    * `$ octodown --style atom README.md`
  3. *nix lovers
    * `$ echo '# Hello world!' | octodown --raw > index.html`

## Notes

  1. With no arguments given, octodown will read STDIN until EOF is reached. In
  order to work with this mode, type what you want into the input, then press
  `Ctrl-D` when finished.
  2. octodown attempts to use default OS support for opening HTML files from
  terminal. In Mac, this would be the `open` command; for Linux it is either
  `xdg-open` or `x-www-browser`. If these are not set, octodown will not
  automatically open the file in the browser. If octodown doesn't have the
  commands neccesary to open files in a browser, please consider opening a pull
  request to add support!

## Contributing

1. Fork it ( https://github.com/[my-github-username]/octodown/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
