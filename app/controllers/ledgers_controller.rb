class LedgersController < ApplicationController
  include TransactionTotals

  def index
    @ledgers = Ledger.all
  end

  def show
    @ledger = Ledger.find(params[:id])
    @column_names = Transaction.display_columns
    @totals = create_totals_hash(@ledger)
    @totals_columns = totals_column_names
  end

  def new
      @ledger = Ledger.new()
  end

  def edit
    @ledger = Ledger.find(params[:id])
  end

  def create
    @ledger = Ledger.new(ledger_params)

    if @ledger.save
      @ledger.upload_data
      redirect_to @ledger
    else
      render 'new'
    end
  end

  def update
    @ledger = Ledger.find(params[:id])

    if @ledger.update(ledger_params)
      @ledger.upload_data
      redirect_to @ledger
    else
      render 'edit'
    end
  end

  def destroy
    @ledger = Ledger.find(params[:id])
    @ledger.destroy

    redirect_to ledgers_path
  end

  private

  def ledger_params
    params.require(:ledger).permit(
      :name,
      :data_source,
      :ledger_uploads_attributes => [:data_source]
    )
  end
end
