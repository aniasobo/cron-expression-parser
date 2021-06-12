# CRON expression parser

## How to use this parser

1. Clone or download this repo
2. `> bundle`

### Parsing expressions:

Run this program in your command line passing your expression as a single string, like so:

`> ruby lib/app.rb '*/15 0 1,15 * 1-5 /usr/bin/find'`

The above command should give you the following output:

<img width="403" alt="Screenshot 2021-06-12 at 18 54 27" src="https://user-images.githubusercontent.com/44335120/121785120-d056d900-cbaf-11eb-8b21-ec67db424aad.png">

## How to run specs

`> rspec`

### Lint with

`> rubocop`

## TODO

- [x] handle all the fields processing for input `'*/15 0 1,15 * 1-5 /usr/bin/find'`
- [x] add handling of other input formats
- [x] run the CLI from a separate file that calls the parser
- [ ] add error handling
  - [ ] exception for completely incorrect inputs
  - [ ] exception for illegal 0s
