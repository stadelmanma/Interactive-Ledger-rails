# handles the view and maintenance of category intializers
class CategoryInitializersController < ApplicationController
  before_action :set_initializers

  def index
    redirect_to root_path
  end

  def edit
    @page_heading = 'Editing Initializers'
    @page_links = [
      { name: 'Back', url: root_path }
    ]
  end

  def update
    #
    # update initializers from params
    category_initializers_params.each do |ci_params|
      ci_params = initializer_params(ci_params)
      #
      initializer = find_initializer(ci_params[:id].to_i)
      initializer.assign_attributes(ci_params)
    end
    #
    # save all changes
    if save_initializers
      redirect_to category_initializers_path
    else
      render 'edit'
    end
  end

  def add_category_initializer
    render partial: 'form', locals: { initializer: CategoryInitializer.new }
  end

  def destroy
    initializer = CategoryInitializer.find(params[:id])
    initializer.destroy
    redirect_to category_initializers_path
  end

  private

  def set_initializers
    @initializers = CategoryInitializer.all.order(priority: :desc).to_a
  end

  # pulls out the primary array of parameters
  def category_initializers_params
    params.require(:category_initializers)
  end

  # whitelists params for an individual initializer
  def initializer_params(params_hash)
    params_hash.permit(:pattern,
                       :category,
                       :subcategory,
                       :priority,
                       :id,
                       :_destroy)
  end

  # locates an initializer in the @initializers array using it's id
  def find_initializer(id)
    @initializers.detect(proc { create_initializer }) { |ci| ci.id == id if id }
  end

  # creates a new initializer and adds it to te @initializers array
  def create_initializer
    @initializers << CategoryInitializer.new
    @initializers.last
  end

  def save_initializers
    marked_for_destruction = []
    # collect any failed saves and records to be destroyed
    unsaved = @initializers.reject do |ci|
      if ci._destroy.present?
        marked_for_destruction << ci
      else
        ci.save
      end
    end
    # return early if any saves have failed
    return false unless unsaved.empty?
    # destroy all marked records if all saves were successful
    marked_for_destruction.each(&:destroy)
    true
  end
end
