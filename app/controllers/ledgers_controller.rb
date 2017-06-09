# Manages ledger views and user interactions
class LedgersController < ApplicationController
  include TransactionTotals

  def index
    @ledgers = Ledger.all
  end

  def show
    @ledger = Ledger.find(params[:id])
    @transactions = Transaction.where(ledger_id: @ledger.id).order(date: :asc)
    @column_names = Transaction.display_columns
    @totals = create_totals_hash(@transactions)
    @totals_column_names = totals_column_names
  end

  def new
    @ledger = Ledger.new
  end

  def edit
    @ledger = Ledger.find(params[:id])
  end

  def create
    @ledger = Ledger.new(ledger_params)

    if @ledger.save
      # upload any new data and if so, go to the upload#edit view
      upload = @ledger.upload_data
      if upload
        redirect_to [:edit, @ledger, upload]
      else
        redirect_to @ledger
      end
    else
      render 'new'
    end
  end

  def update
    @ledger = Ledger.find(params[:id])

    if @ledger.update(ledger_params)
      # upload any new data and if so, go to the upload#edit view
      upload = @ledger.upload_data
      if upload
        redirect_to [:edit, @ledger, upload]
      else
        redirect_to @ledger
      end
    else
      render 'edit'
    end
  end

  def destroy
    @ledger = Ledger.find(params[:id])
    @ledger.destroy

    redirect_to ledgers_path
  end

  def download
    @ledger = Ledger.find(params[:id])
    send_data @ledger.download_data, filename: "#{@ledger.name}.txt"
  end

  private

  def ledger_params
    params.require(:ledger).permit(
      :name,
      :data_source,
      ledger_uploads_attributes: %i[data_source upload_format account]
    )
  end
end
