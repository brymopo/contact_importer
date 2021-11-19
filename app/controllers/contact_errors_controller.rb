class ContactErrorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @failed_contacts = current_user.contact_errors
                                   .paginate(page: params[:page], per_page: 20)
  end
end
