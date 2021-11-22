class CsvFilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @csv_files = current_user.csv_files
                             .paginate(page: params[:page], per_page: 20)
  end

  def new
    @csv_file = CsvFile.new
  end

  def create
    @csv_file = CsvFile.create(create_params)
    if @csv_file.valid?
      ParserJob.perform_later({ file_id: csv_file.id, headers: file_headers })
      flash[:notice] = "File imported correctly. Processing will start soon"
      redirect_to csv_files_path
    else
      flash.now[:alert] = "Something went wrong, please see below"
      render :new
    end
  end

  private

  def file_headers
    result = {}
    key_headers = %i[name address phone date_of_birth credit_card email]
    key_headers.each do |key|
      result[key] = csv_files_params[key] unless csv_files_params[key].blank?
    end
    result
  end

  def csv_files_params
    params.require(:csv_file).permit(
                                :file,
                                :name,
                                :address,
                                :phone,
                                :date_of_birth,
                                :credit_card,
                                :email
                                 )
  end

  def create_params
    { file: csv_files_params[:file], user: current_user }
  end
end
