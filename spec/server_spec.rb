require 'rack/test'
require 'octodown'

describe Octodown::Support::Server do
  include Rack::Test::Methods

  let(:dummy_path) { File.join(File.dirname(__FILE__), 'dummy', 'test.md') }
  let(:content) { File.read dummy_path }
  let(:server) { Octodown::Support::Server.new(content, {}, dummy_path) }
  let(:app) { server.app }

  it 'serves a Rack app' do
    expect(Rack::Server).to receive(:start)
      .with(app: app, Port: Octodown::Support::Server::DEFAULT_PORT)
    server.start
  end

  it 'generates HTML for each request' do
    get '/'

    expect(last_response).to be_ok
    expect(last_response.body).to include '<h1>Hello world!</h1>'
  end

  context 'with option :port' do
    let(:server) do
      Octodown::Support::Server.new(content, { port: 4567 }, dummy_path)
    end

    it 'serves in the specified port' do
      expect(Rack::Server).to receive(:start)
        .with(app: app, Port: 4567)
      server.start
    end
  end
end
