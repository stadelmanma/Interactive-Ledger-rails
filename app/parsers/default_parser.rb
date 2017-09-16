# default class for handling file uploads
class DefaultParser
  attr_reader :csv_kwargs
  DEFAULT_KWARGS = {
    quote_char: '"',
    col_sep: "\t",
    skip_blanks: true,
    converters: :all,
    headers: true,
    header_converters: :symbol
  }.freeze

  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def initialize
    @date_fmt = '%m/%d/%Y'
    @csv_kwargs = DEFAULT_KWARGS.merge(converters: @converters)
    @column_name_mapping = {}
    @column_value_mapping = {}
  end

  def register_converter(symbol, conv_proc)
    CSV::Converters[symbol] = conv_proc
    @converters << symbol
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

  def add_converters
    @converters = %i[all]
    register_account_numbers
    register_date_conversion
  end

  # add converter for commma separated numbers and makes parentheized
  # values negative
  def register_account_numbers
    account_numbers = lambda { |s|
      begin
        val = Float(s.gsub(/[$,()]/, ''))
        s =~ /^\(.+\)$/ ? -val : val
      rescue ArgumentError
        s
      end
    }
    #
    register_converter(:account_numbers, account_numbers)
  end

  # handle date parsing gracefully
  def register_date_conversion
    date_conversion = lambda { |s|
      begin
        Date.strptime(s, @date_fmt)
      rescue ArgumentError
        s
      end
    }
    #
    register_converter(:date_conversion, date_conversion)
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
