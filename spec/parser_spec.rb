require 'parser'
require 'pry'

RSpec.describe Parser::Cron_expression do
  describe 'Parser::Cron_expression#parse' do
  end

  describe 'Parser::Cron_expression#generate_table' do
    it 'prints the columns with correct spacing' do
      body = described_class.generate_table

      # puts body
      expect(body).to eq(["minute        data",
                          "hour          data",
                          "day of month  data",
                          "month         data",
                          "day of week   data",
                          "command       data"])
    end
  end
end
