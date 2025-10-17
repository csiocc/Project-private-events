class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events or /events.json
def index
  @events = Event.all
  @events = @events.where(event_type: params[:type]) if params[:type].present?

  # Zeitpunkt-Filter
  case params[:date]
  when "upcoming_events"
    @events = @events.where("date >= ?", Date.today)
  when "past_events"
    @events = @events.where("date < ?", Date.today)
  end

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
    @event = Event.find(params[:id])
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
    @event = current_user.created_events.build(event_params.except(:invite_user_ids))

    if @event.save
      if params[:event][:invite_user_ids]
        params[:event][:invite_user_ids].each do |uid|
          next if @event.invites.exists?(user_id: uid)
          Invite.create!(
            event: @event,
            user_id: uid,
            answer: 0,
            title: "Einladung zu #{@event.title}",
            body: "Du wurdest zu diesem Event eingeladen."
          )
        end
      end

      redirect_to @event, notice: "Event und Einladungen erfolgreich erstellt!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    @event = Event.find(params[:id])
    if @event.update(event_params.except(:invite_user_ids))
      if params[:event][:invite_user_ids]
        params[:event][:invite_user_ids].each do |uid|
          next if @event.invites.exists?(user_id: uid)
          Invite.create!(
            event: @event,
            user_id: uid,
            answer: 0,
            title: "Einladung zu #{@event.title}",
            body: "Du wurdest zu diesem Event eingeladen."
          )
        end
      end
      redirect_to @event, notice: "Event erfolgreich aktualisiert!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

def event_params
  params.require(:event).permit(:title, :description, :location, :date, :event_type, invite_user_ids: [])
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
      params.require(:event).permit(:title, :description, :date, :location, :event_type, invite_user_ids: [])
    end
end
