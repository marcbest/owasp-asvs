require "csv"
require "prawn"
require "prawn/table"

class AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assessment, only: [:show, :edit, :update, :export, :export_pdf]
  
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
    @assessment = Assessment.find(params[:id])
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["question", "answer", "comment", "access", "products", "tags", "healthStatus", "reviewCadence", "nextReviewDate"]
      
      @assessment.responses.includes(:requirement).each do |response|
        next unless response.applicable?
        requirement = response.requirement
        answer = response.met_requirement? ? "✅" : "❌"
        question = "#{requirement.shortcode}: "
        question += "#{requirement.name}: " if requirement.name.present?
        question += "#{requirement.description}" if requirement.description.present?
        asvs_version = @assessment.asvs_version.version
        tags = "ASVS #{asvs_version}, Level #{requirement.l1_required ? '1' : (requirement.l2_required ? '2' : '3')}"
        
        csv << [
          question,                    
          answer,                      
          response.comment,            
          "internal",                  
          nil,                         
          tags,                        
          response.met_requirement? ? "Verified" : "Needs Review", 
          "Quarterly",                 
          3.months.from_now.strftime("%Y-%m-%d")  
        ]
      end
    end
    filename = "#{@assessment.name.parameterize}-asvs-export-#{Date.today}.csv"
    send_data csv_data, filename: filename, type: "text/csv"
  end
  
  def export_pdf
    target_level = params[:target_level].to_i
    target_level = 1 unless [1, 2, 3].include?(target_level)

    applicable_requirements = @assessment.responses
                                       .joins(:requirement)
                                       .where("requirements.l#{target_level}_required = ?", true)
                                       .where(applicable: true)
    total_requirements = applicable_requirements.count
    passed_requirements = applicable_requirements.where(met_requirement: true).count
    progress_percentage = total_requirements > 0 ? ((passed_requirements.to_f / total_requirements) * 100).round(2) : 0

    filename = "#{@assessment.name.parameterize}-asvs-level#{target_level}-#{Date.today}.pdf"

    # Create a new PDF document
    pdf = Prawn::Document.new(page_size: "A4", page_layout: :landscape, margin: [30, 30, 30, 30])

    # Load UTF-8 compatible font with normal and bold variants
    pdf.font_families.update(
      "DejaVu" => {
        normal: "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
        bold: "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf"
      }
    )

    pdf.font("DejaVu") # Set the default font

    # Add report title
    pdf.font("DejaVu", style: :bold) { pdf.text "#{@assessment.name}", size: 18 }
    pdf.font("DejaVu", style: :bold) { pdf.text "ASVS #{@assessment.asvs_version.name} - Level #{target_level}", size: 14 }
    pdf.text "Generated on: #{Date.today.strftime('%B %d, %Y')}"

    # Add progress information
    pdf.move_down 10
    pdf.text "Progress: #{progress_percentage}% complete (#{passed_requirements} of #{total_requirements} requirements passed)"
    
    # Add a progress bar
    pdf.move_down 5
    pdf.stroke { pdf.rectangle [0, pdf.cursor], 500, 15 }
    if progress_percentage > 0
      pdf.fill_color "4299e1"
      pdf.fill_rectangle [0, pdf.cursor], 500 * (progress_percentage / 100.0), 15
      pdf.fill_color "000000"
    end

    pdf.move_down 20
    headers = ["ID", "Description", "L1", "L2", "L3", "Applicable", "Pass", "Notes"]
    requirements_data = []

    def process_requirement(pdf, req, assessment, level, requirements_data)
      response_obj = assessment.responses.find_by(requirement_id: req.id) || assessment.responses.build(requirement: req)
      has_requirements = req.l1_required || req.l2_required || req.l3_required

      row_data = []
      row_data << { content: req.shortcode.to_s.encode("UTF-8"), padding_left: level * 10 }
      description = "#{req.name}".encode("UTF-8")
      description += "\n#{req.description}".encode("UTF-8") if req.description.present?
      row_data << description

      if has_requirements
        row_data << { content: req.l1_required ? "✓" : "—", align: :center }
        row_data << { content: req.l2_required ? "✓" : "—", align: :center }
        row_data << { content: req.l3_required ? "✓" : "—", align: :center }
        row_data << { content: response_obj.applicable? ? "✓" : "—", align: :center }
        row_data << { content: response_obj.met_requirement? ? "✓" : "—", align: :center }
        row_data << response_obj.comment.to_s.encode("UTF-8")
      else
        row_data << { content: "", colspan: 6 }
      end

      requirements_data << row_data
      req.children.each { |child| process_requirement(pdf, child, assessment, level + 1, requirements_data) }
    end

    top_requirements = @assessment.asvs_version.requirements.where(parent_id: nil)
    top_requirements.each { |req| process_requirement(pdf, req, @assessment, 0, requirements_data) }

    pdf.table([headers] + requirements_data, header: true, width: pdf.bounds.width) do |table|
      table.row(0).font_style = :bold
      table.row(0).background_color = "EEEEEE"
      table.column(0).width = 60
      table.column(2..6).width = 40
      table.cells.padding = [4, 4, 4, 4]
      table.cells.border_width = 0.5
      table.row_colors = ["FFFFFF", "F9F9F9"]
    end

    pdf.page_count.times do |i|
      pdf.go_to_page(i + 1)
      pdf.draw_text "Page #{i + 1} of #{pdf.page_count}", at: [pdf.bounds.right - 150, -15]
    end

    send_data pdf.render, filename: filename, type: "application/pdf", disposition: "inline"
  end

  private

  def set_assessment
    @assessment = current_user.assessments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to assessments_path, alert: "You don't have permission to access that assessment."
  end
  
  def assessment_params
    params.require(:assessment).permit(:asvs_version_id, :name)
  end
end
