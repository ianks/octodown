require 'net/http'
require 'faye/websocket'
require 'eventmachine'
require 'pty'
require 'expect'

describe 'Integration' do
  def octodown
    File.join(__dir__, '..', 'bin', 'octodown')
  end

  context 'when running with an explicit file' do
    before :all do
      @pid = fork do
        exec "bundle exec #{octodown} #{dummy_path} --quiet --no-open"
      end
      sleep 5
    end

    after :all do
      Process.kill('TERM', @pid)
      Process.wait @pid
    end

    it 'runs and serves the files over http' do
      res = Net::HTTP.start 'localhost', 8887 do |http|
        http.request(Net::HTTP::Get.new('/'))
      end
      expect(res.body).to include 'You are now reading markdown.'\
                                  ' How lucky you are!'
    end
    it 'runs and receives data from the websocket' do
      message = nil
      EM.run do
        ws = Faye::WebSocket::Client.new('ws://localhost:8887/')
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

  context 'when no file is passed' do
    it 'prompts the user to pick the file' do
      aggregator = double(prompt_was_read: true, html_was_rendered: true)

      PTY.spawn(octodown, '--raw', '--no-open') do |stdin, stdout, _pid|
        stdin.expect(/README\.md/, 5) do |_m|
          aggregator.prompt_was_read
          stdout.printf("\n")
        end

        stdin.expect(/DOCTYPE/, 5) do |result|
          aggregator.html_was_rendered(result.first)
        end
      end

      aggregate_failures do
        expect(aggregator).to have_received(:prompt_was_read)
        expect(aggregator)
          .to have_received(:html_was_rendered)
          .with(a_string_matching(/DOCTYPE/))
      end
    end
  end

  context 'when data is passed via stdin' do
    it 'prompts the user to pick the file' do
      result = `echo "# Hello world" | #{octodown} --stdin --raw`

      expect(result).to match(/DOCTYPE/)
    end
  end
end
