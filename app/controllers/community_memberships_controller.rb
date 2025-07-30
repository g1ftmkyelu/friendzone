class CommunityMembershipsController < ApplicationController
  before_action :require_login
  before_action :set_community

  def create
    @membership = @community.community_memberships.build(user: current_user, status: 'pending')
    if @membership.save
      redirect_to @community, notice: 'Request to join community sent.'
    else
      redirect_to @community, alert: 'Unable to send join request.'
    end
  end

  def update
    @membership = @community.community_memberships.find(params[:id])
    # Only the community creator can accept/decline requests
    if @community.creator == current_user && @membership.update(status: 'accepted')
      redirect_to @community, notice: 'Membership request accepted.'
    else
      redirect_to @community, alert: 'Unable to accept membership request.'
    end
  end

  def destroy
    @membership = @community.community_memberships.find(params[:id])
    # User can leave, or creator can remove
    if @membership.user == current_user || @community.creator == current_user
      @membership.destroy
      redirect_to @community, notice: 'Membership removed.'
    else
      redirect_to @community, alert: 'You are not authorized to remove this membership.'
    end
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end
end