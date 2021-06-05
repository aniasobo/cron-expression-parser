module Parser
  module Cron_expression
    FIELDS = ['minute', 'hour', 'day of month', 'month', 'day of week', 'command']

    def self.parse(input)
    end

    def self.generate_table
      FIELDS.map { |field| field.ljust(14) + 'data'}
    end
  end
end
