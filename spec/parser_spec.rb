require 'parser'
require 'pry'

RSpec.describe Parser::CronExpression do
  describe 'Parser::CronExpression#parse' do
    it 'prints the right data' do
      body = described_class.parse('*/15 0 1,15 * 1-5 /usr/bin/find')

      expect(body).to eq(["minute        0 15 30 45",
                          "hour          0",
                          "day of month  1,15",
                          "month         *",
                          "day of week   1-5",
                          "command       /usr/bin/find"])
    end
  end

  describe 'Parser::CronExpression#process_minutes' do
    it 'handles asterisk expressions' do
      minutes = described_class.process_minutes('*/15')

      expect(minutes).to eq "0 15 30 45"
    end

    it 'handles non asterisk expressions' do
      minutes = described_class.process_minutes('15')

      expect(minutes).to eq "15"
    end
  end
end
