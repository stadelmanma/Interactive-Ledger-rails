# Helpers display values consistenty across multiple views
module DisplayHelper
  include ActionView::Helpers::NumberHelper

  def display_value(value)
    case value.class.to_s
    when 'Float'
      display_number(value)
    else
      value
    end
  end

  def display_number(number)
    number_with_precision(number, delimiter: ',', precision: 2)
  end
end
