class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    date = Date.iso8601(value)

    if date > Time.zone.today
      record.errors.add attribute, (options[:message] || "cannot be in the future")
    end
  rescue StandardError => e
    record.errors.add attribute, (options[:message] || "is not a valid date")
  end
end