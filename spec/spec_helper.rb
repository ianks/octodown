$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'octodown'
require 'rack/test'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  config.include Rack::Test::Methods

  Kernel.srand config.seed

  def dummy_path
    File.join(__dir__, 'support', 'test.md')
  end

  def dummy_file
    File.new dummy_path
  end

  def assets_dir(*args)
    File.join Octodown.root, 'assets', args
  end

  def opts
    {
      gfm: false,
      port: 8080,
      presenter: :html,
      style: :github
    }
  end
end
