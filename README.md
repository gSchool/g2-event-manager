g2-event-manager
================
[![Build Status](https://travis-ci.org/gSchool/g2-event-manager.svg?branch=master)](https://travis-ci.org/gSchool/g2-event-manager)

#Background

The g2 Events Manager helps you manage events.

#Important Links

1. Tracker:  https://www.pivotaltracker.com/n/projects/1079696
1. Staging: http://g2-event-manager-staging.herokuapp.com/
1. Production


#Setup

Please follow the steps below to get this site set up for local development.

1. `bundle`
1. `rake db:create`
1. `rake db:migrate`
1. `rails server`

Run the test suite with: `bundle exec rspec`

Please note that this application is using carrierwave with rmagick. Please install 'imagemagick' prior to using this app through whatever
 means you use (i.e. if you use homebrew: `brew install imagemagick`).
