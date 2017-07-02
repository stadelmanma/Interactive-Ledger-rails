# Manages ledger views and user interactions
class LedgersController < ApplicationController
  include TransactionTotals

  before_action :set_ledger

  def index
    @page_heading = 'Listing Available Ledgers'
    @page_links = [
      { name: 'New Ledger', url: new_ledger_path }
    ]
    @ledgers = Ledger.all
  end

  def show
    @page_heading = "Ledger: #{@ledger.name}"
    @page_links = [
      { name: 'Back', url: ledgers_path },
      { name: 'Upload Data', url: [:edit, @ledger] },
      { name: 'View All Uploads', url: [@ledger, :ledger_uploads] },
      { name: 'Download Ledger', url: "#{ledger_path}/download",
        options: { method: 'get', data: { turbolinks: false } } }
    ]
    @transactions = Transaction.where(ledger_id: @ledger.id).order(date: :asc)
    @column_names = Transaction.display_columns
    @totals = create_totals_hash(@transactions)
    @totals_column_names = totals_column_names
  end

  def new
    @page_heading = 'New Ledger'
    @page_links = [
      { name: 'Back', url: ledgers_path }
    ]
    @ledger = Ledger.new
  end

  def edit
    @page_heading = 'Edit Ledger'
    @page_links = [
      { name: 'Back', url: ledgers_path }
    ]
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
    @ledger.destroy
    redirect_to ledgers_path
  end

  def download
    send_data @ledger.download_data, filename: "#{@ledger.name}.txt"
  end

  private

  def set_ledger
    @ledger = Ledger.find(params[:id]) if params[:id].present?
  end

  def ledger_params
    params.require(:ledger).permit(
      :name,
      :data_source,
      ledger_uploads_attributes: %i[data_source upload_format account]
    )
  end
end
