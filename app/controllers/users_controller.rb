class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      flash[:notice] = "Profil erfolgreich aktualisiert."
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "Es gab ein Problem beim Speichern. Bitte überprüfe deine Eingaben."
      render :edit, status: :unprocessable_entity
    end
  end

  def update_photo_order
    @user = current_user
    if @user.update(image_order: params[:order])
      head :ok
    else
      render json: { error: "Konnte Reihenfolge nicht speichern" }, status: :unprocessable_entity
    end
  end

  def remove_photo
    @user = current_user
    photo = @user.photos.find_by_id(params[:photo_id])
    if photo.present?
      photo.purge # ActiveStorage entfernt die Datei
      head :ok
    else
      render json: { error: "Photo not found" }, status: :not_found
    end
  end

  def attach_photo
    @user = current_user
    @user.photos.attach(params[:signed_id])
    head :ok
  end



  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

  def user_params
    params.require(:user).permit(
      :name, :email, :profile_text, :location, :gender, :show_gender_preferences,
      photos: [], image_order: []
    )
  end


end
