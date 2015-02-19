include Octodown::Renderer

describe PDF do
  # wkhtmltopdf exits with status 1, making it hard to test..
  it 'raises error without wkhtmltopdf installed' do
    expect do
      Kernel.silence { PDF.new 'test', options }
    end.to raise_error
  end
end
