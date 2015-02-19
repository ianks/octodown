require 'octodown'

describe Octodown::Renderer::Server do
  let(:content) { File.read dummy_path }
  let(:app) { subject.app }

  subject { Octodown::Renderer::Server.new content }

  before do
    object_double(
      'ARGF',
      path: dummy_path,
      read: content,
      file: File.new(dummy_path)
    ).as_stubbed_const
  end

  it 'serves a Rack app' do
    expect(Rack::Server).to receive(:start)

    subject.present
  end

  it 'register the listener' do
    allow(Rack::Server).to receive(:start).and_return true
    expect(Octodown::Support::Services::Riposter).to receive :call

    subject.present
  end

  it 'generates HTML for each request' do
    get '/'

    expect(last_response).to be_ok
    expect(last_response.body).to include '<h1>Hello world!</h1>'
  end

  it 'regenerates HTML for each request' do
    object_double(
      'ARGF',
      path: '/dev/null',
      read: File.read('/dev/null'),
      file: File.new('/dev/null')
    ).as_stubbed_const

    get '/'

    expect(last_response.body).to_not include '<h1>Hello world!</h1>'
  end

  context 'with option :port' do
    subject do
      Octodown::Renderer::Server.new content, port: 4567
    end

    it 'serves in the specified port' do
      expect(Rack::Server).to receive(:start).with app: app, Port: 4567
      subject.present
    end
  end

  context 'with WebSocket request' do
    it 'calls the WebSocket handler' do
      allow(Faye::WebSocket).to receive(:websocket?).and_return true

      expect(Faye::WebSocket).to receive(:new)
      expect { get '/' }.to raise_exception
    end
  end
end
