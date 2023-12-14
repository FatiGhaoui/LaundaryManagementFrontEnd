<template>
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link"  href="#" tabindex="-1" aria-disabled="true" @click="seeMachinesApp" :class="{ active: MachinesActive }">Machines</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" aria-current="page" href="#" @click="seeSensorsApp" :class="{ active: SensorsActive }">Sensors</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="#" tabindex="-1" aria-disabled="true" @click="seeReservationsApp" :class="{ active: ReservationsActive }">Reservations</a>
    </li>
  </ul>
</template>


<script>
export default {
  name: 'MainNavigation',
  data: function() {
    return {
      SensorsActive: false,
      MachinesActive: true,
      ReservationsActive: false 
    }
  }, 
  methods: {
    seeSensorsApp(){
      this.SensorsActive = true;
      this.MachinesActive = false;
      this.ReservationsActive = false;
      this.$emit('see-Sensors')
    },
    seeMachinesApp(){
      this.MachinesActive = true;
      this.SensorsActive = false;
      this.ReservationsActive = false;
      this.$emit('see-Machines')
    },
    seeReservationsApp(){
      this.MachinesActive = false;
      this.SensorsActive = false;
      this.ReservationsActive = true;
      this.$emit('see-Reservations')
    }
  }
}
</script>
