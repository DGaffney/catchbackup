class User < ActiveRecord::Base

  has_many :user_position_metric_points
  has_many :user_position_metrics
  
  validates :name, :screen_name, presence: true
  validates :uid, :oauth_token, :oauth_token_secret, presence: true, uniqueness: true,  on: :create
  validates :screen_name, uniqueness: true
  # validates :website_url, :affiliation_url, format: { with: URI::regexp(%w(http https)), message: "Invalid URL! Try adding 'http://'" }

  def self.create_with_omniauth(auth)
    user = User.new
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.oauth_token = auth["credentials"]["token"]
    user.oauth_token_secret = auth["credentials"]["secret"]
    user.screen_name = auth.extra.raw_info.screen_name
    user.name = auth.extra.raw_info.name
    user.location = auth.extra.raw_info.location
    user.info = auth.extra.raw_info.description
    user.join_date = Time.now
    user.save!
    UserPositioner::Twitter.perform(user.id)
  end


  def to_param
    self.screen_name
  end
  
  def human_join_date
    return self.join_date.strftime("%b %d, %Y")
  end
  
  def self.roles
    return Setting.find_by_name("roles").value
  end
  
  def admin?
    return User.find(self.id).role == "Admin"
  end
  
  def curations_count
    return curations.count
  end
  
  def safe_website_url
    if self.website_url[0..6] != "http://"
      "http://"+self.website_url
    else 
      return self.website_url
    end
  end
  
  def self.highest_role
    return Setting.find_by_name("roles").actual_value[-2]
  end
  
  def self.roles
    return Setting.find_by_name("roles").actual_value
  end
end
