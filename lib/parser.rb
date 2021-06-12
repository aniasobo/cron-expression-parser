module Parser
  module CronExpression
    FIELDS = ['minute', 'hour', 'day of month', 'month', 'day of week', 'command']
    MAX_MINUTES = 60
    MAX_HOURS = 24
    DAYS_IN_MONTH_DELIMITER = 32
    COUNTABLE_MONTHS = 12
    COUNTABLE_DAYS_IN_WEEK = 7

    def self.parse(input)
      data = input.split

      @minutes = process_minutes(data.first)
      @hours = process_hours(data[1])
      @day_of_month = process_days(data[2])
      @months = process_months(data[3])
      @day_of_week = process_dow(data[4])
      @command = data.last

      generate_table
    end

    def self.process_minutes(minutes)
      if minutes.scan(/\D/).empty?      # no non-digits
        return minutes
      elsif minutes[',']
        process_comma_separated_expression(minutes)
      elsif minutes['-']
        process_range(minutes)
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
        process_range(hours)
      elsif hours['*']
        handle_asterisk(hours, MAX_HOURS, starts_at_zero=true)
      else
        true                          # exceptions TBA
      end
    end

    def self.process_days(days)
      if days.scan(/\D/).empty?      # no non-digits
        return days
      elsif days[',']
        process_comma_separated_expression(days)
      elsif days['-']
        process_range(days)
      elsif days['*']
        handle_asterisk(days, DAYS_IN_MONTH_DELIMITER)
      else
        true                          # exceptions TBA
      end
    end

    def self.process_months(months)
      # TODO
      months
    end

    def self.process_dow(dow)
      # TODO
      dow
    end

    def self.handle_asterisk(units_of_time, delimiter, starts_at_zero=false)
      if units_of_time['*/']
        starts_at_zero ? margin = 0 : margin = 1
        starts_at_zero ? result = [0] : result = [1]

        value = [units_of_time].map { |i| i[/\d+/] }.first.to_i   # grab the numerics
        multiplier = value                                        # store the multiplier
        value += margin                                           # set starting value

        while value < delimiter do
          result << value
          value += multiplier
        end

        format_result(result)
      else
        starts_at_zero ? i = 0 : i = 1
        result = []

        for unit_of_time in i...delimiter do
          result << unit_of_time
          i += 1
        end

        format_result(result)
      end
    end

    def self.process_comma_separated_expression(expression)
      expression.split(',').join(' ')
    end

    def self.process_range(range)
      start_value = range.split('-').first.to_i
      delimiter = range.split('-').last.to_i
      result = []

      for unit in start_value..delimiter do
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
