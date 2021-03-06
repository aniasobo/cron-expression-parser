module Parser
  module CronExpression
    FIELDS = ['minute', 'hour', 'day of month', 'month', 'day of week', 'command']
    MINUTES_DELIMITER = 60
    HOURS_DELIMITER = 24
    DAYS_IN_MONTH_DELIMITER = 32
    MONTHS_DELIMITER = 13
    WEEKDAYS_DELIMITER = 8
    DAYS_OF_WEEK = {mon: '1', tue: '2', wed: '3', thu: '4', fri: '5', sat: '6', sun: '7'}

    def self.parse(input)
      data = input.split

      @minutes = process_minutes(data.first)
      @hours = process_hours(data[1])
      @day_of_month = process_days(data[2])
      @months = process_months(data[3])
      @day_of_week = process_weekdays(data[4])
      @command = data[5..-1].join(' ')

      generate_table
    end

    def self.process_minutes(minutes)
      if minutes.scan(/\D/).empty?      # no non-digits
        minutes
      elsif minutes[',']
        process_comma_separated_expression(minutes)
      elsif minutes['-']
        process_range(minutes)
      elsif minutes['*']
        handle_asterisk(minutes, MINUTES_DELIMITER, starts_at_zero = true)
      else
        true                            # add error handling
      end
    end

    def self.process_hours(hours)
      if hours.scan(/\D/).empty?
        hours
      elsif hours[',']
        process_comma_separated_expression(hours)
      elsif hours['-']
        process_range(hours)
      elsif hours['*']
        handle_asterisk(hours, HOURS_DELIMITER, starts_at_zero = true)
      else
        true
      end
    end

    def self.process_days(days)
      if days.scan(/\D/).empty?
        days
      elsif days[',']
        process_comma_separated_expression(days)
      elsif days['-']
        process_range(days)
      elsif days['*']
        handle_asterisk(days, DAYS_IN_MONTH_DELIMITER)
      else
        true
      end
    end

    def self.process_months(months)
      if months.scan(/\D/).empty?
        months
      elsif months[',']
        process_comma_separated_expression(months)
      elsif months['-']
        process_range(months)
      elsif months['*']
        handle_asterisk(months, MONTHS_DELIMITER)
      else
        true
      end
    end

    def self.process_weekdays(weekdays)
      days = DAYS_OF_WEEK.keys.map(&:to_s)
      weekdays.downcase!
      days.each {|day| weekdays.gsub!(day, DAYS_OF_WEEK[day.to_sym])}

      if weekdays.scan(/\D/).empty?
        weekdays
      elsif weekdays[',']
        process_comma_separated_expression(weekdays)
      elsif weekdays['-']
        process_range(weekdays)
      elsif weekdays['*']
        handle_asterisk(weekdays, WEEKDAYS_DELIMITER)
      else
        true
      end
    end

    def self.handle_asterisk(units_of_time, delimiter, starts_at_zero = false)
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

      else
        starts_at_zero ? i = 0 : i = 1
        result = []

        for unit_of_time in i...delimiter do
          result << unit_of_time
          i += 1
        end

      end
      format_result(result)
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
