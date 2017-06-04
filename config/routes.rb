Rails.application.routes.draw do
  get 'interactive_financial_ledger/index'

  resources :ledgers do
    resources :ledger_uploads
  end

  get 'ledgers/:id/:download', to: 'ledgers#download'

  root 'ledgers#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
