<script setup lang="ts">
import Navbar from "./components/Navbar.vue";
import Map from "./components/Map.vue";
import Configsidebar from "./components/Configsidebar.vue";
import { ref } from "vue";

let showSettings = ref(false);
let showUser = ref(false);
</script>

<template>
  <div class="max-h-screen w-screen bg-stone-500">
    <Navbar v-model:settings="showSettings" v-model:user="showUser"></Navbar>
    <Configsidebar v-model:show="showSettings"></Configsidebar>
    <div class="flex">
      <Map></Map>
    </div>
  </div>
</template>

<script lang="ts"></script>
