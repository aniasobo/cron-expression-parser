module Parser
  module CronExpression
    # *   -> all of
    # */x -> every x of
    # y,x -> only y and x of
    # y-z -> range y to z of

    FIELDS = ['minute', 'hour', 'day of month', 'month', 'day of week', 'command']
    MAX_MINUTES = 60
    COUNTABLE_HOURS = 24
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

    # if only digits
    # if ,
    # if -
    # if *
      # if */
      # else

    def self.process_minutes(minutes)
      if minutes.scan(/\D/).empty?      # no non-digits
        return minutes
      elsif minutes[',']
        process_comma_separated_expression(minutes)
      elsif minutes['-']
        process_range(minutes, starts_at_zero=true)
      elsif minutes['*']
        handle_asterisk_in_minutes(minutes)
      else
        true
      end
    end

    def self.handle_asterisk_in_minutes(minutes)
      if minutes['*/']
        result = [0]
        value = [minutes].map { |i| i[/\d+/] }.first.to_i # "15"
        starting_value = value
        while value < MAX_MINUTES do
          result << value
          value = value + starting_value
        end
        format_result(result)
      else
        i = 0
        result = []
        for minute in 0...MAX_MINUTES do
          result << minute
          i += 1
        end
        format_result(result)
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
