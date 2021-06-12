require_relative 'parser'

cl_input = ARGV[0]
puts Parser::CronExpression.parse(cl_input)
