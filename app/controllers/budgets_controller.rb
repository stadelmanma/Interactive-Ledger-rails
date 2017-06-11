# Manages the view-model interface for Budgets
class BudgetsController < ApplicationController
  before_action :set_budget, only: %i[show edit update destroy]

  # GET /budgets
  # GET /budgets.json
  def index
    @budgets = Budget.all
  end

  # GET /budgets/1
  # GET /budgets/1.json
  def show; end

  # GET /budgets/new
  def new
    @budget = Budget.new
  end

  # GET /budgets/1/edit
  def edit; end

  # POST /budgets
  # POST /budgets.json
  def create
    @budget = Budget.new(budget_params)

    respond_to do |format|
      if @budget.save
        format.html do
          redirect_to @budget, notice: 'Budget was successfully created.'
        end
        format.json { render :show, status: :created, location: @budget }
      else
        format.html { render :new }
        format.json do
          render json: @budget.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /budgets/1
  # PATCH/PUT /budgets/1.json
  def update
    respond_to do |format|
      if @budget.update(budget_params)
        format.html do
          redirect_to @budget, notice: 'Budget was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @budget }
      else
        format.html { render :edit }
        format.json do
          render json: @budget.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /budgets/1
  # DELETE /budgets/1.json
  def destroy
    @budget.destroy
    respond_to do |format|
      format.html do
        redirect_to budgets_url, notice: 'Budget was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  def set_budget
    @budget = Budget.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(
      :name,
      :description,
      budget_expenses_attributes: %i[data_source upload_format account]
    )
  end
end
