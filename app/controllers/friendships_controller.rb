class FriendshipsController < ApplicationController
  before_action :require_login

  def index
    @accepted_friendships = current_user.friendships.where(status: 'accepted').includes(:friend)
    @friends = @accepted_friendships.map(&:friend) + current_user.inverse_friendships.where(status: 'accepted').includes(:user).map(&:user)
  end

  def requests
    @incoming_requests = current_user.inverse_friendships.where(status: 'pending').includes(:user)
    @outgoing_requests = current_user.friendships.where(status: 'pending').includes(:friend)
  end

  def create
    friend = User.find(params[:friend_id])
    friendship = current_user.friendships.build(friend: friend, status: 'pending')
    if friendship.save
      redirect_to friend, notice: 'Friend request sent.'
    else
      redirect_to friend, alert: 'Unable to send friend request.'
    end
  end

  def update
    friendship = Friendship.find(params[:id])
    if friendship.friend == current_user && friendship.update(status: 'accepted')
      # Create inverse friendship for mutual acceptance
      current_user.friendships.find_or_create_by(friend: friendship.user, status: 'accepted')
      redirect_to friend_requests_path, notice: 'Friend request accepted.'
    else
      redirect_to friend_requests_path, alert: 'Unable to accept friend request.'
    end
  end

  def destroy
    friendship = Friendship.find(params[:id])
    if friendship.user == current_user || friendship.friend == current_user
      # Delete both sides of the friendship
      Friendship.where(user_id: [friendship.user_id, friendship.friend_id], friend_id: [friendship.user_id, friendship.friend_id]).destroy_all
      redirect_to friends_path, notice: 'Friend removed.'
    else
      redirect_to friends_path, alert: 'Unable to remove friend.'
    end
  end
end