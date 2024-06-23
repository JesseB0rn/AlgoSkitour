<script setup lang="ts">
import { Cross1Icon } from "@radix-icons/vue";
import { ref, watch } from "vue";
import { useCollection, useCurrentUser, useFirebaseAuth } from "vuefire";
import { signInWithPopup, signOut, GoogleAuthProvider, OAuthProvider } from "firebase/auth";
import { toursUserRef } from "../firebase";

const emit = defineEmits(["selected-stored-tour"]);

const provider = new OAuthProvider("apple.com");
provider.addScope("email");
provider.addScope("name");
provider.setCustomParameters({
  locale: "de-CH",
});

const show = defineModel("show");

const auth = useFirebaseAuth()!;
const user = useCurrentUser();

const error = ref(null);

var tours = useCollection(toursUserRef(""));

function signInApple() {
  signInWithPopup(auth, new GoogleAuthProvider()).catch((reason) => {
    console.error(reason);
    error.value = reason;
  });
}

watch(user, (user) => {
  console.log(user?.displayName);
  if (user) {
    tours = useCollection(toursUserRef(user.uid));
  }
});
</script>

<template>
  <div :class="{ 'translate-x-full': !show, 'scale-x-0': !show }" style="transition: all 0.2s ease" class="z-40 bg-white shadow-inner shadow-stone-600 absolute right-0 top-20 xs:top-16 bottom-0 w-screen max-w-sm">
    <div class="content m-4">
      <div class="header flex justify-between items-center mb-4 w-full">
        <h2 class="text-lg font-medium flex">Mein Account</h2>
        <button class="flex items-center justify-center hover:bg-gray-200 rounded-full" @click="show = false">
          <Cross1Icon class="h-6 w-6 text-stone-800 m-2"></Cross1Icon>
        </button>
      </div>
      <div class="">
        <button @click="signInApple()">Sign in With Google</button>
        <button @click="signOut(auth)">Abmelden</button>
        {{ user?.email }}
        <!-- Start / Endpoint selection -->
        <p v-for="tour in tours">{{ tour.id }}</p>
      </div>
    </div>
  </div>
</template>
