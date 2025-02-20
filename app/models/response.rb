class Response < ApplicationRecord
  belongs_to :assessment
  belongs_to :requirement
end
