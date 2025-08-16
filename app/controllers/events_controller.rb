class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_organizer!, except: [:show, :index]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :require_event_owner!, only: [:edit, :update, :destroy]

  def my_events
    @events = Current.user.events.order(date: :desc)
  end

  def show
    @participant = Participant.new
  end

  def new
    @event = Event.new
  end

  def create
    @event = Current.user.events.build(event_params)
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to my_events_path, notice: 'Event was successfully destroyed.'
  end

  private

  def require_organizer!
    redirect_to root_path, alert: "You must be an organizer to do that." unless Current.user.organizer?
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def require_event_owner!
    redirect_to root_path, alert: "You are not the owner of this event." unless @event.user == Current.user
  end

  def event_params
    params.require(:event).permit(:title, :date)
  end
end
