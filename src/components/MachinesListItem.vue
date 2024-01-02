<template>
  <div class="machine border border-secondary rounded p-2 mb-2" :class="{ expanded: isExpanded }">
    <div class="top-row d-flex" @click="toggleExpand">
      <div class="machine-name fw-bold pe-3">{{ machine.name }}</div>
      <div class="machine-progress text-muted">{{ machine.progress }} min</div>

      <div class="machine-status ms-4" :class="{ open: isMachineAvailable, closed: !isMachineAvailable }">
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
      <hr />
      <div class="details d-flex">
        <button type="button" class="btn btn-primary me-2" @click="switchAvailability">Make machine {{ isMachineAvailable
          ? 'unavailable' : 'available' }} </button>
        <!-- <button type="button" class="btn btn-danger " @click ="deleteMachine">Delete machine</button> -->

        <button type="button" class="btn btn-danger" :class="{ deleted: isDeleted }" @click="openDeleteModal">Delete
          Machine</button>

        <template v-if="isDeleted">
          <div class="modal fade show d-block" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel"
            aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-body">
                  Are you sure you want to delete Machine {{ machine.machineId }}?
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-primary" @click="openDeleteModal">Close</button>
                  <button type="button" class="btn btn-danger" @click="deleteMachine">Delete</button>
                </div>
              </div>
            </div>
          </div>
        </template>

      </div>
    </template>
  </div>
</template>

<script>
import axios from 'axios';
import { API_HOST } from '../config';
import { backendHost } from '../../backend.config';

export default {
  name: 'MachinesListItem',
  props: ['machine'],
  data: function () {
    return {
      isExpanded: false,
      isDeleted: false,

    }
  },
  computed: {
    isMachineAvailable: function () {
      return this.machine.available;
    }
  },
  methods: {
    toggleExpand() {
      this.isExpanded = !this.isExpanded;
    },
    openDeleteModal() {
      this.isDeleted = !this.isDeleted;
    },
    async switchAvailability() {
      try {
        let response = await axios.put(`${API_HOST}/api/machines/updateAvailable/${this.machine.machineId}`);
        let updatedMachine = response.data;
        this.$emit('machine-updated', updatedMachine);
      } catch (error) {
        console.error('Error occurred while updating availability:', error);
      }
    },


    async deleteMachine() {
      try {
        const response = await axios.delete(`${API_HOST}/api/machines/${this.machine.machineId}`);
        if (response.status === 200) {
          this.$emit('machine-deleted', this.machine.machineId);
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
