import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { patch } from '@rails/request.js'

export default class extends Controller {
  static targets = ["participantList", "table", "seat"]

  connect() {
    this.initParticipantListSortable();
    this.initTableDragAndDrop();
    this.initSeatSortable();
  }

  initParticipantListSortable() {
    new Sortable(this.participantListTarget, {
      group: 'shared', // set both lists to same group
      animation: 150,
      ghostClass: 'blue-background-class'
    });
  }

  initTableDragAndDrop() {
    this.tableTargets.forEach(table => {
      new Sortable(table, {
        group: 'tables',
        handle: '.handle', // Draggable handle element
        animation: 150,
        onEnd: this.onTableDragEnd.bind(this)
      });
    });
  }

  initSeatSortable() {
    this.seatTargets.forEach(seat => {
      new Sortable(seat, {
        group: 'shared',
        animation: 150,
        onAdd: this.onSeatAdd.bind(this)
      });
    });
  }

  onTableDragEnd(event) {
    const tableElement = event.item;
    const eventId = tableElement.dataset.eventId;
    const tableId = tableElement.dataset.tableId;
    const url = `/events/${eventId}/seating_tables/${tableId}`;

    // This is a simplified position update.
    // A real implementation would need to get the precise pixel position.
    // For now, we'll just use the sortable index.
    const newPosition = {
      x_position: event.newIndex * 100, // Dummy position
      y_position: 100 // Dummy position
    };

    patch(url, { body: JSON.stringify({ seating_table: newPosition }), responseKind: 'json' });
  }

  onSeatAdd(event) {
    const seatElement = event.to;
    const participantElement = event.item;

    const eventId = seatElement.dataset.eventId;
    const chartUrl = `/events/${eventId}/seating_chart`;

    const seatId = seatElement.dataset.seatId;
    const participantId = participantElement.dataset.participantId;

    // This is a simplified update. A real app would send all seat assignments
    // in one go with a "Save" button.
    const seatUpdate = {
      seats: [
        { id: seatId, participant_id: participantId }
      ]
    }

    patch(chartUrl, { body: JSON.stringify({ seating_chart: seatUpdate }), responseKind: 'json' });
  }
}
