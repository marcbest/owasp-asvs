class SharingUrlsController < ApplicationController
  include ActionView::RecordIdentifier
  
  before_action :set_assessment, only: [:index, :create, :destroy]
  before_action :authenticate_user!, except: [:show]

  def index
    @sharing_urls = @assessment.sharing_urls
  end

  def create
    sharing_params = params.require(:sharing_url).permit(:description, :expiry)
    
    expires_at = case sharing_params[:expiry]
                 when "1_week" then 1.week.from_now
                 when "1_month" then 1.month.from_now
                 when "6_months" then 6.months.from_now
                 else nil
                 end

    @sharing_url = @assessment.sharing_urls.create!(
      expires_at: expires_at,
      description: sharing_params[:description],
      user: current_user
    )

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(
          "sharing_urls_list",
          partial: "sharing_urls/list",
          locals: { urls: [@sharing_url] }
        )
      end
      format.html { redirect_to assessment_sharing_urls_path(@assessment), notice: "Sharing link created!" }
    end
  end

  def show
    @sharing_url = SharingUrl.find_by(uuid: params[:uuid])
    if @sharing_url&.expired?
      render plain: "This assessment sharing link has expired.", status: :gone
    else
      @assessment = @sharing_url.assessment
      render "assessments/show"
    end
  end

  def destroy
    @sharing_url = @assessment.sharing_urls.find(params[:id])
    @sharing_url.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@sharing_url)) }
      format.html { redirect_to assessment_sharing_urls_path(@assessment), notice: "Sharing link removed." }
    end
  end

  private

  def set_assessment
    @assessment = current_user.assessments.find(params[:assessment_id])
  end
end