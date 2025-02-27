<script setup lang="ts">
import { Cross1Icon, Crosshair2Icon, PlayIcon, ResetIcon, SymbolIcon } from "@radix-icons/vue";
import { coords } from "../App.vue";
import { Ref, watch } from "vue";
import { EState } from "../firebase";
import ToggleSwitch from "./ToggleSwitch.vue";

const emit = defineEmits(["plan-start", "plan-end", "launch-planning", "reset"]);
const startPoint: Ref<coords | undefined> = defineModel("startPoint");
const endPoint: Ref<coords | undefined> = defineModel("endPoint");
const isPicking: Ref<boolean | undefined> = defineModel("isPicking");
const selectedModel: Ref<string | undefined> = defineModel("selectedModel");

const currentState: Ref<EState | undefined> = defineModel("currentState");

const show = defineModel("show");

watch(currentState, (a) => {
  console.log("state changed to:", a);
});
</script>

<template>
  <div
    :class="{ 'translate-x-full': !show, 'scale-x-0': !show, 'translate-x-3/4': isPicking }"
    style="transition: all 0.2s ease"
    class="z-40 bg-white shadow-inner shadow-stone-600 absolute right-0 top-20 xs:top-16 bottom-0 w-screen max-w-sm"
  >
    <div class="content m-4">
      <div class="header flex justify-between items-center mb-4 w-full">
        <h2 class="text-lg font-medium flex">Route Planen</h2>
        <button class="flex items-center justify-center hover:bg-gray-200 rounded-full" @click="show = false">
          <Cross1Icon class="h-6 w-6 text-stone-800 m-2"></Cross1Icon>
        </button>
      </div>
      <div class="">
        <div class="flex mb-4 items-center justify-center">
          <ToggleSwitch></ToggleSwitch>
        </div>
        <!-- Start / Endpoint selection -->
        <div class="py-2 flex flex-nowrap items-center" v-if="!currentState">
          <button class="bg-blue-500 rounded-md py-2 px-4 text-white flex flex-nowrap items-center w-40 justify-center mr-2" @click="emit('plan-start')"><Crosshair2Icon class="mr-2"></Crosshair2Icon>Startpunkt</button>
          <span class="flex font-italic font-mono text-gray-400">{{ startPoint?.lat ?? "??" }} N {{ startPoint?.lng ?? "??" }} E</span>
        </div>
        <div class="py-2 flex flex-nowrap items-center" v-if="!currentState">
          <button class="bg-blue-500 rounded-md py-2 px-4 text-white flex flex-nowrap items-center w-40 justify-center mr-2" @click="emit('plan-end')"><Crosshair2Icon class="mr-2"></Crosshair2Icon>Endpunkt</button>
          <span class="flex font-italic font-mono text-gray-400">{{ endPoint?.lat ?? "??" }} N {{ endPoint?.lng ?? "??" }} E</span>
        </div>
        <span>ACHTUNG: Aktuelle Wartungsarbeiten</span>
        <!-- Model selection -->
        <div class="py-2 items-center" v-if="!currentState">
          <label class="block text-sm font-medium text-gray-700 mb-2">Model: </label>
          <select name="model" v-model="selectedModel" class="block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm mb-4">
            <option value="lake+street">gewaesser+wege-v1.0</option>
            <option value="lake">gewaesser-v1.0</option>
            <option value="naive">naiv-v1.0</option>
          </select>
        </div>

        <!-- Control buttons / state indicators -->
        <div class="py-2">
          <button v-if="!currentState" class="bg-green-500 rounded-md py-2 px-4 text-white w-full flex flex-nowrap items-center justify-center" @click="emit('launch-planning')"><PlayIcon class="mr-2"></PlayIcon> Berechnung Starten</button>
          <div v-if="currentState == 'waiting'" class="bg-yellow-400 rounded-md py-2 px-4 text-white w-full flex flex-nowrap items-center justify-center has-tooltip">
            Warten...<span class="tooltip">Du bist in der Warteschlange, du kannst dieses Fenster schliessen und später zurückkehren</span>
          </div>
          <div v-if="currentState == 'processing'" class="bg-blue-600 rounded-md py-2 px-4 text-white w-full flex flex-nowrap items-center justify-center has-tooltip">
            <SymbolIcon class="mr-2 animate-spin-slow"></SymbolIcon>
            In Berechnung...
            <span class="tooltip">Deine Route wird momentan berechnet</span>
          </div>
          <div v-if="currentState == 'processed'">Erfolgreich Verarbeitet.</div>
          <button v-if="currentState == 'processed'" class="bg-red-500 rounded-md py-2 px-4 text-white w-full flex flex-nowrap items-center justify-center" @click="emit('reset')"><ResetIcon class="mr-2"></ResetIcon> Nochmals</button>
          <button v-if="currentState == 'failed'" class="bg-red-500 rounded-md py-2 px-4 text-white w-full flex flex-nowrap items-center justify-center" @click="emit('reset')"><ResetIcon class="mr-2"></ResetIcon> FAILURE</button>
        </div>
        <!-- <div class="debug text-mono bg-black p-2">{{}}</div> -->
      </div>
    </div>
  </div>
</template>
