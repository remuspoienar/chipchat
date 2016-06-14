class ChatroomsController < ApplicationController
    
  before_action :authenticate_user!, :only => [:show]
  
  def index
    @chatrooms = Chatroom.all
    @chatroom  = Chatroom.new
  end
  
  def show
    @chatroom = Chatroom.find_by(id: params[:id])
    @users    = @chatroom.messages.map(&:user)
    @message  = Message.new
  end
  
  def create
    @chatroom = Chatroom.new(chatroom_params)
    if @chatroom.save
      respond_to do |format|
        format.html { redirect_to @chatroom }
        format.js
      end
    else
      respond_to do |format|
        flash[:notice] = {error: ["a chatroom with this topic already exists"]}
        format.html { redirect_to new_chatroom_path }
        format.js { render template: 'chatrooms/chatroom_error.js.erb'} 
      end
    end
  end
  
  private

    def chatroom_params
      params.require(:chatroom).permit(:topic)
    end
end
