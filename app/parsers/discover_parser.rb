# Additional logic to properly map column names and values
class DiscoverParser < DefaultParser
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
