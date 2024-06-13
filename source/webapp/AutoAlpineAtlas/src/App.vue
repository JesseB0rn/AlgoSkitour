<script setup lang="ts">
import Navbar from "./components/Navbar.vue";
import Map from "./components/Map.vue";
import Configsidebar from "./components/Configsidebar.vue";
import SearchResults from "./components/SearchResults.vue";
import { Ref, ref } from "vue";

let showSettings = ref(false);
let showUser = ref(false);

let searchText = ref("");
let searchResultCoord: Ref<any> = ref({});
</script>

<template>
  <div class="max-h-screen w-screen bg-stone-500">
    <Navbar v-model:settings="showSettings" v-model:user="showUser" v-model:searchText="searchText"></Navbar>
    <Configsidebar v-model:show="showSettings"></Configsidebar>
    <SearchResults v-model:searchText="searchText" @navigate="(coord) => (searchResultCoord = coord)"></SearchResults>
    <div class="flex">
      <Map v-model:navigateto="searchResultCoord" v-model:searchText="searchText"></Map>
    </div>
  </div>
</template>

<script lang="ts"></script>
