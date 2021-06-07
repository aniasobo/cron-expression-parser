module Parser
  module CronExpression
    FIELDS = ['minute', 'hour', 'day of month', 'month', 'day of week', 'command']

    def self.parse(input)
      data = input.split

      @minutes = process_minutes(data.first)   # "*/15"            -> "0 15 30 45"
      @hours = process_hours(data[1])          # "0"               -> "0"
      @day_of_month = process_dom(data[2])     # "1,15"            -> "1 15"
      @months = process_months(data[3])        # "*"               -> "1 2 3 4 5 6 7 8 9 10 11 12"
      @day_of_week = process_dow(data[4])      # "1-5"             -> "1 2 3 4 5"
      @command = data.last                     # "/usr/bin/find"   -> "/usr/bin/find"

      generate_table
    end

    # private

    def self.process_minutes(minutes)
      hour = 60

      if minutes.include?('*/')
        result = [0]
        value = [minutes].map { |i| i[/\d+/] }.first.to_i # "15"
        starting_value = value
        while value < hour do
          result << value
          value = value + starting_value
        end
        return result.map { |i| i.to_s }.join(' ')
      else
        return minutes
      end
    end

    def self.process_hours(hours)
      # TODO
      hours
    end

    def self.process_dom(dom)
      # TODO
      dom
    end

    def self.process_months(months)
      # TODO
      months
    end

    def self.process_dow(dow)
      # TODO
      dow
    end

    def self.generate_table
      data = [@minutes, @hours, @day_of_month, @months, @day_of_week, @command]
      FIELDS.each_with_index.map do |field, index|
        field.ljust(14) + "#{data[index]}"
      end
    end
  end
end
