class UserPositionMetric < ActiveRecord::Base
  has_many :user_position_metric_points
  belongs_to :user
  
  def self.precalculate_distributions(articles, params)
    user_position_metric_points = UserPositionMetricPoint.where(:user_id => params[:user_id])
    user_position_metrics = UserPositionMetric.where(:id => user_position_metric_points.collect(&:user_position_metric_id).uniq)
    params[:user_position_metrics_precalcs] = {}
    user_position_metrics.each do |upm|
      params[:user_position_metrics_precalcs][upm.id] = upm.send("get_val_"+upm.name+"_"+upm.metric_type, articles, params)
    end
    return params
  end
  
  def calculate_sub_score(article, params)
    # begin
      self.send(self.name+"_"+self.metric_type, article, params)
    # rescue
      # return 0
    # end
  end

  def keywords_semantic(article, params)
    distro = {}
    article_keywords_graph = params[:user_position_metrics].select{|pm| pm.name == "keywords"}.first
    params[:user_position_metrics_precalcs][article_keywords_graph.id].each_pair{|k,v| distro[k] = v.length}
    count = distro[article.id].to_f rescue 0.0
    return count/distro.values.flatten.sort.last
  end
  
  def location_geographic(article, params)
    article_locations_graph = params[:user_position_metrics].select{|pm| pm.name == "location"}.first
    distro = {}
    params[:user_position_metrics_precalcs][article_locations_graph.id].each_pair{|k,v| distro[k] = v}
    closest = distro.values.flatten.sort.first
    furthest = distro.values.flatten.sort.last
    distance_avg = distro[article.id].sum/distro[article.id].length rescue nil
    if distance_avg
      return Math.log(closest, 10)/Math.log(distance_avg, 10)
    else
      return 0
    end
  end
  
  def get_val_keywords_semantic(articles, params)
    keywords = params[:user_position_metric_points].select{|upmp| upmp.user_position_metric_id == self.id}
    article_keywords_graph = params[:user_position_metrics].select{|pm| pm.name == "keywords"}.first
    possible_keywords = keywords.collect(&:key)
    results = {}
    PositionMetricPoint.where(:position_metric_id => article_keywords_graph.id, :key => possible_keywords, :article_id => articles.collect(&:id)).uniq.each do |pmp|
      if results[pmp.article_id]
        results[pmp.article_id] << pmp.key
      else
        results[pmp.article_id] = [pmp.key]
      end
    end
    return results
  end
  
  def get_val_location_geographic(articles, params)
    location = params[:user_position_metric_points].select{|upmp| upmp.user_id == params[:user_id] && upmp.user_position_metric_id == self.id}.first
    results = {}
    if location
      article_locations_graph = params[:position_metrics].select{|pm| pm.name == "locations"}.first
      user_location = GeoKit::LatLng.new(*location.value.split(",").collect(&:to_f)) 
      PositionMetricPoint.where(:position_metric_id => article_locations_graph.id, :article_id => articles.collect(&:id)).uniq.each do |pmp|
        if results[pmp.article_id]
          results[pmp.article_id] << user_location.distance_from(GeoKit::LatLng.new(*pmp.key.split(",").collect(&:to_f)))
        else
          results[pmp.article_id] = [user_location.distance_from(GeoKit::LatLng.new(*pmp.key.split(",").collect(&:to_f)))]
        end
      end
    end
    return results
  end
end
