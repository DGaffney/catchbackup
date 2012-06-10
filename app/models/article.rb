class Article < ActiveRecord::Base
  has_many :importance_metric_points
  has_many :position_metric_points
  belongs_to :source
  
  def self.sorted_articles(params)
    @articles = self.where(:created_at => (Time.now-params[:end].to_i)..(Time.now-params[:start].to_i))
    return [@articles, {}] if @articles.empty?
    @oldest = @articles.sort{|x,y| x.created_at<=>y.created_at}.first
    params[:oldtime] = @oldest.created_at.to_time.to_i
    @newest = @articles.sort{|x,y| x.created_at<=>y.created_at}.last
    params[:newtime] = @newest.created_at.to_time.to_i
    params[:range] = params[:newtime] - params[:oldtime]
    params[:importance_metric_points] = ImportanceMetricPoint.where(:article_id => @articles.collect(&:id))
    params[:importance_metrics] = ImportanceMetric.where(:id => params[:importance_metric_points].collect(&:importance_metric_id).uniq)
    params[:user_position_metric_points] = UserPositionMetricPoint.where(:user_id => params[:user_id])
    params[:user_position_metrics] = UserPositionMetric.where(:id => params[:user_position_metric_points].collect(&:user_position_metric_id).uniq)
    params[:position_metric_points] = PositionMetricPoint.where(:article_id => @articles.collect(&:id))
    params[:position_metrics] = PositionMetric.where(:id => params[:position_metric_points].collect(&:position_metric_id).uniq)
    params = ImportanceMetric.precalculate_distributions(@articles, params)
    params = UserPositionMetric.precalculate_distributions(@articles, params)
    params[:articles] = @articles
    scores = {}
    @articles.collect{|x| scores[x.id] = x.score(params)}
    [@articles.sort{|x,y| scores[x.id]<=>scores[y.id]}.reverse, scores]
  end
  
  def importances
    importance_metric_points
  end

  def positions
    position_metric_points
  end
  
  def score(params)
    return (importance_score(params)+proximity_score(params)+time_score(params))/3
  end
  
  def importance_score(params)
    sum = 0
    count = 0.0
    params[:importance_metrics].each do |importance_metric|
      sum+=importance_metric.calculate_sub_score(self, params)
      count+=1
    end
    return (sum/count)*(params[:importance]/100.0)
  end
  
  def proximity_score(params)
    if params[:user_id] == 0
      return 0
    else
      sum = 0
      count = 0.0
      params[:user_position_metrics].each do |position_metric|
        sum+=position_metric.calculate_sub_score(self, params)
        count+=1
      end
      return (sum/count)*(params[:proximity]/100.0)
    end
  end
  
  def time_score(params)
    @actual = self.created_at.to_f
    return ((params[:range].to_f - (params[:newtime] - @actual)) / params[:range])*(params[:time_salience]/100.0)
  end
  
end

