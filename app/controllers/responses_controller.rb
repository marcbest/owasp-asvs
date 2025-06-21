class ResponsesController < ApplicationController
  before_action :set_assessment

  def update
    @response = @assessment.responses.find(params[:id])

    if @response.update(response_params)
      respond_to do |format|
        format.turbo_stream do
          # Update the specific field that was changed
          case params[:update_field]
          when "applicable"
            render turbo_stream: turbo_stream.replace(
              "applicable_frame_#{@response.requirement.id}",
              partial: "assessments/applicable_checkbox",
              locals: { response_obj: @response, assessment: @assessment, requirement: @response.requirement }
            )
          when "met_requirement"
            render turbo_stream: turbo_stream.replace(
              "pass_frame_#{@response.requirement.id}",
              partial: "assessments/pass_checkbox", 
              locals: { response_obj: @response, assessment: @assessment, requirement: @response.requirement }
            )
          when "comment"
            render turbo_stream: turbo_stream.replace(
              "notes_frame_#{@response.requirement.id}",
              partial: "assessments/notes_field",
              locals: { response_obj: @response, assessment: @assessment, requirement: @response.requirement }
            )
          end
        end
        format.html { redirect_to assessment_path(@assessment), notice: "Response updated." }
      end
    else
      head :unprocessable_entity
    end
  end

  private
  
  def set_assessment
    @assessment = current_user.assessments.find_by!(uuid: params[:assessment_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to assessments_path, alert: "You don't have permission to access that assessment."
  end

  def response_params
    params.require(:response).permit(:applicable, :met_requirement, :comment)
  end
end
