describe Octodown::Support::Browser do
  subject { Octodown::Support::Browser.new }

  describe 'open' do
    it 'opens file in browser' do
      expect(subject).to receive(:open).with('dummy/test.md')
      subject.open 'dummy/test.md'
    end
  end
end
