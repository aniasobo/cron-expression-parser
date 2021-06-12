module Parser
  module CronExpression
    FIELDS = ['minute', 'hour', 'day of month', 'month', 'day of week', 'command']
    MAX_MINUTES = 60
    MAX_HOURS = 24
    MAX_DAYS_IN_MONTH = 31
    COUNTABLE_MONTHS = 12
    COUNTABLE_DAYS_IN_WEEK = 7

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

    def self.process_minutes(minutes)
      if minutes.scan(/\D/).empty?      # no non-digits
        return minutes
      elsif minutes[',']
        process_comma_separated_expression(minutes)
      elsif minutes['-']
        process_range(minutes, starts_at_zero=true)
      elsif minutes['*']
        handle_asterisk(minutes, MAX_MINUTES, starts_at_zero=true)
      else
        true                            # add error handling
      end
    end

    # if only digits
    # if ,
    # if -
    # if *
      # if */
      # else

    def self.process_hours(hours)
      if hours.scan(/\D/).empty?      # no non-digits
        return hours
      elsif hours[',']
        process_comma_separated_expression(hours)
      elsif hours['-']
        process_range(hours, starts_at_zero=true)
      elsif hours['*']
        handle_asterisk(hours, MAX_HOURS, starts_at_zero=true)
      else
        true                          # add exceptions
      end
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

    def self.handle_asterisk(units_of_time, limiter, starts_at_zero=false)
      if units_of_time['*/']
        starts_at_zero ? result = [0] : result = []
        value = [units_of_time].map { |i| i[/\d+/] }.first.to_i
        starting_value = value
        while value < limiter do
          result << value
          value = value + starting_value
        end
        format_result(result)
      else
        starts_at_zero ? i = 0 : i = 1
        result = []
        for unit_of_time in 0...limiter do
          result << unit_of_time
          i += 1
        end
        format_result(result)
      end
    end

    def self.process_comma_separated_expression(expression)
      expression.split(',').join(' ')
    end

    def self.process_range(range, starts_at_zero=false)
      starts_at_zero ? result = [0] : result = []
      limiter = range.split('-').last.to_i
      for unit in 1..limiter do
        result << unit
      end
      format_result(result)
    end

    def self.format_result(result)
      result.map { |i| i.to_s }.join(' ')
    end

    def self.generate_table
      data = [@minutes, @hours, @day_of_month, @months, @day_of_week, @command]
      FIELDS.each_with_index.map do |field, index|
        field.ljust(14) + "#{data[index]}"
      end
    end
  end
end
