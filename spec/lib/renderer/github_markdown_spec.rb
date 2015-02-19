require 'tempfile'

describe Octodown::Renderer::GithubMarkdown do
  subject do
    Octodown::Renderer::GithubMarkdown.new(dummy_file).to_html
  end

  it 'create HTML from markdown file' do
    expect(subject).to include '<h1>Hello world!</h1>'
    expect(subject).to include(
      '<p>You are now reading markdown. How lucky you are!</p>'
    )
  end

  it 'highlights the code' do
    expect(subject).to include 'highlight-ruby'
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
      expect(subject).to include '<a href="' + dirname + '">some-file</a>'
    end
  end
end
