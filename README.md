# PriceTracker

code for price tracking based on api

## Api

There are two main parts to the system
1. Transactor stores and logs the transformations to the database
2. Strategy, wraps your custom modules to interact with the transactor

`lib/strategies/omega_pricing.ex` impliments the contract of strategy
for the omega api. You could extend your own by writing your own modueles
and using Strategy

Strategies a `make_request()` function that will call the api and
merge the changes into the database. By deriving from `Strategy`,
The Transactor code can be resued verbatim.

You can call `make_request` at periodic intervals to gather data
for the database. a library such as [quantum-elixir](https://github.com/c-rack/quantum-elixir)
would be perfect for this and could be mounted in a supervision tree.

I did make a few assumptions

1. http with get responses. I did add a case statement where a post handler could be added
2. The exposed method takes no option. This is to make it easier to mount it in a cron function.
3. we want to support multiple companies so I added a company code to the product model

##### Libraries used

I wasn't sure if phoenix was allowed so I built the test harness with
support for ecto and mocking http requests for httpoison myself.


* ecto
* exvcr to mock http requests for testing
* timex for time handling

### Running tests

to run the tests, simply run 
```
mix deps.get
mix test
```
