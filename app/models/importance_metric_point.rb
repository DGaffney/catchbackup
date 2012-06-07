class ImportanceMetricPoint < ActiveRecord::Base
  belongs_to :importance_metric
  belongs_to :article
end
