require 'open-uri'
module UserPositioner
  class Twitter
    @queue = :file_serve
    #this is a very taxing way to do this calculation, as it requires users*articles matrix calculations...
    def self.perform(user_id)
      @user_position_metric_points = []
      user = User.find(user_id)
      Twitter.configure do |config|
        config.consumer_key = Setting.find_by_key("consumer_key").actual_value
        config.consumer_secret = Setting.find_by_key("consumer_secret").actual_value
        config.oauth_token = user.oauth_token
        config.oauth_token_secret = user.oauth_token_secret
      end
      self.catalog_tweets(user)
      self.keyword_score(user)
      UserPositionMetricPoint.import(@user_position_metric_points)
    end
    
    def self.catalog_tweets(user)
      lat_lon = [nil,nil]
      user_timeline = Twitter.user_timeline(:include_entities => true)
      user_timeline.each do |tweet|
        lat_lon = self.derive_lat_lon(tweet) if lat_lon != [nil,nil]
      end
      words = user_timeline.collect{|x| x.text.split(/\b/).collect{|y| y.gsub(/\W/, "").downcase}}.flatten.uniq
      position_metric = PositionMetric.find_by_name("keywords")
      user_position_metric = UserPositionMetric.find_by_name("keywords")
      location_metric = UserPositionMetric.find_by_name("location")
      user_position_metric_points = []
      position_metric.position_metric_points.where(:key => words).each do |pmp|
        @user_position_metric_points << UserPositionMetricPoint.new(:key => pmp.key, :value => pmp.value, :user_position_metric_id => user_position_metric.id, :user_id => user.id)
      end
      if lat_lon != [nil,nil]
        @user_position_metric_points << UserPositionMetricPoint.new(:key => "last_known_position", :value => "#{lat_lon.join(",")}", :user_position_metric_id => location_metric.id, :user_id => user.id)
      end
    end
    
    def self.keyword_score(user)
      position_metric = PositionMetric.find_by_name("keywords")
      keywords = UserPositionMetric.find_by_name("keywords")
      keywords_score = UserPositionMetric.find_by_name("keyword_score")
      tags = keywords.user_position_metric_points.where(:user_id => user.id)
      tag_scores = {}
      tags.each do |tag|
        Article.where(:id => PositionMetricPoint.where(:position_metric_id => position_metric.id, :key => tag.key).collect(&:article_id)).each do |article|
          if tag_scores[article.id]
            tag_scores[article.id] << tag.key
          else
            tag_scores[article.id] = [tag.key]
          end
        end
      end
      tag_scores.each_pair do |article_id, tags|
        @user_position_metric_points << UserPositionMetricPoint.new(:key => article_id, :value => tags.length, :user_position_metric_id => keywords_score.id, :user_id => user.id)        
      end
    end
    
    def self.derive_lat_lon(json)
      lat = nil
      lon = nil
      lon = json[:geo]&&json[:geo][:coordinates]&&json[:geo][:coordinates].class==Array&&json[:geo][:coordinates].length==2&&json[:geo][:coordinates].last ||
      json[:place]&&json[:place][:bounding_box]&&json[:place][:bounding_box][:coordinates]&&json[:place][:bounding_box][:coordinates].centroid.first ||
      json[:coordinates]&&json[:coordinates][:coordinates].first ||
      nil
      lat = json[:geo]&&json[:geo][:coordinates]&&json[:geo][:coordinates].class==Array&&json[:geo][:coordinates].length==2&&json[:geo][:coordinates].first ||
      json[:place]&&json[:place][:bounding_box]&&json[:place][:bounding_box][:coordinates]&&json[:place][:bounding_box][:coordinates].centroid.last ||
      json[:coordinates]&&json[:coordinates][:coordinates].last ||
      nil
      return lat, lon
    end

  end
end
