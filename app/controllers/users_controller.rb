class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show edit update destroy ]


  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    if params[:id] == "sign_out"
      redirect_to root_path, alert: "Bitte benutzen Sie den Logout-Button!"
      return
    end
    @user = User.find(params[:id])
    @invites = @user.invites.includes(:event)
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
    signed_ids = Array(params[:signed_id])
    @user.photos.attach(signed_ids)
    head :ok
    log_current_user_action("user #{user.id} with email #{user.email} uploaded a new photo.")
    Rails.logger.info "Attach: #{params[:signed_id]}"
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def dating_profile_edit; end

  def owned_posts
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end
  
  def search
    term = params[:q].to_s.downcase
    users = if term.blank?
      User.all.limit(30)
    else
      User.where("LOWER(name) LIKE ? OR LOWER(email) LIKE ?", "%#{term}%", "%#{term}%").limit(30)
    end
    render json: users.select(:id, :name, :email)
  end

  # social news feed follow/unfollow methods
  
  def follow
    @user = User.find(params[:id])
    if current_user.follow(@user)
      redirect_to users_path, notice: "You are now following #{@user.name}."
    else
      redirect_to users_path, alert: "Could not follow user."
    end
  end

  def unfollow
    @user = User.find(params[:id])
    if current_user.unfollow(@user)
      redirect_to users_path, notice: "You have unfollowed #{@user.name}."
    else
      redirect_to users_path, alert: "Could not unfollow user."
    end
  end

  # dating 
  def dating_profiles
    @users = User.where.not(dating_bio: [nil, ""]).order(:name)
  end

  def dating_profile
    @user = User.find(params[:id])
  end

  def swiper
    # Zeigt ein zufälliges Profil, das der aktuelle User noch nicht geliked hat
    excluded_ids = current_user.liked_users.pluck(:id) + [current_user.id]
    @user = User.where.not(id: excluded_ids).order("RANDOM()").first
  end

  def like
    @user = User.find(params[:id])
    current_user.liked_users << @user unless current_user.liked_users.include?(@user)
    redirect_to swiper_users_path
  end

  def dislike
    @user = User.find(params[:id])
    # Optional: create a Dislike model, oder ignoriere einfach
    redirect_to swiper_users_path
  end

  def assign_random_event_invites
    # Wähle 2 zufällige Events aus der Datenbank
    events = Event.order("RANDOM()").limit(2)
    events.each do |event|
      invites.create(
        event: event,
        answer: :pending,
        title: "Automatische Einladung",
        body: "Willkommen! Du bist zu diesem Event eingeladen."
      )
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
