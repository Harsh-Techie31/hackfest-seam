import React from 'react'




export default function getComplaints() {
    const [complaints, setComplaints] = React.useState([]);
    const [loading, setLoading] = React.useState(true);
    const [error, setError] = React.useState(null);

    React.useEffect(() => {
        const fetchComplaints = async () => {
            try {
                const response = await fetch('/http://localhost:4000/complaints'); // Adjust the API endpoint as needed
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                const data = await response.json();
                console.log(data);
                setComplaints(data);
            } catch (error) {
                setError(error);
            } finally {
                setLoading(false);
            }
        };

        fetchComplaints();
    }, []);

    return { complaints, loading, error };
}   