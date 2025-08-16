class ParticipantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :require_event_owner!

  def create
    @participant = @event.participants.build(participant_params)
    if @participant.save
      redirect_to @event, notice: 'Participant was successfully added.'
    else
      # How to handle this error? Re-render the event show page.
      # We need to load all the other data for the event show page again.
      render 'events/show', status: :unprocessable_entity
    end
  end

  def destroy
    @participant = @event.participants.find(params[:id])
    @participant.destroy
    redirect_to @event, notice: 'Participant was successfully removed.'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def require_event_owner!
    redirect_to root_path, alert: "You are not the owner of this event." unless @event.user == Current.user
  end

  def participant_params
    params.require(:participant).permit(:email)
  end
end
