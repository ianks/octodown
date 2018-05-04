class FileChooser
  attr_reader :prompt

  def initialize(prompt:)
    @prompt = prompt
  end

  def choose_file
    choices = all_markdown_files
    choice = prompt.select('Which markdown file would you like to edit?', choices)
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
    extensions = %w[markdown
                    mdown
                    mkdn
                    md
                    mkd
                    mdwn
                    mdtxt
                    mdtext
                    text
                    Rmd]

    choices = Dir.glob "**/*.{#{extensions.join(',')}}"

    abort_no_files_found! if choices.empty?

    choices.sort_by! { |c| c.split(File::SEPARATOR).length }
  end
end
