<script setup lang="ts">
import { Cross1Icon } from "@radix-icons/vue";
import ToggleSwitch from "./ToggleSwitch.vue";
</script>

<template>
  <div class="min-w-fit bg-white shadow-inner shadow-stone-600">
    <div class="content m-4">
      <div class="header flex justify-between items-center mb-4">
        <h2 class="text-lg font-medium">Einstellungen</h2>
        <button class="flex items-center justify-center hover:bg-gray-200 rounded-full">
          <Cross1Icon class="h-6 w-6 text-stone-800 m-2"></Cross1Icon>
        </button>
      </div>

      <ToggleSwitch></ToggleSwitch>
    </div>
  </div>
</template>
