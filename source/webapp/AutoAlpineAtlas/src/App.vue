<script setup lang="ts">
import Navbar from "./components/Navbar.vue";
import Map from "./components/Map.vue";
import Configsidebar from "./components/Configsidebar.vue";
</script>

<template>
  <div class="max-h-screen">
    <Navbar></Navbar>
    <div class="flex">
      <Map></Map>

      <Configsidebar></Configsidebar>
    </div>
    <!-- <div class="absolute bottom-0 left-0 right-0">
      <div class="backdrop-blur-lg backdrop-brightness-100 m-8 rounded-3xl p-4">
        <div class="rounded-xl bg-white h-64 p-4">hello world</div>
      </div>
    </div> -->
  </div>
</template>
