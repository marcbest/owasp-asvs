class SharingUrl < ApplicationRecord
  belongs_to :assessment
  belongs_to :user

  before_create :generate_uuid

  validates :uuid, uniqueness: true

  scope :active, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) }

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
