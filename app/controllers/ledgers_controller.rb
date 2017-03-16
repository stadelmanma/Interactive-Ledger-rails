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
      @ledger.ledger_uploads.last.upload_data
      redirect_to @ledger
    else
      render 'new'
    end
  end

  def update
    @ledger = Ledger.find(params[:id])

    if @ledger.update(ledger_params)
      @ledger.ledger_uploads.last.upload_data
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

  def ledger_params
    #
    lp = params.require(:ledger).permit(
      :name,
      :data_source,
      :ledger_uploads_attributes => [:data_source]
    )
    lp[:ledger_uploads_attributes] = {0 => lp[:ledger_uploads_attributes]}
    #
    return lp
  end
end
