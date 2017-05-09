require 'csv'

# Handles uploading data from different formats
module LedgerUploadHelper

  # uploads for each format, as well as defaults
  def upload_from_format(data_file, data_format)
    case data_format.downcase
    when 'discover'
      delim, date_fmt, column_mapping = discover
    else
      delim = "\t"
      column_mapping = {}
      date_fmt = '%m/%d/%y'
    end

    # add converter for commma separated numbers
    comma_numbers = ->(s) { s =~ /^\d+,/ ? s.delete(',').to_f : s }
    date_conversion = lambda { |s|
      begin
        Date.strptime(s, date_fmt)
      rescue ArgumentError
        s
      end
    }
    CSV::Converters[:comma_numbers] = comma_numbers
    CSV::Converters[:date_conversion] = date_conversion

    # processing the data file
    transactions = []
    CSV.foreach(data_file,
                quote_char: '"',
                col_sep: delim,
                converters: %i[all comma_numbers date_conversion],
                headers: true,
                header_converters: :symbol) do |row|
                  next if row.empty?
                  row = map_columns(row, column_mapping)
                  transactions.push(yield(row))
                end
    transactions
  end

  def map_columns(data, column_mapping)
    mapped_data = {}
    data.map do |key, value|
      # remove nil keys from extra empty columns in file
      next if key.nil?
      # unmapped keys are passed through, if column_mapping[key] is nil
      # then the value is not stored in the mapping
      if column_mapping.key?(key)
        mapped_data[column_mapping[key]] = value if column_mapping[key]
      else
        mapped_data[key] = value
      end
    end
    mapped_data
  end

  # Different column name mappings and delimiter for each upload_format
  def discover #  this would be best stored in the database eventually
    mapping = {
      trans_date: :date,
      post_date: nil
    }
    #
    return ',', '%m/%d/%Y', mapping
  end
end
