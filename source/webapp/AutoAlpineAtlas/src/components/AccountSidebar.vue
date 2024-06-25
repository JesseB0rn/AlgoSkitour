<script setup lang="ts">
import { Cross1Icon, OpenInNewWindowIcon } from "@radix-icons/vue";
import { ref, watch } from "vue";
import { useCollection, useCurrentUser, useFirebaseAuth } from "vuefire";
import { signInWithPopup, signOut, GoogleAuthProvider, signInAnonymously, linkWithCredential, signInWithCredential } from "firebase/auth";
import { toursUserRef } from "../firebase";

const emit = defineEmits(["selected-stored-tour", "hovered-stored-tour"]);

const show = defineModel("show");

const auth = useFirebaseAuth()!;
const user = useCurrentUser();

const error = ref(null);

var tours = useCollection(toursUserRef(""));

function signInGoogle() {
  signInWithPopup(auth, new GoogleAuthProvider())
    .then((result) => {
      const cred = GoogleAuthProvider.credentialFromResult(result)!;
      if (auth.currentUser) {
        linkWithCredential(auth.currentUser, cred).catch((err) => {
          if (err.code != "auth/provider-already-linked") console.error(err.code);
        });
      } else {
        signInWithCredential(auth, cred);
      }
    })
    .catch((reason) => {
      console.error(reason);
      error.value = reason;
    });
}

function signInAnon() {
  signInAnonymously(auth).catch((reason) => {
    console.log(reason);
  });
}

watch(user, (user) => {
  console.log(user?.displayName);
  if (user) {
    tours = useCollection(toursUserRef(user.uid));
  } else {
    signInAnon();
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
        <button v-if="!user?.email" @click="signInGoogle()" class="bg-green-500 rounded-md py-2 px-4 text-white w-full flex flex-nowrap items-center justify-center">Sign in With Google</button>
        <button v-if="user?.email" @click="signOut(auth)" class="bg-red-500 rounded-md py-2 px-4 text-white w-full flex flex-nowrap items-center justify-center">Abmelden</button>
        {{ user?.email }}
        <!-- Start / Endpoint selection -->
        <ul class="list-none py-4">
          <template v-for="tour in tours">
            <li class="hover:bg-stone-200 rounded-md transition-all">
              <button class="py-2 px-2 flex items-center justify-between w-full" @click="emit('selected-stored-tour', tour.id)" @mouseenter="emit('hovered-stored-tour', tour.id)">
                {{ tour.id }}
                <OpenInNewWindowIcon></OpenInNewWindowIcon>
              </button>
            </li>
          </template>
        </ul>
      </div>
    </div>
  </div>
</template>
