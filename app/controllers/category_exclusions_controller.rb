# Manages AJAX requests to add additional exclusion fields
class CategoryExclusionsController < ApplicationController
  # Renders out the form fields for an AJAX query
  def form_fields
    locals = {
      parent_model: Ledger.new,
      child_index: params[:child_index],
      exclusions: [CategoryExclusion.new]
    }
    render partial: 'form_fields', locals: locals
  end
end
