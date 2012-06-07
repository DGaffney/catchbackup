# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Setting.create(key: "newswire_api_key", setting_type: "nytimes", value: "2c708e7af0c925595b9d3a2132b89070:5:64461877")
Setting.create(key: "login", setting_type: "bitly", value: "dgaff")
Setting.create(key: "api_key", setting_type: "bitly", value: "R_9ceb018f79a8cc844347246db9e123c0")
Setting.create(key: "consumer_key", setting_type: "twitter", value: "j5ZxyEiRBO4zjBmTP0b2Vg")
Setting.create(key: "consumer_secret", setting_type: "twitter", value: "BldkjXxrPn0P0UZMDVxqtseWkOAEd7hUDZACuiindlg")
PositionMetric.create(name: "keywords", metric_type: "semantic")
PositionMetric.create(name: "location", metric_type: "geographic")
PositionMetric.create(name: "authors", metric_type: "semantic")
PositionMetric.create(name: "publication", metric_type: "semantic")
PositionMetric.create(name: "sub_publication", metric_type: "semantic")
PositionMetric.create(name: "section", metric_type: "semantic")
PositionMetric.create(name: "related_urls", metric_type: "semantic")
PositionMetric.create(name: "news_type", metric_type: "semantic")
ImportanceMetric.create(name: "bitly_clicks", metric_type: "importance")
ImportanceMetric.create(name: "final_score", metric_type: "importance")
ImportanceMetric.create(name: "reddit_score", metric_type: "importance")
ImportanceMetric.create(name: "reddit_comments", metric_type: "importance")
Source.create(title: "The New York Times", location: "New York City")
UserPositionMetric.create(name: "keywords", metric_type: "semantic")
UserPositionMetric.create(name: "location", metric_type: "geographic")
UserPositionMetric.create(name: "article_score", metric_type: "analytic")
UserPositionMetric.create(name: "keyword_score", metric_type: "position")