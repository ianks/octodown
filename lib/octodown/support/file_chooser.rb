# frozen_string_literal: true

require 'English'
require 'tty-prompt'

module Octodown
  class FileChooser
    TUI = ::TTY::Prompt.new(enable_color: true)

    EXTENSIONS = %w[markdown
                    mdown
                    mkdn
                    md
                    mkd
                    mdwn
                    mdtxt
                    mdtext
                    text
                    Rmd].freeze

    class MarkdownFileList
      class Git
        def call
          ext_args = EXTENSIONS.map { |ext| "**/*.#{ext} *.#{ext}" }.join(' ')
          `git ls-files --cached --others -z #{ext_args}`.split("\x0").uniq
        end

        def runnable?
          `git rev-parse --is-inside-work-tree`
          $CHILD_STATUS.success?
        rescue StandardError
          false
        end
      end

      class Glob
        def call
          Dir.glob "*.{#{EXTENSIONS.join(',')}}"
        end

        def runnable?
          true
        end
      end

      attr_reader :logger

      def initialize(logger)
        @logger = logger
      end

      def call
        logger.debug("File choose strategy: #{winning_strategy.class.name}")
        winning_strategy.call
      end

      def winning_strategy
        strats = [Git.new, Glob.new]
        @winning_strategy ||= strats.find(&:runnable?)
      end
    end

    attr_reader :prompt, :logger

    def initialize(logger:)
      @logger = logger
      @prompt = TUI
    end

    def call
      choices = all_markdown_files
      choice = prompt.select('Which file would you like to edit?', choices)
      File.open(choice, 'r')
    end

    def abort_no_files_found!
      prompt.error 'We could not find any markdown files in this folder.'
      puts
      prompt.error 'Try passing the file explicitly such as, i.e:'
      prompt.error '    $ octodown README.md'
      exit 1
    end

    def all_markdown_files
      choices = MarkdownFileList.new(logger).call

      abort_no_files_found! if choices.empty?

      choices.sort_by! { |c| c.split(File::SEPARATOR).length }
    end
  end
end
