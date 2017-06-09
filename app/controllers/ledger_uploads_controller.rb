# Manages ledger views and user interactions
class LedgerUploadsController < ApplicationController
  include TransactionTotals

  def index
    @ledger = Ledger.find(params[:ledger_id])
    @uploads = @ledger.ledger_uploads
  end

  def show
    @ledger = Ledger.find(params[:ledger_id])
    @upload = LedgerUpload.find(params[:id])
    @totals = {}
    @column_names = Transaction.display_columns
  end

  def edit
    @ledger = Ledger.find(params[:ledger_id])
    @upload = LedgerUpload.find(params[:id])
  end

  def update
    @ledger = Ledger.find(params[:ledger_id])
    @upload = LedgerUpload.find(params[:id])

    if @upload.update(upload_params)
      redirect_to [@ledger, @upload]
    else
      render 'edit'
    end
  end

  def destroy
    @ledger = Ledger.find(params[:ledger_id])
    @upload = LedgerUpload.find(params[:id])
    @upload.destroy
    redirect_to [@ledger, :ledger_uploads]
  end

  def download
    @ledger = Ledger.find(params[:ledger_id])
    @upload = LedgerUpload.find(params[:id])
    #
    filename = "#{@ledger.name}-#{@upload.data_source}.txt"
    send_data @upload.download_data, filename: filename
  end

  private

  def upload_params
    params.require(:ledger_upload).permit(
      transactions_attributes: %i[date description amount balance account
                                  validated category subcategory comments
                                  id _destroy]
    )
  end
end
