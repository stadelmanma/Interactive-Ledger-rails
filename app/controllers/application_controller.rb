# Place for logic common across all controllers in the app
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
