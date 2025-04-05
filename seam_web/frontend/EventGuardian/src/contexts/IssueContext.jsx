import { createContext, useState, useEffect } from 'react';

export const IssueContext = createContext();

export const IssueProvider = ({ children }) => {
  const [issues, setIssues] = useState([]);
  const [stats, setStats] = useState({
    pending: 0,
    solved: 0,
    total: 0,
    happiness: 0
  });

  // Fetch issues from backend
  useEffect(() => {
    const fetchIssues = async () => {
      try {
        const res = await fetch('http://localhost:4000/complaints');
        const data = await res.json();
        
        const complaints = data.complaints.map(complaint => ({

          id: complaint.id,
          title: complaint.complaint_category, // or whatever your backend field is
          description: complaint.complaint, // adjust as needed
          resolved: complaint.resolved || false, // assuming resolved is a boolean
        }));
//console.log(complaints);
        setIssues(complaints);

        const solved = complaints.filter(issue => issue.resolved).length;
        const pending = complaints.length - solved;
        const happiness = complaints.length > 0 ? 
          (solved / complaints.length) * 100 : 0;

        setStats({
          pending,
          solved,
          total: complaints.length,
          happiness: Math.round(happiness)
        });
      } catch (err) {
        console.error('Error fetching issues:', err);
      }
    };

    fetchIssues();
  }, []);

  const resolveIssue = async(issueId) => {
    try {
      const res = await fetch(`http://localhost:4000/resolve?id=${issueId}`, { //changed delete to resolve
        // method: 'DELETE'
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
      }); //changed here........
      const data = await res.json();
      console.log(data);
    } catch (error) {
      console.error('Error resolving issue:', error);
    }
  
    // Remove the issue visually but don’t affect total count
    setIssues(prevIssues => {
      return prevIssues.map(issue =>
        issue.id === issueId ? { ...issue, resolved: true } : issue
      );
    });
  
    // Update stats - total remains unchanged
    setStats(prevStats => {
      const newSolved = prevStats.solved + 1;
      const newPending = prevStats.pending - 1;
      const happiness = (newSolved / prevStats.total) * 100;
  
      return {
        ...prevStats,
        solved: newSolved,
        pending: newPending,
        happiness: Math.round(happiness)
      };
    });
  };
  
  

  return (
    <IssueContext.Provider value={{ issues, stats, resolveIssue }}>
      {children}
    </IssueContext.Provider>
  );
};