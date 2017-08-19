# Helpers display values consistenty across multiple views
module DisplayHelper
  include ActionView::Helpers::NumberHelper

  def display_value(value, options)
    case value.class.to_s
    when 'Float'
      display_number(value, options)
    else
      value
    end
  end

  def display_number(number, options)
    if options[:dash_zero_value] && (number * 100).to_i.zero?
      '-'
    else
      number_with_precision(number, delimiter: ',', precision: 2)
    end
  end
end
