import { initializeApp } from "firebase/app";
import { getFirestore, collection, GeoPoint, query, where } from "firebase/firestore";

export const firebaseApp = initializeApp({
  apiKey: "AIzaSyDXockQOkVpy34Ear-Jiy2J8qztY1THv1U",
  authDomain: "algotour-834d6.firebaseapp.com",
  projectId: "algotour-834d6",
  storageBucket: "algotour-834d6.appspot.com",
  messagingSenderId: "770416651697",
  appId: "1:770416651697:web:2764fbdaaf32d99425a190",
});

// used for the firestore refs
export const db = getFirestore(firebaseApp);

// here we can export reusable database references
export const toursRef = collection(db, "tours");
export const toursUserRef = (userid: string) => query(toursRef, where("owner", "==", userid != "" ? userid : "---"));

export type EState = "waiting" | "processing" | "processed" | "failed";

export interface ITour {
  state: EState;
  startpoint: GeoPoint;
  endpoint: GeoPoint;
  route: null | any;
  owner: string;
  centerpoint_geohash: string;
  modelversion: string;
}
