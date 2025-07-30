class MessagesController < ApplicationController
  before_action :require_login
  before_action :set_conversation_user, only: [:show] # Removed :create from here
  before_action :set_conversation_users_list, only: [:index, :show, :create]

  def index
    # @conversation_users is already set by set_conversation_users_list
  end

  def show
    @messages = Message.where(
      "(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
      current_user.id, @conversation_user.id, @conversation_user.id, current_user.id
    ).order(:created_at)
    
    # Mark messages as read
    @messages.where(receiver: current_user, read_at: nil).update_all(read_at: Time.current)
    
    @message = Message.new
  end

  def create
    # Find the receiver from the form parameters
    receiver = User.find(message_params[:receiver_id])

    @message = current_user.sent_messages.build(message_params.except(:receiver_id))
    @message.receiver = receiver

    if @message.save
      redirect_to message_path(receiver), notice: 'Message sent!'
    else
      # If save fails, re-populate @conversation_user and @messages for rendering :show
      @conversation_user = receiver # Set @conversation_user for rendering
      @messages = Message.where(
        "(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
        current_user.id, @conversation_user.id, @conversation_user.id, current_user.id
      ).order(:created_at)
      flash.now[:alert] = 'Message could not be sent.'
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_conversation_user
    @conversation_user = User.find(params[:id])
  end

  def set_conversation_users_list
    # Get all users current_user has messaged or been messaged by
    sent_to_users = current_user.sent_messages.pluck(:receiver_id)
    received_from_users = current_user.received_messages.pluck(:sender_id)
    
    @conversation_users = User.where(id: (sent_to_users + received_from_users).uniq)
                              .where.not(id: current_user.id)
                              .order(:username)
  end

  def message_params
    params.require(:message).permit(:content, :receiver_id) # Permit receiver_id
  end
end