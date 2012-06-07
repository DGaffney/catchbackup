require 'bitly'
module Importancer
  class NYTimes
    @queue = :file_serve
    def self.perform(article)
      @importance_metric_points = []
      # self.bitly_clicks(Hashie::Mash[article])
      self.reddit_posts(Hashie::Mash[article])
      ImportanceMetricPoint.import(@importance_metric_points)
      @importance_metric_points = []
      self.importance_score(Hashie::Mash[article])
      ImportanceMetricPoint.import(@importance_metric_points)
    end

    def self.bitly_clicks(article)
      Bitly.use_api_version_3
      clicks_graph = ImportanceMetric.find_by_name("bitly_clicks")
      client = Bitly.new(Setting.find_by_setting_type_and_key("bitly", "login").actual_value, Setting.find_by_setting_type_and_key("bitly", "api_key").actual_value)
      clicks = client.clicks(client.lookup(article.url).short_url).global_clicks
      @importance_metric_points << ImportanceMetricPoint.new(:key => clicks, :value => 1, :article_id => article.id, :importance_metric_id => clicks_graph.id)
      sleep(2)
    end

    def self.reddit_posts(article)
      results = JSON.parse(open("http://www.reddit.com/search.json?q=#{article.title.gsub(" ", "+")}").read)["data"]["children"] rescue nil
      score = 0
      comments = 0
      score_graph = ImportanceMetric.find_by_name("reddit_score")
      comments_graph = ImportanceMetric.find_by_name("reddit_comments")
      if results
        results.each do |result|
          if result["data"]["url"] == article.url || result["data"]["title"].gsub(/\W/, "").downcase == article.title.gsub(/\W/, "").downcase
            comments+=result["data"]["num_comments"]
            score+=result["data"]["score"]
          end
        end
      end
      @importance_metric_points << ImportanceMetricPoint.new(:key => score, :value => 1, :article_id => article.id, :importance_metric_id => score_graph.id)
      @importance_metric_points << ImportanceMetricPoint.new(:key => comments, :value => 1, :article_id => article.id, :importance_metric_id => comments_graph.id)
    end
    
    def self.reverse_percentile(estimated_spread, value=0.0)
      index_value = nil
      estimated_spread.collect(&:to_f).sort.each do |val|
        index_value = val;break if value <= val
      end
      return (estimated_spread.index(index_value)/estimated_spread.length.to_f)
    end
  	
    def self.importance_score(article)
      final_score_graph = ImportanceMetric.find_by_name("final_score")
      ImportanceMetricPoint.where(:article_id => article.id, :importance_metric_id => final_score_graph.id).collect(&:destroy)
      final_score = 0
      points = ImportanceMetricPoint.all(:conditions => {:article_id => article.id})
      if !points.empty?
        points.each do |p|
          estimated_spread = ImportanceMetricPoint.all(:conditions => {:importance_metric_id => p.importance_metric_id}, :limit => 100, :order => "random()").collect(&:key).collect(&:to_i).sort
          final_score+=self.reverse_percentile(estimated_spread, p.key.to_i)
        end
        @importance_metric_points << ImportanceMetricPoint.new(:key => final_score/points.length, :value => 1, :article_id => article.id, :importance_metric_id => final_score_graph.id)
      else
        @importance_metric_points << ImportanceMetricPoint.new(:key => 0, :value => 1, :article_id => article.id, :importance_metric_id => final_score_graph.id)
      end
    end
  end
end