class Assessment < ApplicationRecord
  belongs_to :user
  belongs_to :asvs_version
  has_many :responses, dependent: :destroy
end
