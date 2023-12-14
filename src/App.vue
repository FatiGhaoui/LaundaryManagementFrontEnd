<template>
  <div id="app">
    <header>
      <div class="title">{{title}}</div>
    </header>

    <section class="main-content w-50 mx-auto">
      <main-navigation @see-Sensors="changeViewToSensor" @see-Machines="changeViewToMachine" @see-Reservations="changeViewToReservation"></main-navigation>
      <machines-list v-if="machinesSelectedTrue" ></machines-list>
      <sensor-list v-if="sensorsSelectedTrue"></sensor-list>
      <reservations-list v-if="reservationsSelectedBool"></reservations-list>
    </section>

  </div>
</template>

<script>
import MainNavigation from './components/MainNavigation.vue';
import SensorList from './components/SensorList.vue';
import MachinesList from './components/MachinesList.vue'
import ReservationsList from './components/ReservationsList.vue'

export default {
  name: 'App',
  components: {
    MainNavigation,
    SensorList,
    MachinesList,
    ReservationsList
  },
  data: function() {
    return {
      title: 'Laundry Management Application',
      sensorsSelectedTrue: false,
      machinesSelectedTrue: true,
      reservationsSelectedBool: false,
    }
  },
  methods: {
    changeViewToMachine(){
      this.sensorsSelectedTrue = false;
      this.machinesSelectedTrue = true; 
      this.reservationsSelectedBool = false;
    },
    changeViewToReservation(){
      this.sensorsSelectedTrue = false;
      this.machinesSelectedTrue = false; 
      this.reservationsSelectedBool = true;
    },
    changeViewToSensor(){
      this.sensorsSelectedTrue = true;
      this.machinesSelectedTrue = false; 
      this.reservationsSelectedBool = false;
    }

  }
}
</script>

<style lang="scss" scoped>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  margin-top: 60px;

  .title {
    text-align: center;
  }
}

</style>
