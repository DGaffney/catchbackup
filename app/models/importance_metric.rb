class ImportanceMetric < ActiveRecord::Base
  has_many :importance_metric_points

  def self.precalculate_distributions(articles, params)
    debugger
    importance_metric_points = ImportanceMetricPoint.where(:article_id => articles[0..100].compact.collect(&:id))
    importance_metrics = ImportanceMetric.where(:id => importance_metric_points.collect(&:importance_metric_id).uniq)
    params[:importance_metrics_precalcs] = {}
    importance_metrics.each do |im|
      params[:importance_metrics_precalcs][im.id] = {}
      imps = importance_metric_points.select{|imp| imp.importance_metric_id == im.id}
      imps.each do |imp|
        begin
          params[:importance_metrics_precalcs][im.id][imp.article_id] = im.send("get_val_"+im.name, imp)
        rescue
          begin
            params[:importance_metrics_precalcs][im.id][imp.article_id] = im.send("get_val_generic", imp)
          rescue
            params[:importance_metrics_precalcs][im.id][imp.article_id] = 0.0
          end
        end
      end
    end
    return params
  end
  
  def calculate_sub_score(article, params)
    begin
      return self.send(self.name, article, params)
    rescue
      begin
        return self.send("generic", article, params)
      rescue
        return 0
      end
    end
  end

  def generic(article, params)
    results = params[:importance_metrics_precalcs][self.id]
    if results[article.id] == 0 || results[article.id].nil?
      return 0
    else
      this = Math.log(results[article.id])
      max = Math.log(results.values.sort.last)
      if this == 0 && max == 0
        return 1.0
      else
        return (this/max).abs
      end
    end
  end
  
  def get_val_generic(imp)
    return imp.key.to_f
  end
end
