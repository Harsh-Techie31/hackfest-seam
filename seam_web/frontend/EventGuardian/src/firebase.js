// frontend/EventGuardian/src/firebase.js
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyCfxJ3luIpc0oDDET5gVmZeKovSijtg6fI",
  authDomain: "hackfest-seam.firebaseapp.com",
  projectId: "hackfest-seam",
  storageBucket: "hackfest-seam.appspot.com",
  messagingSenderId: "388532294048",
  appId: "1:388532294048:web:dfa97b69589d2ebc4754c5"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export { db };
