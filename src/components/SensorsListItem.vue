<template>
  <div class="sensor border border-secondary rounded p-2 mb-2" :class="{expanded: isExpanded}">
    <div class="top-row d-flex" @click="toggleExpand">
      <div class="sensor-name fw-bold pe-3">{{ sensor.sensorName }}</div>
      <div class="sensor-status" :class="{working: isSensorWorking, notWorking: !isSensorWorking}">
        <template v-if="isSensorWorking">
          <span class="icon">&#x2B24;</span> 
          Working
        </template>
        <template v-else>
          <span class="icon">&#x2716;</span> 
          Not Working
        </template>
      </div>

      
      <div class="expand-button ms-auto">
        {{ isExpanded ? '&#9660;' : '&#9658;' }}
      </div>
    </div>
    <template v-if="isExpanded">
      <hr/>
      <div class="details d-flex">
        <button type="button" class="btn btn-secondary me-2" @click="switchSensor">{{ isSensorWorking ? 'Not' : '' }}Working</button>
        <button type="button" class="btn btn-danger" @click="DisplayDeleteModal">Delete Sensor</button>
      </div>
    </template>
 
    <template v-if="DeleteConfirmed">
    <div class="modal-background">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-body">
            Are you sure you want to delete {{ sensor.sensorName }}?
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" @click="DeleteConfirmed = false">Close</button>
            <button type="button" class="btn btn-primary" @click="deleteSensor">Confirm</button>
          </div>
        </div>
      </div>
    </div>
  </template>

  </div>
</template>

<script>
import axios from 'axios';
import { API_HOST } from '../config';

export default {
  name: 'SensorListItem',
  props: ['sensor'],
  data: function() {
    return {
      isExpanded: false,
      DeleteConfirmed:false
    }
  },
  computed: {
    isSensorWorking: function() {
      return this.sensor.status;
    }
  },
  methods: {
    DisplayDeleteModal() {
      this.DeleteConfirmed = true;
    },
  
    closeDeleteModal() {
      this.DeleteConfirmed = false;
    },
    toggleExpand() {
      this.isExpanded = !this.isExpanded;
    },
    async switchSensor() {
      const newStatus = !this.sensor.status;

      const response= await axios.put(`${API_HOST}/api/sensors/${this.sensor.sensorId}/status`);
      if (response.status === 200) {
      this.sensor.status = newStatus;
    } else {
      console.error('Server responded with a non-successful status:', response.status);
    }
  
},
    async deleteSensor() {
      
      try {
        const response = await axios.delete(`${API_HOST}/api/sensors/${this.sensor.sensorId}`);
        if (response.status === 200) {
          this.$emit('sensorDeleted', this.sensor.sensorId);
          this.DeleteConfirmed = false; 
        } else {
          console.error('Error deleting sensor:', response.status);
        }
      } catch (error) {
        console.error('Error deleting sensor:', error);
      }
}

  }
}
</script>

<style lang="scss" scoped>

.sensor-status {
  .icon {
    position: relative;
  }

  &.working {
    color: #198754;
    .icon {
      font-size: 12px;
      top: -3px;
    }
  }

  &.notWorking {
    color: #dc3545;
  }
}

.sensor {
  .top-row {
    cursor: pointer;
  }
  .modal-background {
  position: fixed;
  background-color: rgba(0, 0, 0, 0.3);
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}
}
</style>
