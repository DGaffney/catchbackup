# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Setting.create(key: "newswire_api_key", setting_type: "nytimes", value: "2c708e7af0c925595b9d3a2132b89070:5:64461877")
PositionMetric.create(name: "keywords", metric_type: "semantic")
Source.create(title: "The New York Times", location: "New York City")
