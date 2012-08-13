require 'bitly'
module Importancer
  class Clicks
    @queue = :file_serve
    def self.perform(article)
      @importance_metric_points = []
      # self.bitly_clicks(Hashie::Mash[article])
      self.shared_count_clicks(Hashie::Mash[article])
      ImportanceMetricPoint.import(@importance_metric_points)
    end

    def self.bitly_clicks(article)
      Bitly.use_api_version_3
      clicks_graph = ImportanceMetric.find_by_name("bitly_clicks")
      client = Bitly.new(Setting.find_by_setting_type_and_key("bitly", "login").actual_value, Setting.find_by_setting_type_and_key("bitly", "api_key").actual_value)
      clicks = client.clicks(client.lookup(article.url).short_url).global_clicks rescue nil
      if clicks && clicks != 0
        @importance_metric_points << ImportanceMetricPoint.new(:key => clicks, :value => 1, :article_id => article.id, :importance_metric_id => clicks_graph.id)
      end
      sleep(2)
    end

    def self.shared_count_clicks(article)
      require 'open-uri'
      url = CGI.escape(article.url)
      api_url = "http://api.sharedcount.com/?url=#{url}"
      results = JSON.parse(open(api_url).read) rescue nil
      if results
        results.each_pair do |type, value|
          if value.class == Fixnum
            if value != 0
              graph = ImportanceMetric.find_by_name(type.underscore)
              @importance_metric_points << ImportanceMetricPoint.new(:key => value, :value => 1, :article_id => article.id, :importance_metric_id => graph.id)
            end
          elsif value.class == Hash
            value.each_pair do |sub_type,count|
              if count != 0
                graph = ImportanceMetric.find_by_name(type.underscore+"_"+sub_type)
                @importance_metric_points << ImportanceMetricPoint.new(:key => count, :value => 1, :article_id => article.id, :importance_metric_id => graph.id)
              end
            end
          end
        end
      end
    end

    def self.reverse_percentile(estimated_spread, value=0.0)
      index_value = nil
      estimated_spread.collect(&:to_f).sort.each do |val|
        index_value = val;break if value <= val
      end
      return (estimated_spread.index(index_value)/estimated_spread.length.to_f)
    end
  	
  end
end