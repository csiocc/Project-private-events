class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events or /events.json
def index
  @events = Event.all
  @events = @events.where(event_type: params[:type]) if params[:type].present?

  # Sortierung nach 'date' oder Fallback zu 'created_at'
  case params[:sort]
  when "date_asc"
    @events = @events.order(date: :asc)
  when "date_desc"
    @events = @events.order(date: :desc)
  else
    @events = @events.order(created_at: :desc)
  end

  respond_to do |format|
    format.html # events/index.html.erb
    format.json do
      render json: @events.as_json(only: [:id, :title, :description, :event_type, :date])
    end
  end
end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      redirect_to @event, notice: "Event erfolgreich erstellt!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event erfolgreich aktualisiert!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event gelöscht."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :description, :date, :location, :event_type)
    end
end
