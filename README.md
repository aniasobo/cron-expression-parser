# CRON expression parser

## How to use this parser

1. Clone or download this repo
2. `> bundle`
3. Run it in command line passing your expression as a single string, like so: `> ruby lib/parser.rb '*/15 0 1,15 * 1-5 /usr/bin/find'`
4. The above command should give you the following output:

## How to run specs

`> rspec`

### Lint with

`> rubocop`

## TODO

- [x] handle all the fields processing for input `'*/15 0 1,15 * 1-5 /usr/bin/find'`
- [x] add handling of other input formats
- [ ] add error handling
  - [ ] exception for completely incorrect inputs
  - [ ] exception for illegal 0s
