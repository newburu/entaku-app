class SeatingChartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :require_event_owner!

  def show
    @participants_without_seat = @event.participants.where.not(id: @event.seats.select(:participant_id))
    @seating_tables = @event.seating_tables.includes(seats: :participant)
  end

  def update
    # This will be used to save the seat assignments
    seat_assignments = params.require(:seating_chart).permit(seats: [:id, :participant_id])

    seat_assignments[:seats].each do |seat_data|
      seat = Seat.find(seat_data[:id])
      # Make sure the seat belongs to the event to prevent malicious data
      if @event.seats.include?(seat)
        seat.update(participant_id: seat_data[:participant_id].presence)
      end
    end

    redirect_to event_seating_chart_path(@event), notice: 'Seating chart updated.'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def require_event_owner!
    redirect_to root_path, alert: "You are not the owner of this event." unless @event.user == Current.user
  end
end
