// 



// try2---------->


import { createContext, useState, useEffect } from 'react';
import { db } from '../firebase';
import { 
  collection, 
  query, 
  where, 
  onSnapshot, 
  doc, 
  updateDoc, 
  deleteDoc,
  Timestamp
} from 'firebase/firestore';
import toast from 'react-hot-toast';

export const LostFoundContext = createContext();

export const LostFoundProvider = ({ children }) => {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [processingId, setProcessingId] = useState(null);
  const [stats, setStats] = useState({
    total: 0,
    verified: 0,
    pending: 0,
    lost: 0,
    found: 0
  });

  // Fetch items and calculate statistics
  // useEffect(() => {
  //   const q = query(
  //     collection(db, 'lost_found'),
  //     where('verified', '==', false)
  //   );

  //   const unsubscribe = onSnapshot(q, (snapshot) => {
  //     const itemsData = snapshot.docs.map(doc => {
  //       const data = doc.data();
  //       return {
  //         id: doc.id,
  //         description: data.description || '',
  //         imageUrl: data.imageUrl || null,
  //         itemName: data.itemName || 'Unnamed Item',
  //         location: data.location || 'Unknown Location',
  //         phone_number: data.phone_number || '',
  //         timestamp: data.timestamp?.toDate?.() || null,
  //         type: data.type || 'lost', // 'lost' or 'found'
  //         verified: data.verified || false,
  //         createdAt: data.createdAt?.toDate?.() || null
  //       };
  //     });

  //     setItems(itemsData);
      
  //     // Calculate statistics
  //     const totalItems = snapshot.size;
  //     const verifiedItems = snapshot.docs.filter(doc => doc.data().verified).length;
  //     const lostItems = snapshot.docs.filter(doc => doc.data().type === 'lost').length;
      
  //     setStats({
  //       total: totalItems,
  //       verified: verifiedItems,
  //       pending: totalItems - verifiedItems,
  //       lost: lostItems,
  //       found: totalItems - lostItems
  //     });
      
  //     setLoading(false);
  //   });

  //   return () => unsubscribe();
  // }, []);

  useEffect(() => {
    // Create two separate queries
    const unverifiedQuery = query(
      collection(db, 'lost_found'),
      where('verified', '==', false)
    );
    
    const allItemsQuery = query(collection(db, 'lost_found'));

    // Subscribe to both queries
    const unsubUnverified = onSnapshot(unverifiedQuery, (unverifiedSnapshot) => {
      const unverifiedItems = unverifiedSnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data(),
        createdAt: doc.data().createdAt?.toDate?.() || null
      }));
      setItems(unverifiedItems); // This remains your working list
    });

    const unsubAll = onSnapshot(allItemsQuery, (allSnapshot) => {
      // Calculate statistics from ALL items
      const totalItems = allSnapshot.size;
      const verifiedItems = allSnapshot.docs.filter(doc => doc.data().verified).length;
      const lostItems = allSnapshot.docs.filter(doc => doc.data().type === 'lost').length;
      
      setStats({
        total: totalItems,
        verified: verifiedItems,
        pending: totalItems - verifiedItems,
        lost: lostItems,
        found: totalItems - lostItems
      });
      
      setLoading(false);
    });

    return () => {
      unsubUnverified();
      unsubAll();
    };
  }, []);




  const verifyItem = async (itemId) => {
    setProcessingId(itemId);
    try {
      await updateDoc(doc(db, 'lost_found', itemId), {
        verified: true,
        verifiedAt: Timestamp.now(),
        status: 'approved'
      });
      toast.success('Item verified successfully!');
    } catch (error) {
      console.error('Verification error:', error);
      toast.error(`Verification failed: ${error.message}`);
    } finally {
      setProcessingId(null);
    }
  };

  const rejectItem = async (itemId) => {
    setProcessingId(itemId);
    try {
      await deleteDoc(doc(db, 'lost_found', itemId));
      toast.success('Item rejected successfully');
    } catch (error) {
      console.error('Rejection error:', error);
      toast.error(`Rejection failed: ${error.message}`);
    } finally {
      setProcessingId(null);
    }
  };

  return (
    <LostFoundContext.Provider value={{ 
      items, 
      verifyItem, 
      rejectItem,
      loading,
      processingId,
      stats
    }}>
      {children}
    </LostFoundContext.Provider>
  );
};