class AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assessment, only: [:show, :edit, :update]

  def index
    @assessments = current_user.assessments
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
    # Renders the assessment with its nested requirements and responses.
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

  private

  def set_assessment
    @assessment = Assessment.find(params[:id])
  end

  def assessment_params
    params.require(:assessment).permit(:asvs_version_id)
  end
end
