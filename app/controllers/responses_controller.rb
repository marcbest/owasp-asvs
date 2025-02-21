class ResponsesController < ApplicationController
  before_action :set_assessment

  def create
    @response = @assessment.responses.build(response_params.except(:level))
    @level = response_params[:level].to_i

    if @response.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "row_#{@response.requirement_id}",
            partial: "assessments/requirement_row",
            locals: { req: @response.requirement, assessment: @assessment, level: @level }
          )
        end
        format.html { redirect_to @assessment, notice: "Response saved." }
      end
    else
      respond_with_error(@response)
    end
  end

  def update
    @response = @assessment.responses.find(params[:id])
    @level = response_params[:level].to_i

    if @response.update(response_params.except(:level))
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "row_#{@response.requirement_id}",
            partial: "assessments/requirement_row",
            locals: { req: @response.requirement, assessment: @assessment, level: @level }
          )
        end
        format.html { redirect_to @assessment, notice: "Response updated." }
      end
    else
      respond_with_error(@response)
    end
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:assessment_id])
  end

  def response_params
    params.require(:response).permit(:requirement_id, :met_requirement, :comment, :level)
  end

  def respond_with_error(response)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "row_#{response.requirement_id}",
          partial: "assessments/requirement_row",
          locals: { req: response.requirement, assessment: @assessment, level: @level }
        )
      end
      format.html { redirect_to @assessment, alert: "Error saving response." }
    end
  end
end
