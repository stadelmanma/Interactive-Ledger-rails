# Manages the view-model interface for Budgets
class BudgetsController < ApplicationController
  include TransactionTotals
  before_action :set_budget, only: %i[show edit update destroy]

  def index
    @page_heading = 'Budgets'
    @page_links = [
      { name: 'New Budget', url: new_budget_path }
    ]
    @budgets = Budget.all
  end

  def show
    @page_heading = "Budget: #{@budget.name}"
    @page_links = [
      { name: 'Edit', url: edit_budget_path(@budget) },
      { name: 'Back', url: budgets_path }
    ]
    @transactions = @budget.transactions.order(date: :asc)
    @totals = create_totals_hash(@transactions)
  end

  def new
    @page_heading = 'New Budget'
    @page_links = [
      { name: 'Back', url: budgets_path }
    ]
    @budget = Budget.new
  end

  def edit
    @page_heading = 'Editing Budget'
    @page_links = [
      { name: 'Show', url: @budget },
      { name: 'Back', url: budgets_path }
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
    render partial: 'budget_expense',
           locals: { budget: Budget.new,
                     budget_expenses: [BudgetExpense.new],
                     child_index: params[:child_index] }
  end

  private

  def set_budget
    @budget = Budget.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(
      :name,
      :description,
      :initial_balance,
      budget_ledgers_attributes:
        %i[ledger_id id _destroy],
      budget_expenses_attributes:
        %i[date description amount comments id _destroy]
    )
  end
end
