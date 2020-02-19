# :octocat: octodown

[![GemVersion](https://badge.fury.io/rb/octodown.svg)](http://badge.fury.io/rb/octodown)
![Build Status](https://github.com/ianks/octodown/workflows/ci/badge.svg)

Ever wanted to easily preview what your markdown would look like _exactly_ on
Github? Ever wanted to do that from inside of a Terminal?

Octodown uses the same parsers and CSS that Github uses for their markdown
rendering. Github markdown styling looks beautiful, so it is Octodown's
primary goal to reproduce it as faithfully as possible.

![Octodown GIF](assets/octodown.gif?raw=true)

---

## Features

- :new: Edit your markdown like a boss with LiveReload.

  - `octodown README.md`

- Uses the same markdown parsers and CSS as Github for true duplication.

  - Yes emojis _are_ included. :smiling_imp:

- Fast. `octodown` uses native parsers to ensure performance.
- Multiple CSS styles.

  - `octodown --style atom README.md`
  - The `github` markdown (default)
  - The `atom` text editor markdown

- Properly parses `STDIN`.
  - `cat README.md | octodown --stdin`

## Installation

_Requirements_: Ruby >= 2.0

1. Install `icu4c` and `cmake`:

- Mac: `brew install icu4c cmake pkg-config`
- Apt: `sudo apt-get install -y libicu-dev cmake pkg-config ruby-dev`

1. Install octodown:

- If you have a non-system Ruby (_highly recommended_): `gem install octodown`
- Else: `sudo gem install octodown`

## Usage in VIM (_optional_):

- Use [asyncrun.vim](https://github.com/skywind3000/asyncrun.vim):

  ```viml
  " Plug 'skywind3000/asyncrun.vim' in your vimrc or init.nvim

  :AsyncRun octodown %

  " or, run whenever a mardown document is opened

  autocmd FileType markdown :AsyncRun octodown %
  ```

- Use [Dispatch](https://github.com/tpope/vim-dispatch) and add this to
  your ~/.vimrc:

  ```viml
  " Use octodown as default build command for Markdown files
  autocmd FileType markdown let b:dispatch = 'octodown %'
  ```

- Caveat: make sure you follow the directions on the Dispatch README.md and
  make sure that the correct version of Ruby (the one which as Octodown
  install as a Gem), is used.

## Usage

1. Keeping it simple (choose your files from a menu):

- `octodown`

1. Markdown preview styling:

- `octodown --style atom README.md`

1. Unix lovers:

- `echo '# Hello world!' | octodown --raw --stdin > index.html`

## Notes

1. With `--stdin`, octodown will read `STDIN` until `EOF` is reached.

- In order to work with this mode, type what you want into the input, then press
  `Ctrl-D` when finished.

## Contributing

1. Fork it ( https://github.com/ianks/octodown/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Run the test suite (`bundle exec rake`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
