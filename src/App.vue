<template>
  <div id="app">
    <header>
      <div class="title">{{title}}</div>
    </header>

    <section class="main-content w-50 mx-auto">
      <main-navigation></main-navigation>
      <sensor-list></sensor-list>
      <!-- <rooms-list></rooms-list> -->
    </section>
  </div>
</template>

<script>
import MainNavigation from './components/MainNavigation.vue';
import SensorList from './components/SensorList.vue';
import RoomsList from './components/RoomsList.vue';

export default {
  name: 'App',
  components: {
    MainNavigation,
    SensorList,
    RoomsList
  },
  data: function() {
    return {
      title: 'My Sensors'
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
