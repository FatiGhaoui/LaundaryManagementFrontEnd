<template>
  <div class="windows-list pt-3">
    <!-- <windows-list-item v-for="window in windows" :window="window" :key="window.machineId" @window-updated="updateWindow">
    </windows-list-item> -->

    <machines-list-item v-for="machine in machines" :machine="machine" :key="machine.machineId" @machine-updated="updateMachine" @machine-deleted="updateView">
    </machines-list-item>

    <!-- <li class="temporary-machine-list" v-for="machine in machines"> {{ machine.name }}</li> -->

    <div class="d-flex mb-2" v-if="!showForm">
      <button type="button" class="btn btn-primary" @click="showMachineCreationForm">Create new machine</button>
    </div>

    <div v-if="showForm" class="creation-form">
      <form>
        <h1> Create new machine</h1>
        <input type="text" class="form-control mb-3" placeholder="Machine name" v-model="machineName">
        
        <!-- <select class="form-select" v-model="machineStatus">
          <option selected>-- Available status --</option>
          <option value=true>Machine available</option>
          <option value=false>Machine unavailable</option>
        </select> -->
      </form> 

      <div v-if="showAlertMessage" class="alert alert-danger" role="alert">
        An unexpected problem occured, the window could not be created
      </div>

      <div class="d-flex mb-2">
        <button type="button" class="btn btn-primary me-2" @click="createNewMachine">Create</button>
        <button type="button" class="btn btn-danger" @click="cancelCreation">Cancel</button>
      </div>

      
    </div>


    
  </div>
</template>


<script>
import axios from 'axios';
import { API_HOST } from '../config';
import { backendHost} from '../../backend.config';
import MachinesListItem from "./MachinesListItem.vue";

export default {
  components: {
    MachinesListItem
  },
  name: 'MachinesList',
  data: function () {
    return {
      /* Initialize windows with an empty array, while waiting for actual data to be retrieved from the API */
      // windows: [],
      machines:[],
      showForm: false,
      machineName:"",
      showAlertMessage: false
      // machineStatus: false
    }
  },
  created: async function () {
    let response = await axios.get(`${backendHost}/api/machines`, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Allow-Credentials': 'true'
      }
    });
    // let windows = response.data;
    let machines = response.data;
    // this.windows = windows;
    this.machines = machines;
  },
  methods: {
    
    updateMachine(newMachine) {
      /* Find the place of window object with the same Id in the array, and replace it */
      let index = this.machines.findIndex(machine => machine.machineId === newMachine.machineId);
      console.log("update machine", newMachine);
      this.machines.splice(index, 1, newMachine);
    },

    updateView(machineId){
      let index = this.machines.findIndex(machine => machine.machineId === machineId);
      this.machines.splice(index,1);
    },

    showMachineCreationForm(){
      this.showForm = !this.showForm;
    },

    showAlert(){
      this.showAlertMessage = true;
    },

    async createNewMachine(){
      let jsonPayload = {
        machineId: 0,
        name: this.machineName,
        available: false,
        machineStatus: true,
        progress: 0
      }
      try{
        let response = await axios.post(`${backendHost}/api/machines`, jsonPayload);
        if(response.status=200){
          this.machines.push(response.data);
          this.showMachineCreationForm();
        }else{
          this.showAlert();
        }
      }catch{
        this.showAlert();
      }
      
    },

    cancelCreation(){
      if(confirm("Cancel creation of new machine?")){
        this.showMachineCreationForm();
      }
    }

  }
}
</script>

<style lang="scss">
</style>
