require 'tempfile'

describe Octodown::Renderer::HTML do
  let(:dummy_path) { File.join(File.dirname(__FILE__), 'dummy', 'test.md') }
  let(:html) { Octodown::Renderer::GithubMarkdown.new(dummy_path).to_html }
  subject { Octodown::Renderer::HTML.new(html).render }

  before { allow(Octodown).to receive(:root) { '.' } }

  it 'includes HTML from markdown rendering phase' do
    expect(subject).to include '<h1>Hello world!</h1>'
    expect(subject).to include '<p>You are now reading markdown. How lucky you are!</p>'
    expect(subject).to include 'highlight-ruby'
  end

  it 'sets the title' do
    expect(subject).to include '<title>Octodown Preview</title>'
  end

  it 'injects Github CSS' do
    css = File.read(File.join(Octodown.root, 'assets', 'github.css'))
    expect(subject).to include css
  end
end
