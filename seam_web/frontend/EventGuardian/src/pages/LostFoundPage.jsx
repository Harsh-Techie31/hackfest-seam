// // pages/IssueResolver.js
// import React, { useContext } from 'react';
// import { IssueContext } from '../contexts/IssueContext';
// import StatCard from '../components/common/StatCard';
// import Header from '../components/common/Header';
// import { Crosshair, CheckCheck, CircleDashed } from 'lucide-react';
// import { motion } from 'framer-motion';

// const IssueResolver = () => {
//   const { issues, stats, resolveIssue } = useContext(IssueContext);

//   // Filter unresolved issues
//  // console.log('Issues:', issues);
//   const unresolvedIssues = issues.filter(issue => !issue.resolved);

//   return (
//     <div className='flex-1 overflow-auto relative z-10 bg-gradient-to-br from-gray-900 to-gray-800 min-h-screen'>
//       <Header title='Lost & Found' />
      
//       <main className='max-w-7xl mx-auto py-6 px-4 lg:px-8'>
//         {/* STATS CARDS WITH ANIMATIONS */}
//         <motion.div
//           className='grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4 mb-8'
//           initial={{ opacity: 0, y: 20 }}
//           animate={{ opacity: 1, y: 0 }}
//           transition={{ duration: 0.5, staggerChildren: 0.1 }}
//         >
        //   <StatCard 
        //     name='Total Lost Requests Raised' 
        //     icon={Crosshair} 
        //     value={stats.total} 
        //     color='#6366F1' 
        //   />
        //   <StatCard 
        //     name='Requests Grated' 
        //     icon={CheckCheck} 
        //     value={stats.solved} 
        //     color='#8B5CF6' 
        //   />
        //   <StatCard 
        //     name='Rejected' 
        //     icon={CircleDashed} 
        //     value={stats.pending} 
        //     color='#EC4899' 
        //   />
//           {/* <StatCard 
//             name='Resolution Rate' 
//             icon={CheckCheck} 
//             value={`${Math.round(stats.happiness)}%`} 
//             color='#10B981' 
//           /> */}
//         </motion.div>

//         {/* ISSUES LIST */}
//         <motion.div
//           initial={{ opacity: 0 }}
//           animate={{ opacity: 1 }}
//           transition={{ delay: 0.3 }}
//           className="bg-gray-800/30 backdrop-blur-sm rounded-xl shadow-xl p-6 border border-gray-700/50"
//         >
//           <div className="flex justify-between items-center mb-6">
//             <h2 className="text-2xl font-bold text-gray-100">
//               Incoming Requests <span className="text-gray-400">({unresolvedIssues.length})</span>
//             </h2>
//           </div>

//           {unresolvedIssues.length === 0 ? (
//             <motion.div
//               initial={{ opacity: 0 }}
//               animate={{ opacity: 1 }}
//               className="text-center py-12"
//             >
//               <p className="text-gray-400 text-lg">No pending issues - great job!</p>
//             </motion.div>
//           ) : (
//             <div className="space-y-3">
//               {unresolvedIssues.map((issue, index) => (
//                 <motion.div
//                   key={issue.id}
//                   initial={{ opacity: 0, y: 10 }}
//                   animate={{ opacity: 1, y: 0 }}
//                   transition={{ delay: index * 0.05 }}
//                   className="flex items-center justify-between p-5 rounded-lg bg-gray-700/30 hover:bg-gray-700/50 transition-colors border border-gray-700/50"
//                 >
//                   <div className="flex-1 min-w-0">
//                     <h3 className="text-lg font-medium text-gray-100 truncate">
//                       {issue.title  || 'Untitled Issue'}
//                     </h3>
//                     {issue.description && (
//                       <p className="text-sm text-gray-400 mt-1 truncate">
//                         {issue.description}
//                       </p>
//                     )}
//                   </div>
                //   <button
                //     onClick={() => resolveIssue(issue.id)}
                //     className="ml-4 px-4 py-2 bg-green-600 hover:bg-green-700 text-white font-medium rounded-lg transition-all duration-200 transform hover:scale-105 active:scale-95 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 focus:ring-offset-gray-800"
                //   >
                //     Verified
                //   </button>

                //   <button
                //     onClick={() => handleReject(issue.id)} // You can define this function
                //     className="ml-4 px-4 py-2 bg-red-600 hover:bg-red-700 text-white font-medium rounded-lg transition-all duration-200 transform hover:scale-105 active:scale-95 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 focus:ring-offset-gray-800"
                //     >
                //     Rejected
                //     </button>

//                 </motion.div>
//               ))}
//             </div>
//           )}
//         </motion.div>
//       </main>
//     </div>
//   );
// };

// export default IssueResolver;



// import { useContext } from 'react';
// import { LostFoundContext } from '../contexts/LostFoundContext';
// import StatCard from '../components/common/StatCard';
// import Header from '../components/common/Header';
// import { Crosshair, CheckCheck, CircleDashed } from 'lucide-react';
// import { motion } from 'framer-motion';
// import { useState } from 'react';


// const LostFoundPage = () => {
//   const { items, verifyItem, rejectItem } = useContext(LostFoundContext);

// //   return (
// //     <div className="max-w-4xl mx-auto p-6">
// //       <h2 className="text-2xl font-bold mb-6 text-gray-800">Pending Lost & Found Items</h2>
      
// //       {items.length === 0 ? (
// //         <p className="text-gray-500 italic">No pending items to review</p>
// //       ) : (
// //         <ul className="space-y-4">
// //           {items.map(item => (
// //             <li key={item.id} className="border border-gray-200 rounded-lg p-4 shadow-sm hover:shadow-md transition-shadow">
// //               <div className="flex flex-col md:flex-row gap-4">
// //                 {/* Item Image */}
// //                 {item.imageUrl && (
// //                   <div className="w-full md:w-48 flex-shrink-0">
// //                     <img 
// //                       src={item.imageUrl} 
// //                       alt={item.title} 
// //                       className="w-full h-48 object-cover rounded-lg"
// //                     />
// //                   </div>
// //                 )}
                
// //                 {/* Item Details */}
// //                 <div className="flex-1">
// //                   <h3 className="text-lg font-semibold text-gray-800">{item.title}</h3>
// //                   <p className="text-gray-600 mt-1">{item.description}</p>
// //                   <p className="text-sm text-gray-500 mt-2">
// //                     <span className="font-medium">Location:</span> {item.location}
// //                   </p>
// //                   <p className="text-sm text-gray-500">
// //                     <span className="font-medium">Submitted:</span> {new Date(item.createdAt).toLocaleString()}
// //                   </p>
// //                 </div>
                
// //                 {/* Action Buttons */}
// //                 <div className="flex md:flex-col gap-2 justify-end">
// //                   <button
// //                     onClick={() => verifyItem(item.id)}
// //                     className="px-4 py-2 bg-green-500 text-white rounded-md hover:bg-green-600 transition-colors flex items-center gap-2"
// //                   >
// //                     <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
// //                       <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
// //                     </svg>
// //                     Verify
// //                   </button>
// //                   <button
// //                     onClick={() => rejectItem(item.id)}
// //                     className="px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-600 transition-colors flex items-center gap-2"
// //                   >
// //                     <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
// //                       <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
// //                     </svg>
// //                     Reject
// //                   </button>
// //                 </div>
// //               </div>
// //             </li>
// //           ))}
// //         </ul>
// //       )}
// //     </div>
// //   );
// // };

// return (
//     <div className='flex-1 overflow-auto relative z-10 bg-gradient-to-br from-gray-900 to-gray-800 min-h-screen'>
//       <Header title='Issue Resolver' />
      
//       <main className='max-w-7xl mx-auto py-6 px-4 lg:px-8'>
//         {/* STATS CARDS WITH ANIMATIONS */}
//         <motion.div
//           className='grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4 mb-8'
//           initial={{ opacity: 0, y: 20 }}
//           animate={{ opacity: 1, y: 0 }}
//           transition={{ duration: 0.5, staggerChildren: 0.1 }}
//         >
//               <StatCard 
//             name='Total Lost Requests Raised' 
//             icon={Crosshair} 
//             value={1} 
//             color='#6366F1' 
//           />
//           <StatCard 
//             name='Requests Grated' 
//             icon={CheckCheck} 
//             value={1} 
//             color='#8B5CF6' 
//           />
//           <StatCard 
//             name='Rejected' 
//             icon={CircleDashed} 
//             value={1} 
//             color='#EC4899' 
//           />
//         </motion.div>

//         {/* ISSUES LIST */}
//         <motion.div
//           initial={{ opacity: 0 }}
//           animate={{ opacity: 1 }}
//           transition={{ delay: 0.3 }}
//           className="bg-gray-800/30 backdrop-blur-sm rounded-xl shadow-xl p-6 border border-gray-700/50"
//         >
//           <div className="flex justify-between items-center mb-6">
//             <h2 className="text-2xl font-bold text-gray-100">
//               Current Issues <span className="text-gray-400">({unresolvedIssues.length})</span>
//             </h2>
//           </div>

//           {unresolvedIssues.length === 0 ? (
//             <motion.div
//               initial={{ opacity: 0 }}
//               animate={{ opacity: 1 }}
//               className="text-center py-12"
//             >
//               <p className="text-gray-400 text-lg">No pending issues - great job!</p>
//             </motion.div>
//           ) : (
//             <div className="space-y-3">
//               {unresolvedIssues.map((issue, index) => (
//                 <motion.div
//                   key={issue.id}
//                   initial={{ opacity: 0, y: 10 }}
//                   animate={{ opacity: 1, y: 0 }}
//                   transition={{ delay: index * 0.05 }}
//                   className="flex items-center justify-between p-5 rounded-lg bg-gray-700/30 hover:bg-gray-700/50 transition-colors border border-gray-700/50"
//                 >
//                   <div className="flex-1 min-w-0">
//                     <h3 className="text-lg font-medium text-gray-100 truncate">
//                       {issue.title  || 'Untitled Issue'}
//                     </h3>
//                     {issue.description && (
//                       <p className="text-sm text-gray-400 mt-1 truncate">
//                         {issue.description}
//                       </p>
//                     )}
//                   </div>
 
//                   <button
//                     onClick={() => verifyItem(items.id)}
//                     className="ml-4 px-4 py-2 bg-green-600 hover:bg-green-700 text-white font-medium rounded-lg transition-all duration-200 transform hover:scale-105 active:scale-95 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 focus:ring-offset-gray-800"
//                   >
//                     Verified
//                   </button>

//                   <button
//                     onClick={() => rejectItem(items.id)} // You can define this function
//                     className="ml-4 px-4 py-2 bg-red-600 hover:bg-red-700 text-white font-medium rounded-lg transition-all duration-200 transform hover:scale-105 active:scale-95 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 focus:ring-offset-gray-800"
//                     >
//                     Rejected
//                     </button>

//                 </motion.div>
//               ))}
//             </div>
//           )}
//         </motion.div>
//       </main>
//     </div>
//   );
// };


// export default LostFoundPage;







//try 3=---------------------->



import { useContext } from 'react';
import { LostFoundContext } from '../contexts/LostFoundContext';
import StatCard from '../components/common/StatCard';
import Header from '../components/common/Header';
import { Crosshair, CheckCheck, CircleDashed } from 'lucide-react';
import { motion } from 'framer-motion';

const LostFoundPage = () => {
    const { items, verifyItem, rejectItem, loading, processingId, stats } = useContext(LostFoundContext);
    // Remove local stats calculations since we're using context stats
  
    return (
      <div className='flex-1 overflow-auto relative z-10 bg-gradient-to-br from-gray-900 to-gray-800 min-h-screen'>
        <Header title='Lost & Found Management' />
        
        <main className='max-w-7xl mx-auto py-6 px-4 lg:px-8'>
          {/* STATS CARDS - NOW USING CONTEXT STATS */}
          <motion.div
            className='grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4 mb-8'
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, staggerChildren: 0.1 }}
          >
            <StatCard 
              name='Total Items Reported' 
              icon={Crosshair} 
              value={stats.total} 
              color='#6366F1' 
            />
            <StatCard 
              name='Verified Items' 
              icon={CheckCheck} 
              value={stats.verified} 
              color='#8B5CF6' 
            />
            <StatCard 
              name='Pending Review' 
              icon={CircleDashed} 
              value={stats.pending} 
              color='#EC4899' 
            />
          </motion.div>
  
        {/* LOST & FOUND ITEMS LIST */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.3 }}
          className="bg-gray-800/30 backdrop-blur-sm rounded-xl shadow-xl p-6 border border-gray-700/50"
        >
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-2xl font-bold text-gray-100">
              Pending Items <span className="text-gray-400">({items.length})</span>
            </h2>
          </div>

          {loading ? (
            <div className="flex justify-center items-center h-64">
              <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-purple-500"></div>
            </div>
          ) : items.length === 0 ? (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="text-center py-12"
            >
              <p className="text-gray-400 text-lg">No items awaiting verification</p>
            </motion.div>
          ) : (
            <div className="space-y-4">
              {items.map((item, index) => (
                <motion.div
                  key={item.id}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.05 }}
                  className="flex flex-col md:flex-row items-start md:items-center justify-between p-5 rounded-lg bg-gray-700/30 hover:bg-gray-700/50 transition-colors border border-gray-700/50 gap-4"
                >
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start gap-4">
                      {item.imageUrl && (
                        <img 
                          src={item.imageUrl} 
                          alt={item.title || 'Lost item'}
                          className="w-16 h-16 md:w-20 md:h-20 object-cover rounded-lg"
                        />
                      )}
                      <div>
                        <h3 className="text-lg font-medium text-gray-100">
                          {item.title || 'Untitled Item'}
                        </h3>
                        {item.description && (
                          <p className="text-sm text-gray-400 mt-1">
                            {item.description}
                          </p>
                        )}
                        <div className="mt-2 text-xs text-gray-500">
                          {item.location && (
                            <p>Location: {item.location}</p>
                          )}
                          {item.createdAt && (
                            <p>Reported: {new Date(item.createdAt).toLocaleString()}</p>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className="flex gap-3 w-full md:w-auto">
                    <button
                      onClick={() => verifyItem(item.id)}
                      disabled={processingId === item.id}
                      className={`px-4 py-2 rounded-lg font-medium transition-all duration-200 flex-1 md:flex-none ${
                        processingId === item.id
                          ? 'bg-green-700 cursor-not-allowed'
                          : 'bg-green-600 hover:bg-green-700'
                      } text-white`}
                    >
                      {processingId === item.id ? 'Verifying...' : 'Verify'}
                    </button>
                    <button
                      onClick={() => rejectItem(item.id)}
                      disabled={processingId === item.id}
                      className={`px-4 py-2 rounded-lg font-medium transition-all duration-200 flex-1 md:flex-none ${
                        processingId === item.id
                          ? 'bg-red-700 cursor-not-allowed'
                          : 'bg-red-600 hover:bg-red-700'
                      } text-white`}
                    >
                      {processingId === item.id ? 'Rejecting...' : 'Reject'}
                    </button>
                  </div>
                </motion.div>
              ))}
            </div>
          )}
        </motion.div>
      </main>
    </div>
  );
};

export default LostFoundPage;