# Manages views related to transactions
class TransactionsController < ApplicationController
  before_action :set_transaction

  def show; end

  def duplicates
    @page_links = [
      { name: 'Ledger Upload',
        url: [@transaction.ledger, @transaction.ledger_upload] }
    ]
    @column_names = Transaction.display_columns
  end

  def destroy
    url = if request.referer.include?("/transactions/#{@transaction.id}")
            @transaction.ledger_upload
          else
            :back
          end
    #
    @transaction.destroy
    redirect_to url
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id]) if params[:id].present?
  end
end
