# CRON expression parser

## How to use this parser

1. Clone or download this repo
2. `> bundle`

### Parsing expressions:

Run this program in your command line passing your expression as a single string, like so:

`> ruby lib/app.rb '*/15 0 1,15 * 1-5 /usr/bin/find'`

The above command should give you the following output:

<img width="382" alt="Screenshot 2021-06-12 at 19 07 32" src="https://user-images.githubusercontent.com/44335120/121785399-7fe07b00-cbb1-11eb-88e8-5a77f1ac3b60.png">

## How to run specs

`> rspec`

<img width="501" alt="Screenshot 2021-06-12 at 19 07 23" src="https://user-images.githubusercontent.com/44335120/121785403-82db6b80-cbb1-11eb-95d0-b13621238516.png">


### Lint with

`> rubocop`

## TODO

- [x] handle all the fields processing for input `'*/15 0 1,15 * 1-5 /usr/bin/find'`
- [x] add handling of other input formats
- [x] run the CLI from a separate file that calls the parser
- [ ] add error handling
  - [ ] exception for completely incorrect inputs
  - [ ] exception for illegal 0s
