# Manages ledger views and user interactions
class LedgerUploadsController < ApplicationController
  include TransactionTotals

  def index
    @ledger = Ledger.find(params[:ledger_id])
    @uploads = @ledger.ledger_uploads
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
