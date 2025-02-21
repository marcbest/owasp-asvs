class Assessment < ApplicationRecord
  belongs_to :user
  belongs_to :asvs_version
  has_many :responses, dependent: :destroy
  has_many :sharing_urls, dependent: :destroy

  # Automatically create a response for each requirement in the ASVS version
  # with applicable defaulting to true.
  after_create :initialize_responses

  private

  def initialize_responses
    asvs_version.requirements.find_each do |requirement|
      # Using find_or_create_by ensures we don't duplicate responses if called more than once.
      responses.find_or_create_by(requirement: requirement) do |response|
        response.applicable = true
      end
    end
  end
end
