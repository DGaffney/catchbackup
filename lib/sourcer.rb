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
        begin
          article = Article.new(self.select_fields(response, @source.id))
          if article.save
            articles << article
            Resque.enqueue(Positioner::NYTimes, article, response)
            Importancer.constants.select {|c| Class === Importancer.const_get(c)}.collect{|c| c.to_s.gsub(":", "")}.each do |a_class|
              Resque.enqueue(Importancer.const_get("Clicks"), article)
            end
          end
        rescue
          next
        end
      end
      while news_responses.length != 0
        begin
          offset+=news_responses.length
          news_responses = self.most_recent_linear(offset)
          news_responses.each do |response|
            begin
              article = Article.create(self.select_fields(response, @source.id))
              if article.save
                articles << article
                Resque.enqueue(Positioner::NYTimes, article, response)
                Importancer.constants.select {|c| Class === Importancer.const_get(c)}.collect{|c| c.to_s.gsub(":", "")}.each do |a_class|
                  Resque.enqueue(Importancer.const_get("Clicks"), article)
                end
              end
            rescue
              next
            end
          end      
          print "."
        rescue
          retry
        end
      end
    end

    def self.select_fields(article, source_id)
      return {:title => article.title, :abstract => article.abstract, :url => article.url, :source_id => source_id, :created_at => Time.parse(article.created_date)}
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
  end
end
