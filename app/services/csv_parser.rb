require "csv"

class CsvParser
  attr_reader :headers, :file, :user_id

  def initialize(args)
    file_id = args.fetch(:file_id)
    @headers = set_headers(args.fetch(:headers, nil))
    @file = CsvFile.find(file_id)
    @user_id = @file.user.id
  end

  def self.call(args)
    self.new(args).call
  end

  def call
    table.each do |row|
      file.process! if file.on_hold?
      contact = Contact.create(row_params(row))
      file.mark_finished! if !file.finished? && contact.valid?
      log_errors(contact) if !contact.valid?
    rescue StandardError => e
      next
    end
    file.mark_failed! if file.processing?
  end

  private

  def log_errors(record)
    errors = record.errors.to_hash
    errors[:user_errors] = hash.delete :user if errors[:user].present?
    errors = errors.merge({ contact_identifier: record.email, user_id: user_id })
    ContactError.create!(errors)
  end

  def row_params(row)
    result = row.to_h
                .merge(user_id: user_id)
                .transform_keys(&:downcase)
                .symbolize_keys
    return result if headers.blank?

    mapped_headers(result)
  end

  def mapped_headers(row)
    result = {}
    row.each_key do |key|
      final_key = headers[key].blank? ? key : headers[key]
      result[final_key] = row[key]
    end
    result
  end

  def set_headers(headers)
    return if headers.blank?

    headers.invert.transform_keys(&:downcase).symbolize_keys
  end

  def table
    CSV.parse(file.file.download, headers: true)
  end
end