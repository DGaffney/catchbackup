require 'open-uri'
module Sourcer
  class NYTimes
    @queue = :file_serve
    attr_accessor :newswire_api_key, :base_url
    def self.perform
      ActiveRecord::Base.verify_active_connections!
      @newswire_api_key = Setting.find_by_key("newswire_api_key").actual_value
      @source = Source.find_by_title("The New York Times")
      offset = 0
      articles= []
      news_responses = self.most_recent_linear(offset)
      news_responses.each do |response|
        article = Article.create(self.select_fields(response, @source.id))
        articles << article
        Resque.enqueue(Positioner::NYTimes, article, response)
      end
      while news_responses.length != 0
        offset+=news_responses.length
        news_responses = self.most_recent_linear(offset)
        news_responses.each do |response|
          article = Article.create(self.select_fields(response, @source.id))
          articles << article
          Resque.enqueue(Positioner::NYTimes, article, response)
        end      
        print "."
      end
    end

    def self.select_fields(article, source_id)
      return {:title => article.title, :author => self.clean_byline(article), :abstract => article.abstract, :url => article.url, :source_id => source_id, :created_at => Time.parse(article.created_date)}
    end

    def self.most_recent_linear(offset=0)
      @base_url = "http://api.nytimes.com/svc/news/v3/content/all/all.json"
      return Hashie::Mash[JSON.parse(open(@base_url+"?api-key="+@newswire_api_key+"&offset=#{offset}").read)].results
    end

    def self.most_recent_temporal(hrs="all")
      @base_url = "http://api.nytimes.com/svc/news/v3/content/all/#{hrs}.json"
      return Hashie::Mash[JSON.parse(open(@base_url+"?api-key="+@newswire_api_key).read)].results
    end

    def self.specific_article_details(url)
      @base_url = "http://api.nytimes.com/svc/news/v3/content.json"
      return Hashie::Mash[JSON.parse(open(@base_url+"?api-key=#{@newswire_api_key}&url="+url.gsub("/", "%2F")).read)].results
    end

    def self.clean_byline(article)
      return article.byline.downcase.gsub("by ", "").split(/,|and /).collect{|x| x.strip}.select{|x| !x.empty?}.collect{|a| a.split(" ").collect(&:capitalize).join(" ")}.join(", ")
    end
  end
end