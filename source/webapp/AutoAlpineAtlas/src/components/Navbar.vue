<script setup lang="ts">
import { GearIcon, PersonIcon } from "@radix-icons/vue";
</script>

<template>
  <div class="min-w-full bg-gray-950 min-h-20 border-b-4 border-orange-500 flex items-center justify-start shadow-orange-500 shadow-2xl xs:min-h-16">
    <div class="flex items-center justify-center mx-8">
      <h1 class="sm:text-3xl font-bold text-white text-xl">AutoAlpineAtlas</h1>
    </div>
    <span class="flex flex-grow"></span>
    <button class="flex items-center justify-center mx-4 hover:bg-gray-700 rounded-full">
      <GearIcon class="h-6 w-6 text-orange-500 m-2" />
    </button>
    <button class="flex items-center justify-center mr-8 hover:bg-gray-700 rounded-full">
      <PersonIcon class="h-6 w-6 text-orange-500 m-2" />
    </button>
  </div>
</template>
