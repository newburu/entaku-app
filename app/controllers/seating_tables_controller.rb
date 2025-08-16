class SeatingTablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :require_event_owner!

  def create
    @seating_table = @event.seating_tables.build(seating_table_params)
    if @seating_table.save
      redirect_to event_seating_chart_path(@event), notice: 'Table was successfully created.'
    else
      # How to handle this error? We should probably re-render the chart view
      # with the errors. This requires more complex handling in the view.
      # For now, just redirect with an alert.
      redirect_to event_seating_chart_path(@event), alert: "Could not create table: #{@seating_table.errors.full_messages.join(', ')}"
    end
  end

  def update
    @seating_table = @event.seating_tables.find(params[:id])
    if @seating_table.update(seating_table_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @seating_table = @event.seating_tables.find(params[:id])
    @seating_table.destroy
    redirect_to event_seating_chart_path(@event), notice: 'Table was successfully removed.'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def require_event_owner!
    redirect_to root_path, alert: "You are not the owner of this event." unless @event.user == Current.user
  end

  def seating_table_params
    params.require(:seating_table).permit(:name, :shape, :capacity, :x_position, :y_position)
  end
end
