class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :destroy]
  before_action :access_edit, only: [:edit, :show, :update] 
  before_action :move_to_index, only: :edit

  def index
    @prototypes = Prototype.all 
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to '/'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to '/'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def access_edit
    @prototype = Prototype.find(params[:id])
  end

  def move_to_index
    if current_user != @prototype.user
      redirect_to action: :index
    end
  end

end
