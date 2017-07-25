# handles requests to the home page
class HomeController < ApplicationController
  def home
    @page_links = [
      { name: 'Show Initializers', url: category_initializers_path }
    ]
  end
end
