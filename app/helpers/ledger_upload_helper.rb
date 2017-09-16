require 'csv'

# Handles uploading data from different download formats
module LedgerUploadHelper
  #
  # Uploads the data from an ActionDispatch tempfile using a block as
  # the last arg to build each Transaction object.
  def upload_from_format(user_upload, data_format)
    #
    # determine data upload format
    parser = get_parser(data_format)

    # processing the data file
    transactions = []
    CSV.foreach(user_upload.tempfile, parser.csv_kwargs) do |row|
      row = parser.map_columns(row)
      transactions.push(yield(row))
    end
    transactions
  end

  def all_parsers
    [DefaultParser].concat DefaultParser.subclasses
  end

  def get_parser(data_format)
    parser_name = data_format.to_s.downcase + '_parser'
    #
    begin
      parser_name.classify.constantize.new
    rescue NameError
      throw ArgumentError("Unkown data format: #{data_format}")
    end
  end
end
