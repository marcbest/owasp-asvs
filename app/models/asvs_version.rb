class AsvsVersion < ApplicationRecord
  has_many :requirements, dependent: :destroy
  has_many :assessments, dependent: :destroy
end
