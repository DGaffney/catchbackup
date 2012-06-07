class PositionMetricPoint < ActiveRecord::Base
  belongs_to :position_metric
  belongs_to :article
end
