require 'open-uri'
module Positioner
  class NYTimes
    @queue = :file_serve
    def self.perform(article_id)
      self.calculate_position_metrics(article, response)
    end

    def self.calculate_position_metrics(article, news_response)
      keywords = PositionMetric.find_by_name("keywords")
      position_metric_points = []
      if !news_response.des_facet.empty?
        news_response.des_facet.each do |keyword|
          position_metric_points << PositionMetricPoint.new(:key => keyword, :value => 1, :article_id => article.id, :position_metric_id => keywords.id)
        end
      end
      PositionMetricPoint.import(position_metric_points)
    end
  end
end