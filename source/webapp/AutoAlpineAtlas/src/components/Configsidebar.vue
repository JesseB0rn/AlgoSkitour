<script setup lang="ts">
import { Cross1Icon } from "@radix-icons/vue";
import ToggleSwitch from "./ToggleSwitch.vue";

const show = defineModel("show");
</script>

<template>
  <div :class="{ 'translate-x-full': !show, 'scale-x-0': !show }" style="transition: all 0.2s ease" class="z-40 bg-white shadow-inner shadow-stone-600 absolute right-0 top-20 xs:top-16 bottom-0">
    <div class="content m-4">
      <div class="header flex justify-between items-center mb-4">
        <h2 class="text-lg font-medium">Einstellungen</h2>
        <button class="flex items-center justify-center hover:bg-gray-200 rounded-full" @click="show = false">
          <Cross1Icon class="h-6 w-6 text-stone-800 m-2"></Cross1Icon>
        </button>
      </div>

      <ToggleSwitch></ToggleSwitch>
    </div>
  </div>
</template>
