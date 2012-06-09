class Article < ActiveRecord::Base
  has_many :importance_metric_points
  has_many :position_metric_points
  belongs_to :source
  
  def self.sorted_articles(params)
    # importance_metric = ImportanceMetric.find_by_name("final_score")
    # params[:importance_metric_id] = importance_metric.id
    # highest_score = ImportanceMetricPoint.first(:conditions => {:importance_metric_id => importance_metric.id}, :order => "`key` desc")
    # params[:highest_score] = highest_score.key.to_f
    self.where(["created_at > ?", Time.now-params[:start].to_i], ["created_at < ?", Time.now-params[:end].to_i]]).sort{|x,y| x.score(params)<=>y.score(params)}.reverse
    self.where(:created_at => (Time.now-params[:end].to_i)..(Time.now-params[:start].to_i))
  end

  # def importances
  #   importance_metric_points-ImportanceMetricPoint.where(:importance_metric_id => ImportanceMetric.find_by_name("final_score"), :article_id => self.id)
  # end

  def positions
    position_metric_points
  end
  
  def score(params)
    return (importance_score(params)+proximity_score(params)+time_score(params))/3
  end
  
  def importance_score(params)
    # point = ImportanceMetricPoint.where(:importance_metric_id => params[:importance_metric_id], :article_id => self.id).first
    # if point
    #   return (point.key.to_f*params[:importance]).to_f/(params[:highest_score]*params[:importance]+0.00000000001)
    # else
      return 0
    # end
  end
  
  def proximity_score(params)
    if params[:user_id] == 0
      return 0
    else
      user = User.find(params[:user_id])
      position_metrics = UserPositionMetric.where(:metric_type => "position")
      sum = 0
      position_metrics.each do |position_metric|
        position_metric_points = UserPositionMetricPoint.where(:user_id => user.id, :user_position_metric_id => position_metric.id, :key => self.id).collect(&:value)
        sum+=position_metric_points.collect(&:to_i).sum
      end
      return sum
    end
  end
  
  def time_score(params)
    this_distance = Time.now-self.created_at
    shortest_distance = Time.now-params[:newest_article_date]
    return (shortest_distance*(params[:time_salience]/100.0))/(this_distance*(params[:time_salience]/100.0)+0.00000000001)
  end
  
end

