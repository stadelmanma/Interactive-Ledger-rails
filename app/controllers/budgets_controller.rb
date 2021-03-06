# Manages the view-model interface for Budgets
class BudgetsController < ApplicationController
  include TransactionTotals
  before_action :set_budget, only: %i[show edit update destroy]

  def index
    redirect_to root_path
  end

  def show
    @page_heading = "Budget: #{@budget.name}"
    @page_links = [
      { name: 'Back', url: root_path },
      { name: 'Edit', url: [:edit, @budget] }
    ]
    @transactions = @budget.transactions.order(date: :asc)
    @totals = create_totals_hash(@transactions)
  end

  def new
    @page_heading = 'New Budget'
    @page_links = [
      { name: 'Back', url: root_path }
    ]
    @budget = Budget.new
  end

  def edit
    @page_heading = 'Editing Budget'
    @page_links = [
      { name: 'Back', url: @budget }
    ]
  end

  def create
    @budget = Budget.new(budget_params)
    if @budget.save
      redirect_to @budget, notice: 'Budget was successfully created.'
    else
      render 'new'
    end
  end

  def update
    if @budget.update(budget_params)
      redirect_to @budget, notice: 'Budget was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @budget.destroy
    redirect_to budgets_url, notice: 'Budget was successfully destroyed.'
  end

  def add_budget_ledger_select
    render partial: 'ledger_select',
           locals: { budget: Budget.new,
                     budget_ledgers: [BudgetLedger.new],
                     child_index: params[:child_index] }
  end

  def add_budget_expense
    #
    if params[:budget] && params[:date_increment]
      exp_params = budget_params[:budget_expenses_attributes]
      inc = increment(params[:date_increment])
      start_date = Date.parse(exp_params[:date]) + inc
      end_date = (start_date + 1.year).beginning_of_year
      #
      expenses = expenses_over_date_range(start_date, end_date, inc, exp_params)
    else
      expenses = [BudgetExpense.new]
    end
    #
    render partial: 'budget_expense',
           locals: { budget: Budget.new,
                     budget_expenses: expenses,
                     child_index: params[:child_index].to_i }
  end

  private

  def set_budget
    @budget = Budget.find(params[:id])
  end

  def increment(inc_string)
    inc, unit = inc_string.split('.')
    inc.to_i.send(unit)
  end

  def expenses_over_date_range(start_date, end_date, increment, exp_params)
    date_range = (start_date.to_datetime.to_i)..(end_date.to_datetime.to_i)
    #
    date_range.step(increment).map do |date|
      exp_params[:date] = Time.zone.at(date)
      BudgetExpense.new(exp_params)
    end
  end

  def budget_params
    params.require(:budget).permit(
      :name,
      :description,
      :initial_balance,
      :start_date,
      :end_date,
      budget_ledgers_attributes:
        %i[ledger_id id _destroy],
      budget_expenses_attributes:
        %i[date description amount comments id _destroy]
    )
  end
end
