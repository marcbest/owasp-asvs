require "csv"

class AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assessment, only: [:show, :edit, :update, :export]

  def index
    @assessments = current_user.assessments
    @assessment = Assessment.new
    @asvs_versions = AsvsVersion.all
  end

  def new
    @assessment = Assessment.new
    @asvs_versions = AsvsVersion.all
  end

  def create
    @assessment = Assessment.new(assessment_params)
    @assessment.user = current_user
    if @assessment.save
      redirect_to @assessment, notice: "Assessment created successfully."
    else
      @asvs_versions = AsvsVersion.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @assessment.update(assessment_params)
      redirect_to @assessment, notice: "Assessment updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def export
    # TODO: Note this export is very specific to a problem I need to solve, in the future make this generic 
    @assessment = Assessment.find(params[:id])

    csv_data = CSV.generate(headers: true) do |csv|
      # Add headers
      csv << ["question", "answer", "comment", "access", "products", "tags", "healthStatus", "reviewCadence", "nextReviewDate"]

      # Add rows
      @assessment.responses.includes(:requirement).each do |response|
        next unless response.applicable? # Only export applicable requirements
        requirement = response.requirement

        # Skip requirements that have no name (invalid questions)
        answer = response.met_requirement? ? "✅" : "❌"

        question = "#{requirement.shortcode}: "
        question += "#{requirement.name}: " if requirement.name.present?
        question += "#{requirement.description}" if requirement.description.present?

        # Include ASVS version in tags
        asvs_version = @assessment.asvs_version.version
        tags = "ASVS #{asvs_version}, Level #{requirement.l1_required ? '1' : (requirement.l2_required ? '2' : '3')}"

        csv << [
          question,                    # question
          answer,                      # answer
          response.comment,            # comment
          "internal",                  # access
          nil,                         # products
          tags,                        # tags (Now includes ASVS version)
          response.met_requirement? ? "Verified" : "Needs Review", # healthStatus
          "Quarterly",                 # reviewCadence
          3.months.from_now.strftime("%Y-%m-%d")  # nextReviewDate
        ]
      end
    end

    filename = "#{@assessment.name.parameterize}-asvs-export-#{Date.today}.csv"
    send_data csv_data, filename: filename, type: "text/csv"
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:id])
  end

  def assessment_params
    params.require(:assessment).permit(:asvs_version_id, :name)
  end
end
