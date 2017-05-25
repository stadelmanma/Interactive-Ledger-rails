# Place for logic common across all models in the app
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
