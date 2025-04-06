// import { createContext, useState, useEffect } from 'react';

// export const IssueContext = createContext();

// export const IssueProvider = ({ children }) => {
//   const [issues, setIssues] = useState([]);
//   const [stats, setStats] = useState({
//     pending: 0,
//     solved: 0,
//     total: 0,
//     happiness: 0
//   });

//   // Fetch issues from backend
//   useEffect(() => {
//     const fetchIssues = async () => {
//       try {
//         const res = await fetch('http://localhost:4000/complaints');
//         const data = await res.json();
        
//         const complaints = data.complaints.map(complaint => ({

//           id: complaint.id,
//           title: complaint.complaint_category, // or whatever your backend field is
//           description: complaint.complaint, // adjust as needed
//           resolved: complaint.resolved || false, // assuming resolved is a boolean
//         }));
// //console.log(complaints);
//         setIssues(complaints);

//         const solved = complaints.filter(issue => issue.resolved).length;
//         const pending = complaints.length - solved;
//         const happiness = complaints.length > 0 ? 
//           (solved / complaints.length) * 100 : 0;

//         setStats({
//           pending,
//           solved,
//           total: complaints.length,
//           happiness: Math.round(happiness)
//         });
//       } catch (err) {
//         console.error('Error fetching issues:', err);
//       }
//     };

//     fetchIssues();
//   }, []);

//   const resolveIssue = async(issueId) => {
//     try {
//       const res = await fetch(`http://localhost:4000/resolve?id=${issueId}`, { //changed delete to resolve
//         // method: 'DELETE'
//         method: 'PATCH',
//         headers: { 'Content-Type': 'application/json' },
//       }); //changed here........
//       const data = await res.json();
//       console.log(data);
//     } catch (error) {
//       console.error('Error resolving issue:', error);
//     }
  
//     // Remove the issue visually but don’t affect total count
//     setIssues(prevIssues => {
//       return prevIssues.map(issue =>
//         issue.id === issueId ? { ...issue, resolved: true } : issue
//       );
//     });
  
//     // Update stats - total remains unchanged
//     setStats(prevStats => {
//       const newSolved = prevStats.solved + 1;
//       const newPending = prevStats.pending - 1;
//       const happiness = (newSolved / prevStats.total) * 100;
  
//       return {
//         ...prevStats,
//         solved: newSolved,
//         pending: newPending,
//         happiness: Math.round(happiness)
//       };
//     });
//   };
  
  

//   return (
//     <IssueContext.Provider value={{ issues, stats, resolveIssue }}>
//       {children}
//     </IssueContext.Provider>
//   );
// };



//--------------> realtime updates <------------------

// import { createContext, useState, useEffect } from 'react';
// import { db } from '../firebase';
// import { collection, onSnapshot } from 'firebase/firestore';

// export const IssueContext = createContext();

// export const IssueProvider = ({ children }) => {
//   const [issues, setIssues] = useState([]);
//   const [stats, setStats] = useState({
//     pending: 0,
//     solved: 0,
//     total: 0,
//     happiness: 0
//   });

//   useEffect(() => {
//     const complaintsRef = collection(db, 'complaints');

//     const unsubscribe = onSnapshot(complaintsRef, (snapshot) => {
//       const complaints = snapshot.docs.map(doc => ({
//         id: doc.id,
//         title: doc.data().complaint_category,
//         description: doc.data().complaint,
//         resolved: doc.data().resolved || false
//       }));

//       setIssues(complaints);

//       const solved = complaints.filter(issue => issue.resolved).length;
//       const pending = complaints.length - solved;
//       const happiness = complaints.length > 0 ? 
//         (solved / complaints.length) * 100 : 0;

//       setStats({
//         pending,
//         solved,
//         total: complaints.length,
//         happiness: Math.round(happiness)
//       });
//     });

//     return () => unsubscribe();
//   }, []);

//   const resolveIssue = async(issueId) => {
//     try {
//       const res = await fetch(`http://localhost:4000/resolve?id=${issueId}`, {
//         method: 'PATCH',
//         headers: { 'Content-Type': 'application/json' },
//       });
//       const data = await res.json();
//       console.log(data);
//     } catch (error) {
//       console.error('Error resolving issue:', error);
//     }
//     // No need to manually update UI; real-time listener will handle it
//   };

//   return (
//     <IssueContext.Provider value={{ issues, stats, resolveIssue }}>
//       {children}
//     </IssueContext.Provider>
//   );
// };



//------------>try 2
import { doc, updateDoc } from 'firebase/firestore'; 
import { createContext, useState, useEffect } from 'react';
import { db } from '../firebase';
import { collection, query, where, onSnapshot } from 'firebase/firestore';

export const IssueContext = createContext();

export const IssueProvider = ({ children }) => {
  const [issues, setIssues] = useState([]);
  const [stats, setStats] = useState({
    pending: 0,
    solved: 0,
    total: 0,
    happiness: 0
  });

  useEffect(() => {
    // Only query unresolved complaints initially
    const unresolvedQuery = query(
      collection(db, 'complaints'),
      where('resolved', '==', false)
    );

    const unsubscribe = onSnapshot(unresolvedQuery, (snapshot) => {
      const complaints = snapshot.docs.map(doc => ({
        id: doc.id,
        title: doc.data().complaint_category,
        description: doc.data().complaint,
        resolved: false // Since we're only getting unresolved ones
      }));

      setIssues(complaints);

      // For stats, we need to know about both resolved and unresolved
      // So we'll need a separate listener for stats
    });

    return () => unsubscribe();
  }, []);

  // Separate useEffect for stats that needs all complaints
  useEffect(() => {
    const allComplaintsQuery = collection(db, 'complaints');
    
    const unsubscribeStats = onSnapshot(allComplaintsQuery, (snapshot) => {
      const allComplaints = snapshot.docs.map(doc => ({
        resolved: doc.data().resolved || false
      }));

      const solved = allComplaints.filter(issue => issue.resolved).length;
      const pending = allComplaints.length - solved;
      const happiness = allComplaints.length > 0 ? 
        (solved / allComplaints.length) * 100 : 0;

      setStats({
        pending,
        solved,
        total: allComplaints.length,
        happiness: Math.round(happiness)
      });
    });

    return () => unsubscribeStats();
  }, []);

  const resolveIssue = async(issueId) => {
    try {
      // Update directly using Firebase SDK instead of going through your backend
      const complaintRef = doc(db, 'complaints', issueId);
      await updateDoc(complaintRef, { resolved: true });
      
      // No need to update state manually - the listeners will handle it
    } catch (error) {
      console.error('Error resolving issue:', error);
    }
  };

  return (
    <IssueContext.Provider value={{ issues, stats, resolveIssue }}>
      {children}
    </IssueContext.Provider>
  );
};