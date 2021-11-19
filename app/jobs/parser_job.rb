class ParserJob < ApplicationJob
  queue_as :default
  discard_on StandardError

  def perform(args)
    CsvParser.call(args)
  end
end
