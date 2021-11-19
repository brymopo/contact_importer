class CsvFilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @csv_files = current_user.csv_files
                             .paginate(page: params[:page], per_page: 20)
  end
end
