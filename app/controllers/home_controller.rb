# handles requests to the home page
class HomeController < ApplicationController
  def home
    @page_links = [
      { name: 'Edit Initializers', url: edit_category_initializers_path }
    ]
  end
end
