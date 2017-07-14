Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :budgets do
    get 'add-budget-ledger-select' => 'budgets#add_budget_ledger_select',
        on: :collection
    get 'add-budget-expense' => 'budgets#add_budget_expense',
        on: :collection
  end

  resources :ledgers do
    resources :ledger_uploads do
      get 'download', on: :member
    end
    get 'download', on: :member
  end

  root 'home#home'
end
