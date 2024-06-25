<script setup lang="ts">
import { ref } from "vue";

const roseState = ref({ N: false, NE: false, E: false, SE: false, S: false, SW: false, W: false, NW: false });
const colorFromState = (state: boolean) => {
  return state ? "#000" : "#fff";
};
</script>

<template>
  <div class="">
    <div class="grid grid-cols-6 grid-rows-6 items-center justify-items-center w-32 h-32">
      <div class="col-span-6">N</div>
      <div class="col-span-1 row-span-4">W</div>
      <svg id="AspectRose" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 194.018 194.018" class="col-span-4 row-span-4">
        <g id="Ebene_1-2">
          <polygon class="cls-1" points="97.009 2.528 67.121 25.623 97.009 97.009 126.897 25.623 97.009 2.528" :fill="colorFromState(roseState.N)" :stroke="colorFromState(!roseState.N)" @click="roseState.N = !roseState.N" />
          <polygon class="cls-1" points="163.817 30.201 126.352 25.397 97.009 97.009 168.621 67.666 163.817 30.201" :fill="colorFromState(roseState.NE)" :stroke="colorFromState(!roseState.NE)" @click="roseState.NE = !roseState.NE" />
          <polygon class="cls-1" points="191.49 97.009 168.395 67.121 97.009 97.009 168.395 126.897 191.49 97.009" :fill="colorFromState(roseState.E)" :stroke="colorFromState(!roseState.E)" @click="roseState.E = !roseState.E" />
          <polygon class="cls-1" points="163.817 163.817 168.621 126.352 97.009 97.009 126.352 168.621 163.817 163.817" :fill="colorFromState(roseState.SE)" :stroke="colorFromState(!roseState.SE)" @click="roseState.SE = !roseState.SE" />
          <polygon class="cls-1" points="97.009 191.491 126.897 168.395 97.009 97.009 67.121 168.395 97.009 191.491" :fill="colorFromState(roseState.S)" :stroke="colorFromState(!roseState.S)" @click="roseState.S = !roseState.S" />
          <polygon class="cls-1" points="30.201 163.818 67.666 168.621 97.009 97.009 25.397 126.352 30.201 163.818" :fill="colorFromState(roseState.SW)" :stroke="colorFromState(!roseState.SW)" @click="roseState.SW = !roseState.SW" />
          <polygon class="cls-1" points="2.528 97.009 25.623 126.897 97.009 97.009 25.623 67.121 2.528 97.009" :fill="colorFromState(roseState.W)" :stroke="colorFromState(!roseState.W)" @click="roseState.W = !roseState.W" />
          <polygon class="cls-1" points="30.2 30.201 25.397 67.666 97.009 97.009 67.666 25.397 30.2 30.201" :fill="colorFromState(roseState.NW)" :stroke="colorFromState(!roseState.NW)" @click="roseState.NW = !roseState.NW" />
        </g>
      </svg>
      <div class="col-span-1 row-span-4">E</div>
      <div class="col-span-6">S</div>
    </div>
    <div class="grid grid-rows-2 grid-cols-2 items-center justify-items-center w-32 h-32">
      <svg id="Ebene_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 144.582 95.198" stroke="#fff" fill="#000" class="row-span-2">
        <g id="Ebene_1-2"><polygon class="cls-1" points="3.739 93.198 47.892 27.019 61.478 44.969 84.573 3.903 140.954 93.198 3.739 93.198" /></g>
      </svg>
      <div class="col-span-1 border-b-4 border-black">a</div>
      <div class="col-span-1 border-t-4 border-black">b</div>
    </div>
  </div>
</template>
