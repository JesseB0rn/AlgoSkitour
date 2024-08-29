<script setup lang="ts">
import { DoubleArrowDownIcon, ArrowTopRightIcon, Component1Icon } from "@radix-icons/vue";
import type { FunctionalComponent, HTMLAttributes, VNodeProps } from "vue";
</script>

<template>
  <div class="relative inline-flex py-2 shadow-inner shadow-stone-400">
    <div class="absolute top-0 left-0 h-full transition-transform duration-300 rounded w-32" :style="bgStyle"></div>
    <button
      v-for="(option, index) in options"
      :key="index"
      :class="['relative z-10 py-2 px-4 rounded transition-colors duration-300 w-32 flex items-center justify-center text-xs', active === option ? 'text-white' : 'text-gray-800']"
      @click="setActive(option, index)"
    >
      <component :is="iconMapping[option]" class="mr-2" />
      {{ option }}
    </button>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";

interface ToggleSwitchData {
  options: string[];
  colors: string[];
  active: string;
  activeIndex: number;
  iconMapping: { [id: string]: FunctionalComponent<HTMLAttributes & VNodeProps> };
}

export default defineComponent({
  data() {
    return {
      options: ["Abfahrt", "Aufstieg"],
      colors: ["#EF4444", "#10B981", "#F59E0B"], // Use HEX colors for smooth transition
      active: "Aufstieg",
      activeIndex: 1,
      iconMapping: {
        Abfahrt: DoubleArrowDownIcon,
        Aufstieg: ArrowTopRightIcon,
        Varianten: Component1Icon, // Replace with the correct icon for Varianten if needed
      },
    } as ToggleSwitchData;
  },
  computed: {
    bgStyle() {
      return {
        transform: `translateX(${this.activeIndex * 8}rem)`,
        backgroundColor: this.activeColor,
      };
    },
    activeColor() {
      return this.colors[this.activeIndex];
    },
  },
  methods: {
    setActive(option: string, index: number) {
      this.active = option;
      this.activeIndex = index;
    },
  },
});
</script>

<style scoped>
.relative.inline-flex {
  overflow: hidden;
  border-radius: 0.5rem; /* Ensure the container has rounded corners */
  position: relative;
}

.absolute {
  height: 100%;
}

button {
  transition: transform 0.2s;
}

button:hover {
  transform: scale(1.05);
}

button:active {
  transform: scale(0.95);
}
</style>
