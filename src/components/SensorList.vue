<template>
  <div class="sensors-list pt-3">


    <template v-if="!isCreatingSensor">

      <div class="d-flex mb-2">
      <button type="button" class="btn btn-primary" @click="isCreatingSensor = true">Create a new sensor</button>
      </div>

      <sensor-list-item v-for="sensor in sensors" :sensor="sensor" :key="sensor.sensorId" @sensor-updated="updateSensor"  @sensor-deleted="handleSensorDeleted">
        {{ sensor.sensorName }}
      </sensor-list-item>

    </template>

    <template v-if="isCreatingSensor">
       
      <div class="d-flex mb-2">
        <button type="button" class="btn btn-primary me-2"  @click="createSensor">Create</button>
        <button type="button" class="btn btn-danger" @click="isCreatingSensor = false">Cancel</button>
      </div>
      <div v-if="sensorCreationError" class="alert alert-danger" role="alert">
      An unexpected problem occurred, the sensor could not be created.
    </div>

      <form>
        <input type="text" class="form-control mb-3" placeholder="Sensor name" v-model="newSensor.name">
        <select class="form-select">
        <option selected>-- Select Sensor Type --</option>
        <option v-for="type in sensorTypes" :value="type">{{ type }}</option>

        </select>
      </form> 

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
      isCreatingSensor: false,
      newSensor: {
      name: '',
      type: null,
      status: true 
    },
    isCreatingSensor: false,
    sensorCreationError: false
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
    handleSensorDeleted(deletedSensorId) {
      this.sensors = this.sensors.filter(sensor => sensor.sensorId !== deletedSensorId);
    },
    async createSensor() {
      try {
      const response = await axios.post(`${API_HOST}/api/sensors`, {
        sensorType: this.newSensor.type,
        name: this.newSensor.name,
        status: this.newSensor.status
      });
      this.sensors.push(response.data);
      this.isCreatingSensor = false;
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
</style>
