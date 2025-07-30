class CommunitiesController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_community, only: [:show, :edit, :update, :destroy]
  before_action :authorize_creator!, only: [:edit, :update, :destroy]

  def index
    @communities = Community.all.order(created_at: :desc)
  end

  def show
    @memberships = @community.community_memberships.accepted.includes(:user)
    @is_member = logged_in? ? @community.members.include?(current_user) : false
    @membership_status = logged_in? ? current_user.community_membership_status_with(@community) : nil
  end

  def new
    @community = current_user.created_communities.build
  end

  def create
    @community = current_user.created_communities.build(community_params)
    if @community.save
      # Automatically make the creator a member
      @community.community_memberships.create(user: current_user, status: 'accepted')
      redirect_to @community, notice: 'Community was successfully created.'
    else
      flash.now[:alert] = 'Community could not be created.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @community.update(community_params)
      redirect_to @community, notice: 'Community was successfully updated.'
    else
      flash.now[:alert] = 'Community could not be updated.'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @community.destroy
    redirect_to communities_path, notice: 'Community was successfully deleted.'
  end

  private

  def set_community
    @community = Community.find(params[:id])
  end

  def community_params
    params.require(:community).permit(:name, :description)
  end

  def authorize_creator!
    unless @community.creator == current_user
      flash[:alert] = 'You are not authorized to manage this community.'
      redirect_to communities_path
    end
  end
end