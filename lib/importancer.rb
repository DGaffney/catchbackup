require 'open-uri'
module Importancer
  class NYTimes
    def self.perform(article, response)
      self.calculate_importance_metrics(article, response)
    end

    def self.calculate_importance_metrics(article)
    end
    
  end
end