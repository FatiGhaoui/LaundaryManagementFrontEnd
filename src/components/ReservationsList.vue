<template>
  <div class="reservation-list pt-3">
    
    <reservations-list-item v-for="reservation in reservations" :reservation="reservation"
      :key="reservation.reservationId" @reservation-updated="updateReservation" @reservation-deleted="deleteReservation">
    </reservations-list-item>

    <div class="d-flex mb-2">
      <button type="button" class="btn btn-primary" :class="{ created: isCreated }" @click="openCreateModal"> Create new
        reservation</button>
    </div>
    
    <template v-if="isCreated">
      <div class="modal-background">
        <div class="modal-dialog">
          <div class="modal-content">
            <label for="editName">User:</label>
            <input type="string" id="editDate" v-model="createdReservation.reservationUser">

            <label for="editDate">Date:</label>
            <input type="date" id="editDate" v-model="createdReservation.reservationDate">

            <label for="editStartTime">Start Time:</label>
            <input type="time" id="editStartTime" v-model="createdReservation.reservationStartTime">

            <label for="editEndTime">End Time:</label>
            <input type="time" id="editEndTime" v-model="createdReservation.reservationEndTime">

            <div class="details d-flex">
              <button @click="createReservation" class="btn btn-primary">Create Reservation</button>
              <button @click="openCreateModal" class="btn btn-danger me-2">Cancel</button>
            </div>
          </div>

          <template v-if="showUnexpectedError">
          <div class="alert alert-danger" role="alert">
            An unexpected problem has occurred, the reservation could not be created
            because the user is not available.(Required field)
          </div>
        </template>
        </div>        
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

    async createReservation() {

      try {

        if (!this.createdReservation.reservationUser) {
          this.showUnexpectedError = true;
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
