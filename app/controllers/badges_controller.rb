# frozen_string_literal: true

class BadgesController < ApplicationController
  load_and_authorize_resource

  def index
    @badges = Badge.all
  end

  def show; end

  def create
    @badge = Badge.new(badge_params)
    respond_to do |format|
      if @badge.save
        format.json { render :show, status: :created, location: @badge }
      else
        format.json { render json: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @badge.update(badge_params)
        format.html { redirect_to @badge, notice: 'Badge was successfully updated.' }
        format.json { render :show, status: :ok, location: @badge }
      else
        format.html { render :edit }
        format.json { render json: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @badge.destroy
    respond_to do |format|
      format.html { redirect_to badges_url, notice: 'Badge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # def set_badge
  #   @badge = Badge.find(params[:id])
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  def badge_params
    params.require(:badge).permit(:name, :description)
  end
end
