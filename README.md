![logo](app/assets/images/fantasy-pro-tour-logo-white.png)

MVP for an E-Sports fantasy drafter using Action Cable for live drafting.

Requirements:

* Ruby 2.3.0

* Rails 5+

* PostgreSQL

* Redis

To install:

* Clone the repo: `git clone git@github.com:davidmccoy/fantasy-drafter.git`

* Install the required gems: `bundle install`

* Create the database: `rake db:create`

* Run the database migrations: `rake db:migrate`

* Seed the database: `rake db:seed` (admin user is: u/n: admin, p/w: password)

* Start the server: `rails s`

This should leave you with a new tournament with 8 users and ready to set up a new draft.

To sync the production database to staging:

`heroku pg:copy fantasy-drafter::DATABASE_URL DATABASE_URL -a fantasy-drafter-staging`
