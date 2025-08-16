class MySeatingAssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_attendee!

  def show
    # An attendee might be a participant in many events.
    # We need to decide which event's seating chart to show.
    # Let's assume for now they want to see the assignment for the most recent event
    # they are a part of. A better implementation might list all events.
    @participation = Current.user.event_participations.joins(:event).order('events.date DESC').first

    if @participation
      @event = @participation.event
      @seat = @participation.seat
      @seating_tables = @event.seating_tables.includes(seats: :participant)
    else
      # Render a page indicating they are not part of any event yet.
    end
  end

  private

  def require_attendee!
    redirect_to root_path, alert: "You must be an attendee to view your seat." unless Current.user.attendee?
  end
end
