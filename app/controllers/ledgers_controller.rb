class LedgersController < ApplicationController

  def index
    @ledgers = Ledger.all
  end

  def show
    @ledger = Ledger.find(params[:id])
    @column_names = Transaction.display_columns
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
      upload_data
      redirect_to @ledger
    else
      render 'new'
    end
  end

  def update
    @ledger = Ledger.find(params[:id])

    if @ledger.update(ledger_params)
      upload_data
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

  def upload_data
    # pull out data source param and return if it's not set
    @ledger.data_source = params.require(:ledger)[:data_source]
    return if @ledger.data_source.blank?

    # process and upload new data
    transactions = @ledger.load_data
    Transaction.import transactions
    if @ledger.persisted?
      @ledger.touch
    end
  end

  def ledger_params
    params.require(:ledger).permit(:name, :data_source)
  end
end
