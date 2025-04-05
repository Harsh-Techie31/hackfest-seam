
//  import { collection, onSnapshot , getDocs, deleteDoc, doc} from 'firebase/firestore';
// import express from 'express';
// import { db } from './firebase.js';
// import cors from 'cors';
// // import { collection } from 'firebase/firestore';

// const app = express();
// app.use(express.json());
// app.use(cors())
// // Real-time listener for new complaints
// const complaintsRef = collection(db, "complaints");

// // onSnapshot(complaintsRef, (snapshot) => {
// //   snapshot.docChanges().forEach((change) => {
// //     if (change.type === "added") {
// //       const newComplaint = change.doc.data();
// //       console.log("🚨 New Complaint Registered:", newComplaint);
// //     }
// //   });
// // });



// // Just for testing
// app.get('/', (req, res) => {
//   res.send("Server is running and listening for new complaints.");
// });

// app.get('/complaints', async (req, res) => {
//     try {
//       const complaintsRef = collection(db, 'complaints');
//       const snapshot = await getDocs(complaintsRef);
  
//       const complaints = snapshot.docs.map(doc => ({
//         id: doc.id,
//         ...doc.data(), // get all fields of the complaint
//       }));
//   // console.log(complaints)
//       res.json({ complaints });
    
//     } catch (error) {
//       console.error("❌ Error fetching complaints:", error);
//       res.status(500).json({ error: "Failed to fetch complaints" });
//     }
//   });


//   app.delete('/delete', async (req, res) => {
//     const { id } = req.query; // 👈 read from query string
  
//     if (!id) {
//       return res.status(400).json({ error: "ID is required in the query" });
//     }
  
//     try {
//       const complaintRef = doc(db, 'complaints', id);
//       await deleteDoc(complaintRef);
//       res.json({ success: true, message: `Complaint with ID ${id} has been deleted.` });
//     } catch (error) {
//       console.error("❌ Error deleting complaint:", error);
//       res.status(500).json({ error: "Failed to delete complaint" });
//     }
//   });
  
// const PORT = 4000;
// app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));




import express from 'express';
import cors from 'cors';
import { collection, getDocs, deleteDoc, doc, updateDoc } from 'firebase/firestore';
import { db } from './firebase.js';

const app = express();
app.use(express.json());
app.use(cors());

const complaintsRef = collection(db, "complaints");

// Just for testing
app.get('/', (req, res) => {
  res.send("Server is running and listening for new complaints.");
});

// Get all complaints
app.get('/complaints', async (req, res) => {
  try {
    const snapshot = await getDocs(complaintsRef);

    const complaints = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(), // includes complaint_category, complaint, resolved etc.
    }));

    res.json({ complaints });

  } catch (error) {
    console.error("❌ Error fetching complaints:", error);
    res.status(500).json({ error: "Failed to fetch complaints" });
  }
});

// ⚠️ Mark complaint as resolved (instead of deleting)
app.patch('/resolve', async (req, res) => {
  const { id } = req.query;

  if (!id) {
    return res.status(400).json({ error: "ID is required in the query" });
  }

  try {
    const complaintRef = doc(db, 'complaints', id);
    await updateDoc(complaintRef, {
      resolved: true
    });

    res.json({ success: true, message: `Complaint with ID ${id} marked as resolved.` });
  } catch (error) {
    console.error("❌ Error updating complaint:", error);
    res.status(500).json({ error: "Failed to mark complaint as resolved" });
  }
});

// Optional: Still allow hard delete (use only if needed)
app.delete('/delete', async (req, res) => {
  const { id } = req.query;

  if (!id) {
    return res.status(400).json({ error: "ID is required in the query" });
  }

  try {
    const complaintRef = doc(db, 'complaints', id);
    await deleteDoc(complaintRef);
    res.json({ success: true, message: `Complaint with ID ${id} has been deleted.` });
  } catch (error) {
    console.error("❌ Error deleting complaint:", error);
    res.status(500).json({ error: "Failed to delete complaint" });
  }
});

const PORT = 4000;
app.listen(PORT, () => console.log(`🚀 Server running on http://localhost:${PORT}`));
