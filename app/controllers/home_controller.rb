# handles requests to the home page
class HomeController < ApplicationController
  def home
    @page_links = [
      { name: 'New Budget', url: new_budget_path },
      { name: 'New Ledger', url: new_ledger_path },
      { name: 'Show Initializers', url: '' },
      { name: 'Edit Initializers', url: edit_category_initializers_path,
        options: { class: 'hidden' } }
    ]
  end
end
