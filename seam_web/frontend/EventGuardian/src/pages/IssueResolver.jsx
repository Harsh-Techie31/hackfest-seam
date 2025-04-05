// pages/IssueResolver.js
import React, { useContext } from 'react';
import { IssueContext } from '../contexts/IssueContext';
import StatCard from '../components/common/StatCard';
import Header from '../components/common/Header';
import { Crosshair, CheckCheck, CircleDashed } from 'lucide-react';
import { motion } from 'framer-motion';

const IssueResolver = () => {
  const { issues, stats, resolveIssue } = useContext(IssueContext);

  // Filter unresolved issues
 // console.log('Issues:', issues);
  const unresolvedIssues = issues.filter(issue => !issue.resolved);

  return (
    <div className='flex-1 overflow-auto relative z-10 bg-gradient-to-br from-gray-900 to-gray-800 min-h-screen'>
      <Header title='Issue Resolver' />
      
      <main className='max-w-7xl mx-auto py-6 px-4 lg:px-8'>
        {/* STATS CARDS WITH ANIMATIONS */}
        <motion.div
          className='grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4 mb-8'
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, staggerChildren: 0.1 }}
        >
          <StatCard 
            name='Total Issues Raised' 
            icon={Crosshair} 
            value={stats.total} 
            color='#6366F1' 
          />
          <StatCard 
            name='Issues Resolved' 
            icon={CheckCheck} 
            value={stats.solved} 
            color='#8B5CF6' 
          />
          <StatCard 
            name='Pending Issues' 
            icon={CircleDashed} 
            value={stats.pending} 
            color='#EC4899' 
          />
          <StatCard 
            name='Resolution Rate' 
            icon={CheckCheck} 
            value={`${Math.round(stats.happiness)}%`} 
            color='#10B981' 
          />
        </motion.div>

        {/* ISSUES LIST */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.3 }}
          className="bg-gray-800/30 backdrop-blur-sm rounded-xl shadow-xl p-6 border border-gray-700/50"
        >
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-2xl font-bold text-gray-100">
              Current Issues <span className="text-gray-400">({unresolvedIssues.length})</span>
            </h2>
          </div>

          {unresolvedIssues.length === 0 ? (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="text-center py-12"
            >
              <p className="text-gray-400 text-lg">No pending issues - great job!</p>
            </motion.div>
          ) : (
            <div className="space-y-3">
              {unresolvedIssues.map((issue, index) => (
                <motion.div
                  key={issue.id}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.05 }}
                  className="flex items-center justify-between p-5 rounded-lg bg-gray-700/30 hover:bg-gray-700/50 transition-colors border border-gray-700/50"
                >
                  <div className="flex-1 min-w-0">
                    <h3 className="text-lg font-medium text-gray-100 truncate">
                      {issue.title  || 'Untitled Issue'}
                    </h3>
                    {issue.description && (
                      <p className="text-sm text-gray-400 mt-1 truncate">
                        {issue.description}
                      </p>
                    )}
                  </div>
                  <button
                    onClick={() => resolveIssue(issue.id)}
                    className="ml-4 px-4 py-2 bg-green-600 hover:bg-green-700 text-white font-medium rounded-lg transition-all duration-200 transform hover:scale-105 active:scale-95 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 focus:ring-offset-gray-800"
                  >
                    Mark Resolved
                  </button>
                </motion.div>
              ))}
            </div>
          )}
        </motion.div>
      </main>
    </div>
  );
};

export default IssueResolver;