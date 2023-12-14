<template>
  <div class="reservation border border-secondary rounded p-2 mb-2" :class="{ expanded: isExpanded }">
    <div class="top-row d-flex" @click="toggleExpand">
      <div class="reservation-id fw-bold pe-3">Reservation {{ reservation.reservationId }}</div>
      <div class="reservation-User text-muted"> by user {{ reservation.reservationUser }}</div>

      <!-- Estado de la reserva -->
      <div class="open-status ms-4" :class="{ open: isReservationAvailable, closed: !isReservationAvailable }">
        <template v-if="isReservationAvailable">
          <span class="icon">&#x2B24;</span> Available
        </template>
        <template v-else>
          <div class="alert alert-danger" role="alert">
            Data is missing to create the reservation.
          </div>
          <span class="icon">&#x2716;</span> Not available
        </template>
      </div>

      <div class="expand-button ms-auto">
        {{ isExpanded ? '&#9660;' : '&#9658;' }}
      </div>
    </div>

    <template v-if="isExpanded">
      <hr />
      <!-- Botones reserva -->
      <div class="information modal-dialog">
        <div class="reservation-Date fw-bold pe-3">Date {{ reservation.reservationDate }}</div>
        <div class="reservation-Time text-muted"> Start Time: {{ reservation.reservationStartTime }}</div>
        <div class="reservation-Time text-muted"> End Time: {{ reservation.reservationEndTime }}</div>
      </div>
      <div class="details d-flex">
        <button type="button" class="btn btn-secondary me-2" :class="{ edited: isEdited }"
          @click="openEditModal">Edit</button>
        <button type="button" class="btn btn-danger me-2" :class="{ deleted: isDeleted }"
          @click="openDeleteModal">Delete</button>
      </div>

      <!-- Modal para editar la reserva -->
      <template v-if="isEdited">
        <!-- Campos para editar la fecha, hora de inicio y hora de finalización -->
        <div class="modal-background">
          <div class="modal-dialog">
            <div class="modal-content">
              <label for="editDate">Date:</label>
              <input type="date" id="editDate" v-model="editedReservation.reservationDate">

              <label for="editStartTime">Start Time:</label>
              <input type="time" id="editStartTime" v-model="editedReservation.reservationStartTime">

              <label for="editEndTime">End Time:</label>
              <input type="time" id="editEndTime" v-model="editedReservation.reservationEndTime">
              <button class="btn btn-primary" @click="updateReservation">Save Changes</button>
              <button @click="openEditModal" class="btn btn-danger me-2">Cancel</button>
            </div>
          </div>
        </div>
      </template>    

      <!-- Modal para eliminar la reserva -->
      <template v-if="isDeleted">
        <div class="modal-background">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-body">
                Are you sure you want to delete Reservation {{ reservation.reservationId }}?
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="openDeleteModal">Close</button>
                <button type="button" class="btn btn-primary" @click="deleteReservation">Confirm</button>
              </div>
            </div>
          </div>
        </div>
      </template>
    </template>
  </div>
</template>

<script>
import axios from 'axios';
import { API_HOST } from '../config';

export default {
  name: 'ReservationsListItem',
  props: ['reservation'],
  data: function () {
    return {
      isExpanded: false,
      isDeleted: false,
      isEdited: false,
      editedReservation: {
        reservationDate: '',
        reservationStartTime: '',
        reservationEndTime: ''
      }
    }
  },
  computed: {
    isReservationAvailable: function () {
      return this.reservation.reservationAvailable;
    }
  },
  methods: {
    toggleExpand() {
      this.isExpanded = !this.isExpanded;
    },

    openDeleteModal() {
      this.isDeleted = !this.isDeleted;
    },
    openEditModal() {
      this.isEdited = !this.isEdited;

      // Asignar los valores actuales de la reserva a los campos de edición
      this.editedReservation.reservationDate = this.reservation.reservationDate;
      this.editedReservation.reservationStartTime = this.reservation.reservationStartTime;
      this.editedReservation.reservationEndTime = this.reservation.reservationEndTime;
    },

    async updateReservation() {
      try {
        const response = await axios.put(`${API_HOST}/api/reservation/${this.reservation.reservationId}`, this.editedReservation);

        if (response.status === 200) {

          this.reservation.reservationDate = this.editedReservation.reservationDate;
          this.reservation.reservationStartTime = this.editedReservation.reservationStartTime,
            this.reservation.reservationEndTime = this.editedReservation.reservationEndTime;


          if (
            this.reservation.reservationDate &&
            this.reservation.reservationStartTime &&
            this.reservation.reservationEndTime
          ) {
            this.reservation.reservationAvailable = true;
          } else {
            this.reservation.reservationAvailable = false;
          }

          // Cierra el modal después de la actualización exitosa
          this.isEdited = false;
        } else {
          console.error('Server responded with a non-successful status:', response.status);
        }
      } catch (error) {
        console.error('Error occurred while making the request:', error);
      }
    },

    async deleteReservation() {
      try {
        const response = await axios.delete(`${API_HOST}/api/reservation/${this.reservation.reservationId}`);
        if (response.status === 200) {
          this.$emit('reservation-deleted', this.reservation.reservationId);
        } else {
          console.error('Server responded with a non-successful status:', response.status);
        }
      } catch (error) {
        console.error('Error occurred while making the request:', error);
      }
    }
  }
}
</script>


<style lang="scss" scoped>
.open-status {
  .icon {
    position: relative;
  }

  &.open {
    color: #198754;

    .icon {
      font-size: 12px;
      top: -3px;
    }
  }

  &.closed {
    color: #dc3545;
  }
}

.modal-background {
  position: fixed;
  background-color: rgba(0, 0, 0, 0.3);
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}


.reservation {
  .top-row {
    cursor: pointer;
  }
}
</style>
