describe 'Integration' do
  it 'actually runs...' do
    begin
      pid = fork do
        octodown = File.join(__dir__, '..', 'bin', 'octodown')
        exec "TEST=1 bundle exec #{octodown} --live-reload #{dummy_path}"
      end

      req = Net::HTTP::Get.new('/')

      sleep 2
      res = Net::HTTP.start 'localhost', 8080 do |http|
        http.request(req)
      end

      body = res.body

      expect(body).to include 'You are now reading markdown. How lucky you are!'

    ensure
      Process.kill('TERM', pid)
      Process.wait pid
    end
  end

  it 'fires up a websocket' do
    begin
      pid = fork do
        octodown = File.join(__dir__, '..', 'bin', 'octodown')
        exec "TEST=1 bundle exec #{octodown} --live-reload #{dummy_path}"
      end

      req = Net::HTTP::Get.new('/')
      req['Upgrade'] = 'websocket'
      req['Connection'] = 'Upgrade'
      req['Origin'] = 'http://localhost'

      sleep 2

      res = Net::HTTP.start 'localhost', 8080 do |http|
        http.request(req)
      end

      expect(res).to be_a Net::HTTPSwitchProtocol
    ensure
      Process.kill('TERM', pid)
      Process.wait pid
    end
  end
end
