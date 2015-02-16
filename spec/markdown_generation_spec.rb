require 'tempfile'

describe Octodown::Renderer::GithubMarkdown do
  let(:dummy_path) { File.join(File.dirname(__FILE__), 'dummy', 'test.md') }
  let(:dummy_file) { File.new dummy_path }

  let(:html) do
    Octodown::Renderer::GithubMarkdown.new(dummy_file).to_html
  end

  it 'create HTML from markdown file' do
    expect(html).to include '<h1>Hello world!</h1>'
    expect(html).to include(
      '<p>You are now reading markdown. How lucky you are!</p>'
    )
  end

  it 'highlights the code' do
    expect(html).to include 'highlight-ruby'
  end

  describe 'when :gfm option is set' do
    context 'true' do
      it 'renders hard-wraps' do
        options = { :gfm => true }
        doc = Octodown::Renderer::GithubMarkdown.new(dummy_file, options)
        expect(doc.to_html).to include '<br>'
      end
    end

    context 'false' do
      it 'does not render hard-wraps' do
        options = { :gfm => false }
        doc = Octodown::Renderer::GithubMarkdown.new(dummy_file, options)
        expect(doc.to_html).to_not include '<br>'
      end
    end
  end

  describe 'local file linking' do
    it 'includes the local file from correct location' do
      dirname = "#{File.dirname dummy_path}/test.txt"
      expect(html).to include '<a href="' + dirname + '">some-file</a>'
    end
  end
end
