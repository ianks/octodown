# frozen_string_literal: true

describe Octodown::Support::RelativeRootFilter do
  let(:_http_uri?) do
    lambda { |uri| subject.send :http_uri?, uri }
  end

  subject { Octodown::Support::RelativeRootFilter.new nil }

  # Testing private methods because Nokogirl is a black box
  it 'detects an non-HTTP/HTTPS URI correctly' do
    expect(_http_uri?['assets/test.png']).to eq false
    expect(_http_uri?['#array#bsearch-vs-array']).to eq false
  end

  it 'detects HTTP/HTTPS URI correctly' do
    expect(_http_uri?['http://foo.com/asset/test.png']).to eq true
    expect(_http_uri?['https://foo.com/aset/test.png']).to eq true
  end

  it 'renders the relative root correctly' do
    root = '/home/test'
    src = 'dummy/test.md'

    expect(subject.send(:relative_path_from_document_root, root, src)).to eq(
      '/home/test/dummy/test.md'
    )
  end
end
