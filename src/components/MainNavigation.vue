<template>
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link"  href="#" tabindex="-1" aria-disabled="true" @click="seeMachinesApp" :class="{ active: MachinesActive }">Machines</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" aria-current="page" href="#" @click="seeSensorsApp" :class="{ active: SensorsActive }">Sensors</a>
    </li>
    
    <!-- <li class="nav-item">
      <a class="nav-link" href="#" tabindex="-1" aria-disabled="true" @click="seeReservationsApp">Reservations</a>
    </li> -->
  </ul>
</template>


<script>
export default {
  name: 'MainNavigation',
  data: function() {
    return {
      SensorsActive: true,
      MachinesActive: false,
      ReservationsActive: false 
    }
  }, 
  methods: {
    seeSensorsApp(){
      this.SensorsActive = !this.SensorsActive;
      this.MachinesActive = !this.MachinesActive;
      this.$emit('see-Sensors')
    },
    seeMachinesApp(){
      this.MachinesActive = !this.MachinesActive;
      this.SensorsActive = !this.SensorsActive;
      this.$emit('see-Machines')
    },
    // seeReservationsApp(){
    //   this.ReservationsActive = !this.ReservationsActive;
    //   this.$emit('see-Reservations')
    // }
  }
}
</script>
