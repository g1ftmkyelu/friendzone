class PagesController < ApplicationController
  def index
    @pages = Page.all.order(likes_count: :desc)
  end

  def show
    @page = Page.find(params[:id])
  end
end