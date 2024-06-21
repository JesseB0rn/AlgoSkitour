<script setup lang="ts">
import Navbar from "./components/Navbar.vue";
import Map from "./components/Map.vue";
import Configsidebar from "./components/Configsidebar.vue";
import SearchResults from "./components/SearchResults.vue";
import PlanningSidebar from "./components/PlanningSidebar.vue";
import { Ref, ref, watch } from "vue";
import { _RefFirestore, useDocument } from "vuefire";
import { GeoPoint, addDoc } from "firebase/firestore";
import { EState, toursRef } from "./firebase";

export type coords = { lng: number; lat: number };

let showPlanning = ref(false);
let showSettings = ref(false);
let showUser = ref(false);

let searchText = ref("");
let searchResultCoord: Ref<any> = ref({});

let picking: Ref<boolean> = ref(false);
let pickingStart: Ref<boolean> = ref(false);
let pickingEnd: Ref<boolean> = ref(false);

let startPoint: Ref<coords | undefined> = ref(undefined);
let endPoint: Ref<coords | undefined> = ref(undefined);

var currentRoute: _RefFirestore<any> | undefined;

const currentState: Ref<EState | undefined> = ref();
const map = ref<InstanceType<typeof Map> | null>(null);

const selectedModel = ref("lake+street");

const selectedPoint = (latlng: coords) => {
  console.log(JSON.stringify(latlng));

  if (pickingStart.value) {
    startPoint.value = latlng;
  }
  if (pickingEnd.value && !pickingStart.value) {
    endPoint.value = latlng;
  }
  pickingStart.value = false;
  pickingEnd.value = false;
  picking.value = false;
};

const startPlanning = async () => {
  console.log("Starting planning run");
  currentState.value = "waiting";
  if (startPoint.value && endPoint.value)
    currentRoute = useDocument(
      await addDoc(toursRef, {
        state: "waiting",
        startpoint: new GeoPoint(startPoint.value?.lat, startPoint.value?.lng),
        endpoint: new GeoPoint(endPoint.value?.lat, endPoint.value?.lng),
        route: null,
        owner: "",
        centerpoint_geohash: "",
        modelversion: selectedModel.value,
      })
    );
  watch(currentRoute!, () => {
    currentState.value = currentRoute?.data.value["state"];
    if (currentRoute?.data.value["route"]) {
      console.log("[ROUTE]", currentRoute.data.value["route"]);
      map.value?.updateCalculatedRoute(JSON.parse(currentRoute.data.value["route"]));
    }
  });
};

const reset = () => {
  currentRoute = undefined;
  currentState.value = undefined;
};
</script>

<template>
  <div class="max-h-screen w-screen bg-stone-500">
    <Navbar v-model:settings="showSettings" v-model:planning="showPlanning" v-model:user="showUser" v-model:searchText="searchText" v-model:is-picking="picking"></Navbar>
    <Configsidebar v-model:show="showSettings"></Configsidebar>
    <PlanningSidebar
      v-model:show="showPlanning"
      v-model:is-picking="picking"
      v-model:start-point="startPoint"
      v-model:end-point="endPoint"
      v-model:current-state="currentState"
      v-model:selected-model="selectedModel"
      @plan-start="
        pickingStart = true;
        picking = true;
      "
      @plan-end="
        pickingEnd = true;
        picking = true;
      "
      @launch-planning="startPlanning()"
      @reset="reset()"
    ></PlanningSidebar>
    <SearchResults v-model:searchText="searchText" @navigate="(coord) => (searchResultCoord = coord)"></SearchResults>
    <div class="flex">
      <Map ref="map" v-model:navigateto="searchResultCoord" v-model:searchText="searchText" @map-click="(ltln) => selectedPoint(ltln)"></Map>
    </div>
  </div>
</template>

<script lang="ts"></script>
