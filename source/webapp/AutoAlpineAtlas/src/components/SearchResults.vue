<script setup lang="ts">
import { watchDebounced } from "@vueuse/core";
import { Ref, ref } from "vue";

const searchText = defineModel("searchText");

const res: Ref<any[]> = ref([]);

const emit = defineEmits<{
  navigate: [value: { lat: number; lon: number; box: any }];
  update: [value: string];
}>();

watchDebounced(
  searchText,
  async () => {
    if (searchText.value != "") {
      const resp = await fetch(`https://api3.geo.admin.ch/rest/services/ech/SearchServer?sr=4326&searchText=${searchText.value}&lang=de&type=locations`);
      res.value = (await resp.json()).results;

      res.value = res.value.sort((a, b) => {
        return a.attrs.rank - b.attrs.rank;
      });
      console.log(res.value);
    } else {
      res.value = [];
    }
  },
  { debounce: 150, maxWait: 1000 }
);
</script>

<template>
  <div class="z-50 absolute left-0 right-0 top-24 w-screen max-h-96 overflow-y-scroll" :class="{ hidden: res.length == 0 }">
    <div class="m-auto bg-white p-4 xs:w-screen" style="max-width: 800px">
      <ul class="list-none">
        <li v-for="result in res" class="border-b-2 border-color-black p-2 hover:bg-stone-100">
          <button class="w-full" v-html="result.attrs.label" @click="$emit('navigate', { lat: result.attrs.lat, lon: result.attrs.lon, box: result.attrs.geom_st_box2d })"></button>
        </li>
      </ul>
    </div>
  </div>
</template>
