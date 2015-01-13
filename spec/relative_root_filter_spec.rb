require 'tempfile'

describe Octodown::Renderer::GithubMarkdown do
  subject { Octodown::Support::RelativeRootFilter.new(nil) }

  # Testing private methods because Nokogirl is a black box
  it 'detects an non-HTTP/HTTPS URI correctly' do
    expect(subject.send(:http_uri?, 'assets/test.png')).to eq false
  end

  it 'detects HTTP/HTTPS URI correctly' do
    expect(subject.send(:http_uri?, 'http://foo.com/assets/test.png'))
      .to eq true
    expect(subject.send(:http_uri?, 'https://foo.com/assets/test.png'))
      .to eq true
  end

  it 'renders the relative root correctly' do
    root = '/home/test'
    src = 'dummy/test.md'

    expect(subject.send(:relative_path_from_document_root, root, src)).to eq(
      '/home/test/dummy/test.md'
    )
  end
end
