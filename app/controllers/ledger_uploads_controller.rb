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
  end

  def destroy
    @ledger = Ledger.find(params[:ledger_id])
    @upload = LedgerUpload.find(params[:id])
    @upload.destroy
    redirect_to [@ledger, :ledger_uploads]
  end
end
