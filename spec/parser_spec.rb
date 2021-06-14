require 'parser'
require 'pry'

RSpec.describe Parser::CronExpression do
  describe 'Parser::CronExpression#parse' do
    it 'prints the right data' do
      body = described_class.parse('*/15 0 1,15 * 1-5 /usr/bin/find')

      expect(body).to eq(["minute        0 15 30 45",
                          "hour          0",
                          "day of month  1 15",
                          "month         1 2 3 4 5 6 7 8 9 10 11 12",
                          "day of week   1 2 3 4 5",
                          "command       /usr/bin/find"])
    end

    #
    it 'prints the right data with excess data' do
      body = described_class.parse('*/10 1-3 1,15 * 1aaa-4aaa /usr/bin/find all')

      expect(body).to eq(["minute        0 10 20 30 40 50",
                          "hour          1 2 3",
                          "day of month  1 15",
                          "month         1 2 3 4 5 6 7 8 9 10 11 12",
                          "day of week   1 2 3 4",
                          "command       /usr/bin/find all"])
    end

    it 'prints the right data with spelled out weekday data' do
      body = described_class.parse('*/10 1-3 1,15 * MON-THU /usr/bin/find all')

      expect(body).to eq(["minute        0 10 20 30 40 50",
                          "hour          1 2 3",
                          "day of month  1 15",
                          "month         1 2 3 4 5 6 7 8 9 10 11 12",
                          "day of week   1 2 3 4",
                          "command       /usr/bin/find all"])
    end

  end

  describe 'Parser::CronExpression#process_minutes' do
    it 'handles single digit expression' do
      minutes = described_class.process_minutes('0')

      expect(minutes).to eq "0"
    end

    it 'handles comma separated expression' do
      minutes = described_class.process_minutes('1,15')

      expect(minutes).to eq "1 15"
    end

    it 'handles expression that is a range starting from zero' do
      minutes = described_class.process_minutes('0-5')

      expect(minutes).to eq "0 1 2 3 4 5"
    end

    it 'handles expression that is a range that does not start at zero' do
      minutes = described_class.process_minutes('23-31')

      expect(minutes).to eq "23 24 25 26 27 28 29 30 31"
    end

    it 'handles asterisk' do
      minutes = described_class.process_minutes('*')
      all_minutes = "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59"

      expect(minutes).to eq all_minutes
    end

    it 'handles asterisk range' do
      minutes = described_class.process_minutes('*/15')

      expect(minutes).to eq "0 15 30 45"
    end
  end

  describe 'Parser::CronExpression#process_hours' do
    it 'handles single digit expression' do
      hours = described_class.process_hours('0')

      expect(hours).to eq "0"
    end

    it 'handles comma separated expression' do
      hours = described_class.process_hours('1,22')

      expect(hours).to eq "1 22"
    end

    it 'handles range' do
      hours = described_class.process_hours('0-7')

      expect(hours).to eq "0 1 2 3 4 5 6 7"
    end

    it 'handles asterisk' do
      hours = described_class.process_hours('*')
      all_hours = "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23"

      expect(hours).to eq all_hours
    end

    it 'handles asterisk range' do
      hours = described_class.process_hours('*/5')

      expect(hours).to eq "0 5 10 15 20"
    end
  end

  describe 'Parser::CronExpression#process_days' do
    it 'handles single digit expression' do
      days = described_class.process_days('1')

      expect(days).to eq "1"
    end

    it 'handles comma separated expression' do
      days = described_class.process_days('1,30')

      expect(days).to eq "1 30"
    end

    it 'handles range that starts at one' do
      days = described_class.process_days('1-7')

      expect(days).to eq "1 2 3 4 5 6 7"
    end

    it 'handles range that starts at five' do
      days = described_class.process_days('5-7')

      expect(days).to eq "5 6 7"
    end

    it 'handles asterisk' do
      days = described_class.process_days('*')
      all_days = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"

      expect(days).to eq all_days
    end

    it 'handles asterisk range' do
      # not sure if correct
      days = described_class.process_days('*/5')

      expect(days).to eq "1 6 11 16 21 26 31"
    end
  end

  describe 'Parser::CronExpression#process_months' do
    it 'handles single digit expression' do
      months = described_class.process_months('1')

      expect(months).to eq "1"
    end

    it 'handles comma separated expression' do
      months = described_class.process_months('1,3')

      expect(months).to eq "1 3"
    end

    it 'handles range' do
      months = described_class.process_months('1-3')

      expect(months).to eq "1 2 3"
    end

    it 'handles asterisk' do
      months = described_class.process_months('*')
      all_months = "1 2 3 4 5 6 7 8 9 10 11 12"

      expect(months).to eq all_months
    end

    it 'handles asterisk range' do
      months = described_class.process_months('*/3')

      expect(months).to eq "1 4 7 10"
    end
  end

  describe 'Parser::CronExpression#process_weekdays' do
    it 'handles single digit expression' do
      weekdays = described_class.process_weekdays('1')

      expect(weekdays).to eq "1"
    end

    it 'handles comma separated expression' do
      weekdays = described_class.process_weekdays('1,7')

      expect(weekdays).to eq "1 7"
    end

    it 'handles range' do
      weekdays = described_class.process_weekdays('1-5')
      # binding.pry

      expect(weekdays).to eq "1 2 3 4 5"
    end

    it 'handles asterisk' do
      weekdays = described_class.process_weekdays('*')

      expect(weekdays).to eq "1 2 3 4 5 6 7"
    end

    it 'handles asterisk range' do
      weekdays = described_class.process_weekdays('*/2')

      expect(weekdays).to eq "1 3 5 7"
    end
  end
end
