class AttemptsController < ApplicationController
  load_and_authorize_resource	:attempt

  def index
      @attempts = Attempt.paginate(page: params[:page], per_page: params[:per_page])
      @attempts = @attempts.joins(:product)
      order = 'asc' == params[:order] ? :asc : :desc
  @attempts = @attempts.order(created_at: order)
      # if params[:user_id] && params[:product_id] # both options could be present
      #     @attempts = @attempts.where('user_id = ? AND product_id = ?', params[:user_id], params[:product_id])
      # elsif params[:user_id] # External IDs are not gauranteed to be unique, so we may have multiple results.
      #     @attempts = @attempts.where('user_id = ?', params[:user_id])
      # els
  if params[:product_id] # empty string is a valid value, so we just need the special case for any explicit product_id value.
          @attempts = @attempts.where('product_id = ?', params[:product_id])
      end
      @attempts = @attempts.search_by_name(params[:filter]) if params[:filter]
  end

  def show
  end

end
