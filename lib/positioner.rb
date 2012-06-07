require 'open-uri'
module Positioner
  class NYTimes
    @queue = :file_serve
    def self.perform(article, response)
      @position_metric_points = []
      self.tags(Hashie::Mash[article], Hashie::Mash[response])
      self.authors(Hashie::Mash[article], Hashie::Mash[response])
      self.publication(Hashie::Mash[article], Hashie::Mash[response])
      self.sub_publication(Hashie::Mash[article], Hashie::Mash[response])
      self.news_type(Hashie::Mash[article], Hashie::Mash[response])
      self.section(Hashie::Mash[article], Hashie::Mash[response])
      self.related_urls(Hashie::Mash[article], Hashie::Mash[response])
      PositionMetricPoint.import(@position_metric_points)
    end

    def self.tags(article, news_response)
      keywords = PositionMetric.find_by_name("keywords")
      if !news_response.des_facet.empty?
        news_response.des_facet.each do |keyword|
          @position_metric_points << PositionMetricPoint.new(:key => keyword, :value => 1, :article_id => article.id, :position_metric_id => keywords.id)
        end
      end
    end
  
    def self.authors(article, news_response)
      authors = PositionMetric.find_by_name("authors")
      self.clean_byline(news_response).each do |author|
        @position_metric_points << PositionMetricPoint.new(:key => author, :value => 1, :article_id => article.id, :position_metric_id => authors.id)
      end
    end

    def self.publication(article, news_response)
      publication = PositionMetric.find_by_name("publication")
      key = news_response.item_type
      @position_metric_points << PositionMetricPoint.new(:key => key, :value => 1, :article_id => article.id, :position_metric_id => publication.id)
    end

    def self.sub_publication(article, news_response)
      sub_publication = PositionMetric.find_by_name("sub_publication")
      key = news_response.kicker || news_response.blog_name
      @position_metric_points << PositionMetricPoint.new(:key => key, :value => 1, :article_id => article.id, :position_metric_id => sub_publication.id)
    end
  
    def self.news_type(article, news_response)
      news_type = PositionMetric.find_by_name("news_type")
      key = news_response.material_type_facet
      @position_metric_points << PositionMetricPoint.new(:key => key, :value => 1, :article_id => article.id, :position_metric_id => news_type.id)
    end
  
    def self.section(article, news_response)
      section = PositionMetric.find_by_name("section")
      key = news_response.section
      @position_metric_points << PositionMetricPoint.new(:key => key, :value => 1, :article_id => article.id, :position_metric_id => section.id)
    end
  
    def self.related_urls(article, news_response)
      related_url = PositionMetric.find_by_name("related_urls")
      urls = news_response.related_urls.collect(&:url) rescue []
      urls.each do |url|
        @position_metric_points << PositionMetricPoint.new(:key => url, :value => 1, :article_id => article.id, :position_metric_id => related_url.id)
      end
    end
  
    def self.clean_byline(article)
      return article.byline.downcase.gsub("by ", "").split(/,|and /).collect{|x| x.strip}.select{|x| !x.empty?}.collect{|a| a.split(" ").collect(&:capitalize).join(" ")}
    end
  end
end