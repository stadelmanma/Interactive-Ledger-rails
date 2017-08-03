# Manages views related to transactions
class TransactionsController < ApplicationController
  before_action :set_transaction

  def show; end

  def duplicates
    @column_names = Transaction.display_columns
    @transactions = [@transaction].concat(@transaction.possible_dupes)
    @totals = {}
  end

  def destroy
    @transaction.destroy
    redirect_to @transaction.ledger_upload
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id]) if params[:id].present?
  end
end
