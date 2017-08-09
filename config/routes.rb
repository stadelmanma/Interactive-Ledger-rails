Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#home'

  resources :budgets do
    collection do
      get 'add-budget-ledger-select'
      get 'add-budget-expense'
    end
  end

  resources :ledgers do
    resources :ledger_uploads do
      get :download, on: :member
    end
    member do
      get :download
      get :categories, format: :json
      get :subcategories, format: :json
    end
  end

  resources :transactions, only: %i[show destroy] do
    member do
      get :duplicates
      get :details
    end
  end

  resources :category_initializers, only: %i[index destroy] do
    collection do
      get :edit
      post :edit, action: :update
      get 'add-category-initializer'
    end
  end
end
