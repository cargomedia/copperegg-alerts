# Copperegg::Alerts [![Build Status](https://travis-ci.org/cargomedia/copperegg-alerts.png)](https://travis-ci.org/cargomedia/copperegg-alerts)

Minimalistic API client to manipulate [Copperegg's alert schedules](http://dev.copperegg.com/alerts/schedules.html) aka Maintenance Mode

## Installation

Add this line to your application's Gemfile:

    gem 'copperegg-alerts'

## Usage

    require 'copperegg'

    # Set up client
    
    Copperegg::Client.instance.auth_setup(API_KEY)
    alerts = Copperegg::Alerts.new

    # Create a new alert schedule (maintenance mode)
    # 
    # Arguments:
    # title - A name for the alert schedule
    # [<arg1>[..<argN>] - Any argument from 'The Alert Schedule Hash' 
    # see http://dev.copperegg.com/alerts/schedules.html
    
    alerts.create_schedule('spec_test', 
      'match' => {'tag' => ['foo', 'foo-bar']}, 
      'state' => 'enabled', 
      'duration' => 7, 
      'start_time' => '2014-09-14T10:21:40Z'
    )
