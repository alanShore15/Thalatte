class ChatsController < ApplicationController

  # POST /chats/<user_id>
  # POST /chats/<user_id>.json
  def show
    @chats = user_chats params[:id], params[:start]
    if @chats.count > 0
      render json: { chats: @chats, chats_til: @chats.last.id }
    else
      render json: { chats: [], chats_til: 0 }
    end
  end

  # POST /chats
  # POST /chats.json
  def create
    @chat = Chat.new(chat_params)
    @chat.sender = current_user
      if @chat.save
        @chats = user_chats @chat.reciever_id, params[:start]
        render json: {status: :success, chats: @chats, chats_til: @chats.last.id }
      else
        render json: @chat.errors
      end
  end

  private

    def user_chats other_user_id, starting_value
      Chat.where( "id > ?", starting_value ).where("((sender_id = ? AND reciever_id = ?) OR (reciever_id = ? AND sender_id = ?))", other_user_id, current_user.id, other_user_id, current_user.id).order(:created_at)
    end

    def chat_params
      params.require(:chat).permit(:reciever_id, :message)
    end
end
