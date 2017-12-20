# Electricity consumption

### Instalation & Run

The only required dependency is [redis](https://redis.io), so it has to be installed - it is used to cache responses from consumption data server.

To launch API server simply clone this repository and run `bundle install` and then `rails s`. To launch specs `bundle exec rspec`. 
There is also endpoint for documentation (created with great [rswag gem](https://github.com/domaindrivendev/rswag)). To generate swagger docs use `rake rswag:specs:swaggerize`, after this docs will be available under `/api-docs` endpoint, so with default settings it will be http://localhost:3000/api-docs . 

You can get example JS client here: https://github.com/jpietrzyk/kwh-client

### ToDo

- [ ] Add ability to save and load reports to/from db
- [ ] Add cache invalidation to redis config