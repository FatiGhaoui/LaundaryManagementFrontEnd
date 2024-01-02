<template>
  <div class="reservation-list pt-3">

    <reservations-list-item v-for="reservation in reservations" :reservation="reservation"
      :key="reservation.reservationId" @reservation-updated="updateReservation" @reservation-deleted="deleteReservation">
    </reservations-list-item>

    <div class="d-flex mb-2">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal"
        :class="{ created: isCreated }" @click="openCreateModal">
        Create new reservation
      </button>
    </div>

    <template v-if="isCreated">
      <div class="modal fade show d-block" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel"
        aria-hidden="true" style="z-index: 1050;">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel">New Reservation</h5>
              <button type="button" class="btn-close" aria-label="Close" @click="openCreateModal"></button>
            </div>
            <div class="modal-body">
              <form>
                <div class="mb-3">
                  <label for="editName" class="form-label">User:</label>
                  <input type="text" class="form-control" id="editName" v-model="createdReservation.reservationUser">
                </div>
                <div class="mb-3">
                  <label for="editDate" class="form-label">Date:</label>
                  <input type="date" class="form-control" id="editDate" v-model="createdReservation.reservationDate">
                </div>
                <div class="mb-3">
                  <label for="editStartTime" class="form-label">Start Time:</label>
                  <input type="time" class="form-control" id="editStartTime"
                    v-model="createdReservation.reservationStartTime">
                </div>
                <div class="mb-3">
                  <label for="editEndTime" class="form-label">End Time:</label>
                  <input type="time" class="form-control" id="editEndTime"
                    v-model="createdReservation.reservationEndTime">
                </div>
              </form>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-primary" @click="createReservation">Create Reservation</button>
              <button type="button" class="btn btn-danger" @click="openCreateModal">Cancel</button>
            </div>

          </div>
        </div>
      </div>
    </template>

    <template v-if="showUnexpectedError">
      <div class="alert alert-danger" role="alert" style="border: 1px solid red;
       background-color: #ffeaea; color: red; padding: 10px; margin-top: 10px; z-index: 1051;">
        <strong>Error: </strong>An unexpected problem has occurred, the reservation could not be created because the user
        is not available.
        <strong>(Required field)</strong>
      </div>
    </template>
  </div>
</template>

<script>
import axios from 'axios';
import { API_HOST } from '../config';
import ReservationsListItem from './ReservationsListItem.vue';

export default {
  components: {
    ReservationsListItem
  },
  name: 'ReservationsList',
  data: function () {
    return {
      reservations: [],
      isCreated: false,
      showUnexpectedError: false,
      createdReservation: {
        reservationUser: '',
        reservationDate: '',
        reservationStartTime: '',
        reservationEndTime: ''
      },
      initialReservation: {}
    }
  },
  created: async function () {
    let response = await axios.get(`${API_HOST}/api/reservation`, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Allow-Credentials': 'true'
      }
    });
    let reservations = response.data;
    this.reservations = reservations;
  },
  methods: {
    openCreateModal() {
      this.isCreated = !this.isCreated;
      this.showUnexpectedError = false;
      this.resetForm();
    },
    resetForm() {
      this.createdReservation = { ...this.initialReservation };
    },

    updateReservation(newReservation) {
      /* Find the place of reservation object with the same Id in the array, and replace it */
      let index = this.reservations.findIndex(reservation => reservation.reservationId === newReservation.reservationId);
      console.log("update reservation", newReservation);
      this.reservations.splice(index, 1, newReservation);
    },

    deleteReservation(deletedReservationId) {
      let index = this.reservations.findIndex(reservation => reservation.reservationId === deletedReservationId);
      if (index !== -1) {
        this.reservations.splice(index, 1);
      }
    },
    focusUserInput() {
      document.getElementById('editName').focus();
    },

    async createReservation() {

      try {

        if (!this.createdReservation.reservationUser) {
          this.showUnexpectedError = true;
          this.focusUserInput();
          // Ocultar el mensaje de error después de 2 segundos
          setTimeout(() => {
            this.showUnexpectedError = false;
          }, 2000);
          return;
        }

        const response = await axios.post(`${API_HOST}/api/reservation`, this.createdReservation);

        if (response.status === 200) {
          const newReservation = response.data;

          // Asigna los valores de la nueva reserva a this.reservation (si es necesario)
          this.reservation = {
            reservationUser: newReservation.reservationUser,
            reservationDate: newReservation.reservationDate,
            reservationStartTime: newReservation.reservationStartTime,
            reservationEndTime: newReservation.reservationEndTime,
          };

          // Cierra el modal después de la creación exitosa
          this.isCreated = false;
          this.showUnexpectedError = false;
          this.loadReservations();

        } else {
          console.error('Server responded with a non-successful status:', response.status);
          this.showUnexpectedError = true;
        }
      } catch (error) {
        console.error('Error occurred while making the request:', error);

      }
    },

    async loadReservations() {
      try {
        let response = await axios.get(`${API_HOST}/api/reservation`);
        let reservations = response.data;
        this.reservations = reservations;
        this.showUnexpectedError = false;
      } catch (error) {
        console.error('Error occurred while loading reservations:', error);
      }
    }
  }
}
</script>

<style lang="scss">
.modal-background {
  position: fixed;
  background-color: rgba(0, 0, 0, 0.3);
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}
</style>
