class UserPositionMetric < ActiveRecord::Base
  has_many :user_position_metric_points
  belongs_to :user
end
