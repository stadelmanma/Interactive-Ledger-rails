# Manages ledger views and user interactions
class LedgerUploadsController < ApplicationController
  include TransactionTotals

  before_action :set_upload

  def index
    @page_heading = "Listing Uploads For Ledger #{@ledger.name}"
    @page_links = [
      { name: 'Show Ledger', url: @ledger },
      { name: 'Upload Data', url: [:edit, @ledger] }
    ]
    @uploads = @ledger.ledger_uploads
  end

  def show
    @page_heading = "Data Upload From: #{@upload.data_source}"
    @page_links = [
      { name: 'View Ledger', url: @ledger },
      { name: 'View All Uploads', url: [@ledger, :ledger_uploads] },
      { name: 'Edit Upload', url: [:edit, @ledger, @upload] },
      { name: 'Download Data', url: [:download, @ledger, @upload],
        options: { method: 'get', data: { turbolinks: false } } }
    ]
    @totals = {}
    @column_names = Transaction.display_columns
  end

  def edit
    @page_heading = 'Edit Ledger Upload'
    @page_links = [
      { name: 'View Ledger', url: @ledger },
      { name: 'View All Uploads', url: [@ledger, :ledger_uploads] },
      { name: 'View Upload', url: [@ledger, @upload] }
    ]
  end

  def update
    if @upload.update(upload_params)
      redirect_to [@ledger, @upload]
    else
      render 'edit'
    end
  end

  def destroy
    @upload.destroy
    redirect_to [@ledger, :ledger_uploads]
  end

  def download
    filename = "#{@ledger.name}-#{@upload.data_source}.txt"
    send_data @upload.download_data, filename: filename
  end

  private

  def set_upload
    @ledger = Ledger.find(params[:ledger_id]) if params[:ledger_id].present?
    @upload = LedgerUpload.find(params[:id]) if params[:id].present?
  end

  def upload_params
    params.require(:ledger_upload).permit(
      transactions_attributes: %i[date description amount balance account
                                  validated category subcategory comments
                                  id _destroy]
    )
  end
end
