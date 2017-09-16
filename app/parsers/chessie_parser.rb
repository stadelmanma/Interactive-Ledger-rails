# Additional logic to properly map column names and values
class ChessieParser < DefaultParser
  def initialize
    super
    @date_fmt = '%m/%d/%Y'
    @csv_kwargs = { col_sep: ',', converters: add_converters }
    @csv_kwargs = DEFAULT_KWARGS.merge(@csv_kwargs)
    @column_name_mapping = { effective_date: :date }
    @column_value_mapping = {}
  end
end
