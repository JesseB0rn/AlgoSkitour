<script setup lang="ts">
import { GearIcon, PersonIcon, FilePlusIcon } from "@radix-icons/vue";

const showSettings = defineModel("settings");
const showUser = defineModel("user");
const searchText = defineModel("searchText");
</script>

<template>
  <div class="min-w-full bg-gray-950 min-h-20 border-b-4 border-green-400 flex items-center justify-start shadow-green-400 shadow-2xl xs:min-h-16">
    <div class="flex items-center justify-center mx-8">
      <h1 class="sm:text-3xl font-bold text-white text-xl">SkitourBuddy</h1>
    </div>
    <span class="flex flex-grow"></span>
    <div class="flex">
      <input
        type="text"
        v-model="searchText"
        class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-green-400 focus:border-green-400 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-400 dark:focus:border-green-400"
        style="min-width: 16vw"
        placeholder="Ort Suchen"
        required
      />
    </div>
    <span class="flex flex-grow"></span>
    <button class="flex items-center justify-center mr-4 hover:bg-gray-700 rounded-full has-tooltip transition-all duration-100">
      <span class="tooltip">Neue Route Planen</span>
      <FilePlusIcon class="h-6 w-6 text-green-400 m-2" />
    </button>
    <button class="flex items-center justify-center mr-4 hover:bg-gray-700 rounded-full has-tooltip transition-all duration-100" @click="showSettings = !showSettings">
      <span class="tooltip">Einstellungen</span>
      <GearIcon class="h-6 w-6 text-green-400 m-2" />
    </button>
    <button class="flex items-center justify-center mr-8 hover:bg-gray-700 rounded-full has-tooltip transition-all duration-100" @click="showUser = !showUser">
      <span class="tooltip">Eigene Routen</span>
      <PersonIcon class="h-6 w-6 text-green-400 m-2" />
    </button>
  </div>
</template>
