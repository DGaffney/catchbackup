class UserPositionMetric < ActiveRecord::Base
  has_many :user_position_metric_points
  belongs_to :user
  
  def calculate_sub_score(article, user_id)
    begin
      self.send(self.name+"_"+self.metric_type, article, user_id)
    rescue
      return 0
    end
  end
  
  def keywords_semantic(article, user_id)
    keywords = UserPositionMetricPoint.where(:user_id => user_id, :user_position_metric_id => user_position_metric.id)
    article_keywords_graph = PositionMetric.find_by_name("keywords")
    article_keyword_matches = PositionMetricPoint.where(:position_metric_id => article_keywords_graph.id, :key => keywords.collect(&:key))
    article_match_counts = {}
    article_keyword_matches.each do |match|
      if article_match_counts[match.article_id]
        article_match_counts[match.article_id] << match.key
      else
        article_match_counts[match.article_id] = [match.key]
      end
    end
    count = article_match_counts[article.id].length.to_f rescue 0.0
    count/article_match_counts.values.collect(&:length).sort.last
  end
  
  def location_geographic(article, user_id)
    
  end
end
