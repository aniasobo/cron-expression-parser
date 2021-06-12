# CRON expression parser - in development

Use `Parser::CronExpression.parse(input)` to process CRON expressions

## To run specs

`> rspec`

### Lint with

`> rubocop`

## TODO

- [ ] handle all the fields processing for input `'*/15 0 1,15 * 1-5 /usr/bin/find'`
- [ ] add handling of other input formats
- [ ] add error handling
  - [ ] exception for completely incorrect inputs
  - [ ] exception for illegal 0s
