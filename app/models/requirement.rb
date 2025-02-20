class Requirement < ApplicationRecord
  belongs_to :asvs_version
  belongs_to :parent, class_name: "Requirement", optional: true
  has_many :children, class_name: "Requirement", foreign_key: "parent_id", dependent: :destroy
end
