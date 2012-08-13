require 'open-uri'
module UserPositioner
  class Twit
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
      self.calculate_lat_lon(user)
      self.pull_words(user)
      UserPositionMetricPoint.import(@user_position_metric_points)
    end
    
    def self.calculate_lat_lon(user)
      lat_lon = [nil,nil]
      Twitter.user_timeline(:include_entities => true, :count => 200).each do |tweet|
        lat_lon = self.derive_lat_lon(tweet) if lat_lon != [nil,nil]
      end
      geo = Geokit::Geocoders::GoogleGeocoder3.do_geocode(user.location)
      self.pull_words(user)
      lat_lon = [geo.lat, geo.lng] if lat_lon == [nil,nil]
      location_metric = UserPositionMetric.find_by_name("location")
      if lat_lon != [nil,nil]
        @user_position_metric_points << UserPositionMetricPoint.new(:key => "last_known_position", :value => "#{lat_lon.join(",")}", :user_position_metric_id => location_metric.id, :user_id => user.id)
      end
    end
    
    def self.pull_words(user)
      user_timeline = Twitter.user_timeline(:include_entities => true, :count => 200)
      max_id = user_timeline.last.id
      text_bundle = []
      while !user_timeline.empty? && max_id
        text_bundle |= user_timeline.collect{|x| x.text.split(/\b/).collect{|y| y.gsub(/\W/, "").downcase}}.flatten.uniq
        user_timeline = Twitter.user_timeline(:include_entities => true, :count => 200, :max_id => max_id-1)
        max_id = user_timeline.last.id rescue nil
      end
      position_metric = PositionMetric.find_by_name("keywords")
      user_position_metric = UserPositionMetric.find_by_name("keywords")
      user_position_metric_points = []
      position_metric.position_metric_points.where(:key => text_bundle).each do |pmp|
        @user_position_metric_points << UserPositionMetricPoint.new(:key => pmp.key, :value => pmp.value, :user_position_metric_id => user_position_metric.id, :user_id => user.id)
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
