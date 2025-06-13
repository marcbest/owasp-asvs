class PopulateAssessmentUuids < ActiveRecord::Migration[8.0]
  def up
    Assessment.find_each do |assessment|
      assessment.update_column(:uuid, SecureRandom.uuid) unless assessment.uuid.present?
    end
  end

  def down
    # No-op: we don't want to remove UUIDs on rollback
  end
end
