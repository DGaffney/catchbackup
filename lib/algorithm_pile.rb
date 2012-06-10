class AlgorithmPile
  def self.logged_score(best,this)
    Math.log(best, 10)/Math.log(this, 10)
  end
end