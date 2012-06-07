class UserPositionMetricPoint < ActiveRecord::Base
  belongs_to :user_position_metric
  belongs_to :user
end
