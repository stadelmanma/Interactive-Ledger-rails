class LedgersController < ApplicationController

  def index
    @ledgers = Ledger.all
  end
  
  def show
    @ledger = Ledger.find(params[:id])
    path = Rails.root.to_s + '/' + @ledger.data_source
    @data = File.read(path).split(/\n/)
    @header = @data.shift
    @data.map! {|trans| trans.split(/\t/)}
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
      redirect_to @ledger
    else
      render 'new'
    end
  end
  
  def update
    @ledger = Ledger.find(params[:id])
    
    if @ledger.update(ledger_params)
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
    params.require(:ledger).permit(:name, :data_source)
  end
end
