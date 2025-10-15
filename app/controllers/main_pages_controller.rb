class MainPagesController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :set_main_page, only: %i[ show edit update destroy ]

  # GET /main_pages or /main_pages.json
  def index
    if user_signed_in?
      @news_feeds = Post.where(user_id: current_user.following.pluck(:id)).order(created_at: :desc)
    end
  end

  def privacy_policy; end
  def terms_of_service; end

  # GET /main_pages/1 or /main_pages/1.json
  def show
  end

  # GET /main_pages/new
  def new
    @main_page = MainPage.new
  end

  # GET /main_pages/1/edit
  def edit
  end

  # POST /main_pages or /main_pages.json
  def create
    @main_page = MainPage.new(main_page_params)

    respond_to do |format|
      if @main_page.save
        format.html { redirect_to @main_page, notice: "Main page was successfully created." }
        format.json { render :show, status: :created, location: @main_page }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @main_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /main_pages/1 or /main_pages/1.json
  def update
    respond_to do |format|
      if @main_page.update(main_page_params)
        format.html { redirect_to @main_page, notice: "Main page was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @main_page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @main_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /main_pages/1 or /main_pages/1.json
  def destroy
    @main_page.destroy!

    respond_to do |format|
      format.html { redirect_to main_pages_path, notice: "Main page was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_main_page
      @main_page = MainPage.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def main_page_params
      params.fetch(:main_page, {})
    end
end
