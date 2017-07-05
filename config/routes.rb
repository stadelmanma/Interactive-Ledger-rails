Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'interactive_financial_ledger/index'

  resources :budgets do
    get 'add-budget-ledger-select' => 'budgets#add_budget_ledger_select',
        on: :collection
  end

  resources :ledgers do
    resources :ledger_uploads do
      get 'download', on: :member
    end
    get 'download', on: :member
  end

  root 'ledgers#index'
end
