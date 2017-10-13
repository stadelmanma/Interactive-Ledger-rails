# Manages ledger views and user interactions
class LedgersController < ApplicationController
  include LedgerSummary
  include TransactionTotals

  before_action :set_ledger

  def index
    redirect_to root_path
  end

  def show
    @page_heading = "Ledger: #{@ledger.name}"
    @page_links = ledger_page_links
    @page_links[0][:url] = root_path
    #
    @transactions = @ledger.transactions.order(date: :asc)
    @column_names = Transaction.display_columns
    @totals = create_totals_hash(@transactions)
    @totals_column_names = totals_column_names
  end

  def new
    @page_heading = 'New Ledger'
    @page_links = [
      { name: 'Back', url: root_path }
    ]
    @ledger = Ledger.new
  end

  def edit
    @page_heading = 'Edit Ledger'
    @page_links = ledger_page_links
  end

  def summary
    @page_heading = "Ledger: #{@ledger.name} Summary"
    @page_links = ledger_page_links
    @totals = create_totals_hash(@ledger.transactions.order(date: :asc))
    @overall_totals = generate_totals(@ledger, @totals)
  end

  def download
    send_data @ledger.download_data, filename: "#{@ledger.name}.txt"
  end

  def categories
    @categories = @ledger.transactions.categories
  end

  def subcategories
    @subcategories = @ledger.transactions.subcategories
  end

  def create
    @ledger = Ledger.new(ledger_params)
    #
    if @ledger.save
      upload_and_redirect
    else
      render 'new'
    end
  end

  def update
    if @ledger.update(ledger_params)
      upload_and_redirect
    else
      render 'edit'
    end
  end

  def destroy
    @ledger.destroy
    redirect_to root_path
  end

  private

  def set_ledger
    @ledger = Ledger.find(params[:id]) if params[:id].present?
  end

  def ledger_params
    params.require(:ledger).permit(
      :name,
      :data_source,
      category_exclusions_attributes:
        %i[category excluded_from ledger_id id _destroy],
      ledger_uploads_attributes: %i[data_source upload_format account]
    )
  end

  def ledger_page_links
    [
      { name: 'Back', url: @ledger },
      { name: 'Upload Data', url: [:edit, @ledger] },
      { name: 'View All Uploads', url: [@ledger, :ledger_uploads] },
      { name: 'View Summary', url: [:summary, @ledger] },
      { name: 'Download Ledger', url: "#{ledger_path}/download",
        options: { method: 'get', data: { turbolinks: false } } }
    ]
  end

  # upload any new data and if so, go to the upload#edit
  def upload_and_redirect
    upload = @ledger.upload_data
    if upload
      redirect_to [:edit, @ledger, upload]
    else
      redirect_to @ledger
    end
  end
end
