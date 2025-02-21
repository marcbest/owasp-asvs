class ResponsesController < ApplicationController
  before_action :set_assessment

  def update
    @response = @assessment.responses.find(params[:id])

    if @response.update(response_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "#{params[:update_field]}_#{@response.id}", 
            partial: "assessments/checkbox", 
            locals: { response_obj: @response, assessment: @assessment, field: params[:update_field] }
          )
        end
        format.html { redirect_to assessment_path(@assessment), notice: "Response updated." }
      end
    else
      head :unprocessable_entity
    end
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:assessment_id])
  end

  def response_params
    params.require(:response).permit(:applicable, :met_requirement, :comment)
  end
end
