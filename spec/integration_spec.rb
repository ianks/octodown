require 'net/http'
require 'faye/websocket'
require 'eventmachine'

describe 'Integration' do
  before :all do
    @pid = fork do
      octodown = File.join(__dir__, '..', 'bin', 'octodown')
      exec "TEST=1 bundle exec #{octodown} --live-reload #{dummy_path}"
    end
    sleep 5
  end

  after :all do
    Process.kill('TERM', @pid)
    Process.wait @pid
  end

  it 'runs and serves the files over http' do
    res = Net::HTTP.start 'localhost', 8080 do |http|
      http.request(Net::HTTP::Get.new('/'))
    end
    expect(res.body).to include 'You are now reading markdown.'\
                                ' How lucky you are!'
  end

  it 'runs and receives data from the websocket' do
    message = nil
    EM.run do
      ws = Faye::WebSocket::Client.new('ws://localhost:8080/')
      ws.add_event_listener('message', lambda { |e| message = e.data })

      start = Time.now
      timer = EM.add_periodic_timer 0.1 do
        if message || Time.now.to_i - start.to_i > 5
          timer.cancel
          EM.stop_event_loop
        end
      end
    end
    expect(message).to include('You are now reading markdown.'\
                               ' How lucky you are!')
  end
end
