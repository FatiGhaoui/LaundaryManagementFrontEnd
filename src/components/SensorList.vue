<template>
  <div class="sensors-list pt-3">

    <template v-if="!isCreatingSensor">
      <sensor-list-item v-for="sensor in sensors" :sensor="sensor" :key="sensor.sensorId" @sensor-updated="updateSensor"
        @sensor-deleted="deleteSensor">
        {{ sensor.sensorName }}
      </sensor-list-item>

      <div class="d-flex mb-2">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal"
          :class="{ created: isCreated }" @click="openCreateModal">
          Create new sensor
        </button>
      </div>
    </template>

    <template v-if="isCreated">

      <div class="modal fade show d-block" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel"
        aria-hidden="true" style="z-index: 1050;">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel">New Sensor</h5>
              <button type="button" class="btn-close" aria-label="Close" @click="openCreateModal"></button>
            </div>
            <div class="modal-body">
              <form>
                <input type="text" class="form-control mb-3" placeholder="Sensor name" v-model="newSensor.name">
                <select class="form-select">
                  <option selected>-- Select Sensor Type --</option>
                  <option v-for="type in sensorTypes" :value="type">{{ type }}</option>
                </select>

              </form>
            </div>

            <div class="modal-footer">
              <button type="button" class="btn btn-primary" @click="createSensor">Create</button>
              <button type="button" class="btn btn-danger" @click="openCreateModal">Cancel</button>
            </div>

          </div>
        </div>
      </div>
    </template>
    <template v-if="showUnexpectedError">
      <div class="alert alert-danger" role="alert" style="border: 1px solid red;
       background-color: #ffeaea; color: red; padding: 10px; margin-top: 10px; z-index: 1051;">
        <strong>Error: </strong>An unexpected problem has occurred, the reservation could not be created because the name
        is not available.
        <strong>(Required field)</strong>
      </div>
    </template>
  </div>
</template>



<script>
import axios from 'axios';
import { API_HOST } from '../config';
import SensorListItem from './SensorsListItem.vue';

export default {
  components: {
    SensorListItem
  },
  name: 'SensorList',
  data: function () {
    return {
      sensors: [],
      sensorTypes: [],
      isCreated: false,
      showUnexpectedError: false,
      newSensor: {
        name: '',
        type: null,
        status: true
      }
    }
  },

  created: async function () {
    await this.fetchSensorTypes();
    let response = await axios.get(`${API_HOST}/api/sensors`, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Allow-Credentials': 'true'
      }
    });
    this.sensors = response.data;
  },
  methods: {
    openCreateModal() {
      this.isCreated = !this.isCreated;
      this.showUnexpectedError = false;
      this.resetForm();
    },
    deleteSensor(deletedSensorId) {
    const index = this.sensors.findIndex(sensor => sensor.sensorId === deletedSensorId);
    if (index !== -1) {
      this.sensors.splice(index, 1);
    }
  },
    async createSensor() {
      try {
        if (!this.newSensor.name) { // Utiliza this.newSensor.name en lugar de this.createdSensor.newSensor.name
          this.showUnexpectedError = true;
          // Ocultar el mensaje de error después de 2 segundos
          setTimeout(() => {
            this.showUnexpectedError = false;
          }, 2000);
          return;
        }

        const response = await axios.post(`${API_HOST}/api/sensors`, {
          sensorType: this.newSensor.type,
          name: this.newSensor.name,
          status: this.newSensor.status
        });
        this.sensors.push(response.data);
        this.isCreated = false;
        this.newSensor = { name: '', type: null, status: true };
        this.sensorCreationError = false;
      } catch (error) {
        console.error("Error creating sensor:", error);
        this.sensorCreationError = true;
      }
    },


    async fetchSensorTypes() {
      try {
        const response = await axios.get(`${API_HOST}/api/sensors/types`);
        this.sensorTypes = response.data;
      } catch (error) {
        console.error("Error fetching sensor types:", error);
      }
    },
    updateSensor(newSensor) {
      let index = this.sensors.findIndex(sensor => sensor.sensorId === newSensor.sensorId);
      if (index !== -1) {
        this.sensors.splice(index, 1, newSensor);
      } else {
        console.error('Sensor not found to update:', newSensor);
      }
    }
  }
}
</script>
<style lang="scss">
.form-select {
  margin-bottom: 1rem;
}
</style>
