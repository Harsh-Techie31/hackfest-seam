// import admin from 'firebase-admin';
// import serviceAccount from './serviceAccountKey.json' assert { type: 'json' };

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// });

// const db = admin.firestore(); // Firestore instance

// export { db };







// import { initializeApp } from "firebase/app";
 import { getFirestore } from "firebase/firestore";

// const firebaseConfig = {
//     apiKey: "AIzaSyCESuNQ3_uyiYtipGcKN-2SUuEU3jkQ7kU",
//     authDomain: "feedback-complaint-db.firebaseapp.com",
//     databaseURL: "https://feedback-complaint-db-default-rtdb.firebaseio.com",
//     projectId: "feedback-complaint-db",
//     storageBucket: "feedback-complaint-db.firebasestorage.app",
//     messagingSenderId: "356106972312",
//     appId: "1:356106972312:web:23905e52f09ad395da34ed"
//   };
  

// const app = initializeApp(firebaseConfig);
// const db = getFirestore(app);

// export { db };



// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCfxJ3luIpc0oDDET5gVmZeKovSijtg6fI",
  authDomain: "hackfest-seam.firebaseapp.com",
  projectId: "hackfest-seam",
  storageBucket: "hackfest-seam.firebasestorage.app",
  messagingSenderId: "388532294048",
  appId: "1:388532294048:web:dfa97b69589d2ebc4754c5"
};


 const app = initializeApp(firebaseConfig);
 const db = getFirestore(app);

 export { db };