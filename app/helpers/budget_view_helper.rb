# Additional logic used to generate the budget view pages
module BudgetViewHelper
  # a class that manages a group of budget rows
  class BudgetSection
    attr_accessor :date_range, :rows

    private

    def initialize(budget, totals)
      @date_range = totals.date_range
      @rows = process_totals(budget, totals)
    end

    # converts a set of week totals into a set of BudgetRow instances for
    def process_totals(budget, totals)
      cat_hash = {}

      # initialize budget with planned items first
      range = @date_range[0]..@date_range[1]
      expected_items = budget.budget_expenses.where(date: range)
      process_expected_items(expected_items, cat_hash)

      # process category totals
      process_category_totals(totals.all_category_totals, cat_hash)

      # add all expenses
      process_special_transactions(totals.budgeted_expenses, cat_hash)

      # add all deposits
      process_special_transactions(totals.deposits, cat_hash)
      #
      cat_hash.values
    end

    # updates the category hash with the planned items so they get organized
    # at the top of the section
    def process_expected_items(planned_items, cat_hash)
      #
      # update cat hash with the planned expenses
      planned_items.each do |exp|
        key = exp.description
        args = {
          description: exp.description,
          original_amount: exp.amount,
          comments: exp.comments
        }
        cat_hash[key] = BudgetRow.new(**args)
      end
    end

    # Adds all category totals to the hash
    def process_category_totals(cat_totals, cat_hash)
      cat_totals.each do |category, amount|
        next if category =~ /^(budgeted|deposit)$/i
        #
        if cat_hash[category]
          cat_hash[category].update(actual_amount: amount)
        else
          args = { description: category, actual_amount: amount }
          cat_hash[category] = BudgetRow.new(**args)
        end
      end
    end

    # stores transactions in the hash based on their subcategory, if the
    # same category is used then the amount is incremented
    def process_special_transactions(transactions, cat_hash)
      transactions.each do |trans|
        key = trans.subcategory
        args = { actual_amount: trans.amount, comments: trans.comments }
        #
        if cat_hash[key]
          cat_hash[key].update(args)
        else
          args[:description] = trans.subcategory
          cat_hash[key] = BudgetRow.new(args)
        end
      end
    end
  end

  # class to manage a single row of data within a section of budget view
  class BudgetRow
    include ActionView::Helpers::NumberHelper
    attr_accessor :description, :original_amount, :actual_amount,
                  :balance, :comments

    # creates a budget row using the options hash
    def initialize(options)
      whitelist = %i[description original_amount actual_amount balance comments]
      validate_options(options, whitelist)
      #
      @description = options.fetch(:description, '')
      @original_amount = options.fetch(:original_amount, 0.0)
      @actual_amount = options.fetch(:actual_amount, 0.0)
      @balance = options.fetch(:balance, 0.0)
      @comments = options.fetch(:comments, '')
      @comments = [@comments] unless @comments.is_a? Array
    end

    # updates certain attributes from the hash
    def update(options)
      validate_options(options, %i[actual_amount balance comments])
      @actual_amount += options.fetch(:actual_amount, 0.0)
      @balance += options.fetch(:balance, 0.0)
      @comments << options[:comments] if options[:comments]
    end

    def attributes
      {
        description: @description,
        original_amount: @original_amount,
        actual_amount: @actual_amount,
        balance: @balance,
        comments: @comments.uniq.join('; ')
      }
    end

    private

    def validate_options(options, whitelist)
      options.keys.each do |key|
        msg = "Invalid paremeter: #{key}"
        raise ArgumentError, msg unless whitelist.include? key
      end
    end
  end

  # converts the totals hash into an array of budget sections
  def process_totals(budget, totals)
    # create the sections
    sections = totals.values.map { |total| BudgetSection.new(budget, total) }
    # update balance values
    sections.map(&:rows).flatten.inject(budget.initial_balance) do |bal, row|
      row.balance = bal + row.actual_amount
    end
    # return sectins
    sections
  end
end
