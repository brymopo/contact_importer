require 'rails_helper'

RSpec.describe ParserJob, type: :job do
  include ActiveJob::TestHelper

  let(:headers) { {} }
  let(:file_name) { "right_headers.csv" }
  let(:user) { create(:user) }
  let(:csv_file) do
    record = CsvFile.new(user_id: user.id)
    record.file.attach(
      io: File.open(Rails.root.join("spec", "fixtures", "files", file_name)),
      filename: file_name,
      content_type: "text/csv"
    )
    record.save
    record
  end
  let(:params) { { file_id: csv_file.id, headers: headers } }

  subject { described_class.perform_later(params) }

  it "queues the job" do
    expect { subject }.to have_enqueued_job(described_class)
      .with(params)
      .on_queue("default")
  end

  it "performs the job" do
    expect(CsvParser).to receive(:call).with(params)
    perform_enqueued_jobs { subject }
  end
end
