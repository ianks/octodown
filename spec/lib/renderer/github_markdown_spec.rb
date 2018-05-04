include Octodown::Renderer

# rubocop:disable Metrics/BlockLength
describe GithubMarkdown do
  subject { GithubMarkdown.render dummy_file }

  it 'create HTML from markdown file' do
    expect(subject).to include '<h1>Hello world!</h1>'
  end

  it 'highlights the code' do
    expect(subject).to include 'class="highlight"'
  end

  it 'properly recognizes stdin' do
    allow(STDIN).to receive(:read).and_return 'Mic check... 1, 2, 3.'

    expect(GithubMarkdown.render(STDIN)).to include 'Mic check... 1, 2, 3.'
  end

  let :md_factory do
    lambda do |params|
      GithubMarkdown.render(
        dummy_file,
        opts.merge(gfm: params[:gfm])
      )
    end
  end

  it 'renders hard-wraps' do
    expect(md_factory[gfm: true]).to include '<br>'
  end

  describe 'local file linking' do
    it 'includes the local file from correct location' do
      dirname = "#{File.dirname dummy_path}/test.txt"
      expect(subject).to include '<a href="' + dirname + '">some-file</a>'
    end
  end
end
