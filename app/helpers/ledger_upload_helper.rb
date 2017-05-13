require 'csv'

# Handles uploading data from different formats
module LedgerUploadHelper
  # Uploads the data from a file using a block as the last arg to build
  # each Transaction object.
  def upload_from_format(data_file, data_format)
    #
    # determine data upload format
    formatter = get_formatter(data_format)

    # processing the data file
    transactions = []
    CSV.foreach(data_file, formatter.csv_kwargs) do |row|
      row = formatter.map_columns(row)
      transactions.push(yield(row))
    end
    transactions
  end

  def get_formatter(data_format)
    case data_format.downcase
    when 'discover'
      DiscoverFormat.new
    when 'chessie'
      ChessieFormat.new
    when 'default'
      DefaultFormat.new
    else
      throw ArgumentError("Unkown data format: #{data_format}")
    end
  end

  # default class for handling file uploads
  class DefaultFormat
    attr_reader :csv_kwargs
    DEFAULT_KWARGS = {
      quote_char: '"',
      col_sep: "\t",
      skip_blanks: true,
      converters: :all,
      headers: true,
      header_converters: :symbol
    }.freeze

    def initialize
      @date_fmt = '%m/%d/%Y'
      @csv_kwargs = DEFAULT_KWARGS.merge(converters: add_converters)
      @column_name_mapping = {}
      @column_value_mapping = {}
    end

    def map_columns(data)
      mapped_data = {}
      data.map do |column, value|
        # remove nil keys from extra empty columns in file
        next if column.nil?

        # unmapped keys are passed through, if column_mapping[key] is nil
        # then the value is not stored in the mapping
        key = process_column_names(column)
        next if key.nil?

        # processing values as needed
        mapped_data[key] = process_column_values(column, value)
      end
      mapped_data
    end

    private

    # adds converts to the list and returns a list of symbols to use
    def add_converters
      # add converter for commma separated numbers
      account_numbers = lambda { |s|
        begin
          val = Float(s.gsub(/[$,()]/, ''))
          s =~ /^\(.+\)$/ ? -val : val
        rescue ArgumentError
          s
        end
        }

      # handle date parsing gracefully
      date_conversion = lambda { |s|
        begin
          Date.strptime(s, @date_fmt)
        rescue ArgumentError
          s
        end
      }
      #
      CSV::Converters[:account_numbers] = account_numbers
      CSV::Converters[:date_conversion] = date_conversion
      %i[all account_numbers date_conversion]
    end

    def process_column_names(column)
      if @column_name_mapping.key?(column)
        @column_name_mapping[column]
      else
        column
      end
    end

    def process_column_values(column, value)
      if @column_value_mapping.key?(column)
        @column_value_mapping[column].call(value)
      else
        value
      end
    end
  end

  # Additional logic to properly map column names and values
  class ChessieFormat < DefaultFormat
    def initialize
      super
      @date_fmt = '%m/%d/%Y'
      @csv_kwargs = { col_sep: ',', converters: add_converters }
      @csv_kwargs = DEFAULT_KWARGS.merge(@csv_kwargs)
      @column_name_mapping = { effective_date: :date }
      @column_value_mapping = {}
    end
  end

  # Additional logic to properly map column names and values
  class DiscoverFormat < DefaultFormat
    def initialize
      super
      @csv_kwargs = { col_sep: ',', converters: add_converters }
      @csv_kwargs = DEFAULT_KWARGS.merge(@csv_kwargs)
      @column_name_mapping = {
        trans_date: :date,
        post_date: nil,
        category: :comments
      }
      @column_value_mapping = { amount: ->(v) { -v } }
    end
  end
end
