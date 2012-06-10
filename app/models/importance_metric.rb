class ImportanceMetric < ActiveRecord::Base
  has_many :importance_metric_points

  def self.precalculate_distributions(articles, params)
    importance_metric_points = ImportanceMetricPoint.where(:article_id => articles.collect(&:id))
    importance_metrics = ImportanceMetric.where(:id => importance_metric_points.collect(&:importance_metric_id).uniq)
    params[:importance_metrics_precalcs] = {}
    importance_metrics.each do |im|
      params[:importance_metrics_precalcs][im.id] = {}
      imps = importance_metric_points.select{|imp| imp.importance_metric_id == im.id}
      imps.each do |imp|
        params[:importance_metrics_precalcs][im.id][imp.article_id] = im.send("get_val_"+im.name, imp)
      end
    end
    return params
  end
  
  def calculate_sub_score(article, params)
    begin
      self.send(self.name, article, params)
    rescue
      return 0
    end
  end
  
  def bitly_clicks(article, params)
    results = params[:importance_metrics_precalcs][self.id]
    if results[article.id] == 0
      return 0
    else
      return (Math.log(results[article.id])/Math.log(results.values.sort.last)).abs
    end
  end
  
  def get_val_bitly_clicks(imp)
    return imp.key.to_f
  end
end
