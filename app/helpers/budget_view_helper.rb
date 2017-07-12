# Additional logic used to generate the budget view pages
module BudgetViewHelper
  def convert_totals_to_rows(budget, totals)
    cat_hash = {}
    # process category totals
    process_category_totals(totals[:category_totals], cat_hash)
    # add all expenses
    process_special_transactions(totals[:budgeted_expenses], cat_hash)
    # add all deposits
    process_special_transactions(totals[:deposits], cat_hash)
    # factor in planned items to get the final row values
    merge_expected_items(budget, totals, cat_hash)
    cat_hash.values
  end

  # stores transactions in the hash based on their subcategory, if the
  # same category is used then the value is incremented
  def process_special_transactions(transactions, cat_hash)
    transactions.each do |trans|
      key = trans.subcategory
      if cat_hash[key]
        cat_hash[key][2] += trans.amount
        cat_hash[key][3] += "; #{trans.comments}"
      else
        cat_hash[key] = [trans.subcategory, '-', trans.amount, trans.comments]
      end
    end
  end

  def process_category_totals(cat_totals, cat_hash)
    cat_totals.each do |category, amount|
      next if category =~ /budgeted|deposit/i
      cat_hash[category] = [category, '-', amount, '']
    end
  end

  # updates the category hash with the planned items changing existing
  # entries 'expected amount' field if they already exist or adding a new
  # entry if not
  def merge_expected_items(budget, totals, cat_hash)
    #
    # get all planned expenses/deposits for the current week
    range = totals[:date_range][0]..totals[:date_range][1]
    planned_items = budget.budget_expenses.where(date: range)
    #
    # update cat hash with the planned expenses
    planned_items.each do |exp|
      key = exp.description
      #
      if cat_hash[key]
        cat_hash[key][1] = exp.amount
      else
        cat_hash[key] = [exp.description, exp.amount, '-', exp.comments]
      end
    end
  end
end
