describe Octodown::Renderer::PDF do
  let(:options) { { style: 'github' } }

  # wkhtmltopdf exits with status 1, making it hard to test..
  it 'raises error without wkhtmltopdf installed' do
    expect do
      Kernel.silence do
        Octodown::Renderer::PDF.new('test', options)
      end
    end.to raise_error
  end
end
