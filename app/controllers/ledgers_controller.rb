class LedgersController < ApplicationController

  def index
    @ledgers = Ledger.all
  end
  
end
