include Octodown::Renderer

describe GithubMarkdown do
  subject { GithubMarkdown.new(dummy_file).to_html }

  it 'create HTML from markdown file' do
    expect(subject).to include '<h1>Hello world!</h1>'
  end

  it 'highlights the code' do
    expect(subject).to include 'highlight-ruby'
  end

  describe 'when :gfm option is set' do
    let :md_factory do
      lambda do |params|
        GithubMarkdown.new(
          dummy_file,
          opts.merge(gfm: params[:gfm])
        ).to_html
      end
    end

    context 'true' do
      it 'renders hard-wraps' do
        expect(md_factory[gfm: true]).to include '<br>'
      end
    end

    context 'false' do
      it 'does not render hard-wraps' do
        expect(md_factory[gfm: false]).to_not include '<br>'
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
