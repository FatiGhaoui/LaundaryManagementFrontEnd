<template>
  <div class="windows-list pt-3">
    <machines-list-item v-for="machine in machines" :machine="machine" :key="machine.machineId"
      @machine-updated="updateMachine" @machine-deleted="updateView">
    </machines-list-item>

    <div class="d-flex mb-2">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal"
        :class="{ created: isCreated }" @click="openCreateModal">
        Create new machine
      </button>
    </div>

    <template v-if="isCreated">
      <div class="modal fade show d-block" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel"
        aria-hidden="true" style="z-index: 1050;">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel">New Machine</h5>
              <button type="button" class="btn-close" aria-label="Close" @click="openCreateModal"></button>
            </div>
            <div class="modal-body">
              <form>
                <input type="text" class="form-control mb-3" placeholder="Machine name" v-model="machineName">
              </form>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-primary" @click="createNewMachine">Create Machine</button>
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
import { backendHost } from '../../backend.config';
import MachinesListItem from "./MachinesListItem.vue";

export default {
  components: {
    MachinesListItem
  },
  name: 'MachinesList',
  data: function () {
    return {
      machines: [],
      isCreated: false,
      showUnexpectedError: false,
      machineName: "",
    }
  },
  created: async function () {
    let response = await axios.get(`${API_HOST}/api/machines`, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Allow-Credentials': 'true'
      }
    });
    let machines = response.data;
    this.machines = machines;
  },
  methods: {
    openCreateModal() {
      this.isCreated = !this.isCreated;
      this.showUnexpectedError = false;
      this.resetForm();
    },

    updateMachine(newMachine) {
      let index = this.machines.findIndex(machine => machine.machineId === newMachine.machineId);
      this.machines.splice(index, 1, newMachine);
    },

    updateView(machineId) {
      let index = this.machines.findIndex(machine => machine.machineId === machineId);
      this.machines.splice(index, 1);
    },

    async createNewMachine() {
      let jsonPayload = {
        machineId: 0,
        name: this.machineName,
        available: false,
        machineStatus: true,
        progress: 0
      }

      try {
        if (!this.machineName) {
          this.showUnexpectedError = true;
          setTimeout(() => {
            this.showUnexpectedError = false;
          }, 2000);
          return;
        }

        let response = await axios.post(`${API_HOST}/api/machines`, jsonPayload);
        if (response.status === 200) {
          this.machines.push(response.data);
          this.isCreated = false;
          this.machineName = '';
          this.$forceUpdate();
        } else {
          console.error('Server responded with a non-successful status:', response.status);
          this.showUnexpectedError = true;
        }
      } catch (error) {
        console.error('Error occurred while making the request:', error);
      }
    }
  }
}
</script>

<style lang="scss"></style>
