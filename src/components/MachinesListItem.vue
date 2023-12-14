<template>
  <div class="machine border border-secondary rounded p-2 mb-2" :class="{expanded: isExpanded}">
    <div class="top-row d-flex" @click="toggleExpand">
      <div class="machine-name fw-bold pe-3">{{machine.name}}</div>
      <div class="machine-progress text-muted">{{machine.progress}} min</div>

      <div class="machine-status ms-4" :class="{open: isMachineAvailable, closed: !isMachineAvailable}">
        <template v-if="isMachineAvailable">
          <span class="icon">&#x2B24;</span> 
          Available
        </template>
        <template v-else>
          <span class="icon">&#x2716;</span> 
          Unavailable
        </template>
      </div>

      <div class="expand-button ms-auto">
        {{ isExpanded ? '&#9660;' : '&#9658;' }}
      </div>
    </div>
    <template v-if="isExpanded">
      <hr/>
      <div class="details d-flex">
        <button type="button" class="btn btn-secondary me-2" @click="switchAvailability">Make machine {{ isMachineAvailable ? 'unavailable' : 'available' }} </button>
        <!-- <button type="button" class="btn btn-danger " @click ="deleteMachine">Delete machine</button> -->
        
        
        <button type="button" class="btn btn-danger " @click ="deleteConfirmationDialog">Delete machine </button>

        <div v-if="showConfirmationDialog" class="confirmation-dialog">
        <div class="modal-background">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-body">
                Are you sure you want to delete Machine?
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="deleteMachine">Delete</button>
                <button type="button" class="btn btn-primary" @click="cancelAction">Cancel</button>
              </div>
            </div>
          </div>
        </div>
        </div>


      </div>
    </template>
  </div>

  
</template>

<script>
import axios from 'axios';
import {API_HOST} from '../config';
import { backendHost} from '../../backend.config';

export default {
  name: 'MachinesListItem',
  props: ['machine'],
  data: function() {
    return {
      isExpanded: false,
      showConfirmationDialog: false
    }
  }, 
  computed: {
    isMachineAvailable: function() {
      return this.machine.available ; 
    }
  },
  methods: {
    toggleExpand() {
      this.isExpanded = !this.isExpanded;
    },
    async switchAvailability() {
      if (confirm("Updating Availability status of machine")){
        let response = await axios.put(`${backendHost}/api/machines/updateAvailable/${this.machine.machineId}`);
        let updatedMachine = response.data;
        this.$emit('machine-updated', updatedMachine);
      }
      

      // Here, I should use the response from the server, but the backend currently
      // has a bug, where it doesn't send back the correct value. This is a workaround.
      // this.window.windowStatus.value = (this.window.windowStatus.value === 0.0 ?  1.0 : 0.0);
    },

    async deleteMachine() {
      // if (confirm("Confirm delete machine")){
        let response = await axios.delete(`${backendHost}/api/machines/${this.machine.machineId}`);
        this.$emit('machine-deleted',this.machine.machineId),
        this.showConfirmationDialog = false;
      // }
    },

    deleteConfirmationDialog(){
      this.showConfirmationDialog = true;
    },

    cancelAction(){
      this.showConfirmationDialog = false;
    }

  }
}
</script>

<style lang="scss" scoped>

.machine-status {
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

.machine {
  .top-row {
    cursor: pointer;
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
</style>
