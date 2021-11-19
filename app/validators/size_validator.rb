class SizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?

    if value.byte_size > 2.megabyte
      record.errors.add attribute, (options[:message] || "cannot be more than 2 MB")
    end
  end
end