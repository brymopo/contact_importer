require "rails_helper"

RSpec.describe StaticPagesController, type: :request do
  describe "GET #Index" do
    subject { get root_path }

    it { is_expected.to render_template(:index) }
    
  end
end