<template>
  <div id="app">
    <header>
      <div class="title">{{title}}</div>
    </header>

    <section class="main-content w-50 mx-auto">
      <main-navigation @see-Sensors="changeView" @see-Machines="changeView"></main-navigation>
      <machines-list v-if="machinesSelectedTrue" ></machines-list>
      <sensor-list v-if="sensorsSelectedTrue"></sensor-list>
      
      <!-- <rooms-list></rooms-list> -->
    </section>
  </div>
</template>

<script>
import MainNavigation from './components/MainNavigation.vue';
import SensorList from './components/SensorList.vue';
import RoomsList from './components/RoomsList.vue';
import MachinesList from './components/MachinesList.vue'

export default {
  name: 'App',
  components: {
    MainNavigation,
    SensorList,
    RoomsList,
    MachinesList
  },
  data: function() {
    return {
      title: 'Vue listing frontend Test',
      sensorsSelectedTrue: true,
      machinesSelectedTrue: false,
      // reservationsSelectedBool: false,
    }
  },
  methods: {
    changeView(){
      this.sensorsSelectedTrue = !this.sensorsSelectedTrue;
      this.machinesSelectedTrue = !this.machinesSelectedTrue; 
      // this.reservationsSelectedBool = !this.reservationsSelectedBool;
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
