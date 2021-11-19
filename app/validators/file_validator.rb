class FileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.content_type != "text/csv"
      record.errors.add attribute, (options[:message] || "is not of type text/csv")
    end
  end
end