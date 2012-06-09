class Article < ActiveRecord::Base
  has_many :importance_metric_points
  has_many :position_metric_points
  belongs_to :source
  
  def self.sorted_articles(params)
    # importance_metric = ImportanceMetric.find_by_name("final_score")
    # params[:importance_metric_id] = importance_metric.id
    # highest_score = ImportanceMetricPoint.first(:conditions => {:importance_metric_id => importance_metric.id}, :order => "`key` desc")
    # params[:highest_score] = highest_score.key.to_f
    self.where(["created_at > ?", Time.now-params[:start].to_i], ["created_at < ?", Time.now-params[:end].to_i]])
    self.where(:created_at => (Time.now-params[:end].to_i)..(Time.now-params[:start].to_i)).sort{|x,y| x.score(params)<=>y.score(params)}.reverse
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
      sum = 0
      count = 0.0
      UserPositionMetric.joins(:user_position_metric_points).where("user_position_metric_points.user_id" => user.id).uniq.each do |position_metric|
        sum+=position_metric.calculate_sub_score(self, params[:user_id])
        count+=1
      end
      return sum/count
    end
  end
  
  def time_score(params)
    this_distance = Time.now-self.created_at
    shortest_distance = Time.now-params[:newest_article_date]
    return (shortest_distance*(params[:time_salience]/100.0))/(this_distance*(params[:time_salience]/100.0)+0.00000000001)
  end
  
end

