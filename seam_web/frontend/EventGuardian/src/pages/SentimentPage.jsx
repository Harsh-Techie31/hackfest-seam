import React from 'react'
import Header from '../components/common/Header'
import { UserCheck, UsersIcon,UserX,UserPlus} from 'lucide-react'
import StatCard from '../components/common/StatCard'
import { motion } from 'framer-motion'
import { useState } from 'react'

function SentimentPage() {


  const [data, setData] = useState([]);
  const [userInput, setUserInput] = useState("");
  const [countP,setCountP] = useState(0);
  const [countX,setCountX] = useState(0);
  const [tUser,settUser] = useState(0);
  const [isLoading, setIsLoading] = useState(false);

  const apiKey = import.meta.env.VITE_API_KEY; // API key from .env
  const hfApiKey = import.meta.env.VITE_HF_API_KEY; // Hugging Face API key

  async function analyzeSentiment(text) {
    try {
        const response = await fetch(
            "https://api-inference.huggingface.co/models/distilbert/distilbert-base-uncased-finetuned-sst-2-english",
            {
                headers: {
                    Authorization: `Bearer ${hfApiKey}`,
                    "Content-Type": "application/json",
                },
                method: "POST",
                body: JSON.stringify({ inputs: text }),
            }
        );
        const result = await response.json();
        console.log("Hugging Face Response:", result); // Debugging log

        console.log("rsult[0]=>" ,result[0][0].label)
   
        // const toReturn = result[0][0].score>0.6?result[0][0].label:'NEUTRAL';

        const sentimentLabel = result[0][0].score > 0.9 ? result[0][0].label : "NEUTRAL";

        // Use functional updates for state to avoid stale values
        if (sentimentLabel === "POSITIVE") {
            setCountP(prev => prev + 1);
        } else if (sentimentLabel === "NEGATIVE") {
            setCountX(prev => prev + 1);
        } else {
            settUser(prev => prev + 1);
        }

        return sentimentLabel;

    } catch (error) {
        console.error("Error analyzing sentiment:", error);
        return "Error";
    }
    finally{
      setIsLoading(false);
    }
}


  const handleSubmit = async () => {
    if (!userInput.trim()) return; // Prevent empty submission
  
  setData([]);
  setCountP(0);
  setCountX(0);
  settUser(0);
  setIsLoading(true);


    const requestOptions = {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        lang:"en",
        near:"India",
        maxItems: 10,
        searchTerms: [userInput],
      }),
    };

    try {
      const response = await fetch(
        `https://api.apify.com/v2/actor-tasks/atulyasrivastava~tweet-scraper/run-sync-get-dataset-items?token=${apiKey}`,
        requestOptions
      );
      const result = await response.json();

      // Process tweets and send them to Hugging Face
      const formattedData = await Promise.all(
        result.map(async (item) => {
          const sentimentResponse = await analyzeSentiment(item.text);
          console.log(sentimentResponse);
          return {
            text: item.text,
            username: item.author.userName,
            sentiment: sentimentResponse
          };
        })
      );

      setData(formattedData);
      console.log("Fetched Data with Sentiment:", formattedData);
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  };







  return (
    <div className='flex-1 overflow-auto relative z-10 bg-gray-900'>
    <Header title={"Sentiment Analysis"} />

    <main className='max-w-7xl mx-auto py-6 px-4 lg:px-8'>
    <motion.div
					className='grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4 mb-8'
					initial={{ opacity: 0, y: 20 }}
					animate={{ opacity: 1, y: 0 }}
					transition={{ duration: 1 }}
				>
          
    <StatCard
						name='Total Fetched'
						icon={UsersIcon}
						value={countP+countX+tUser}
						color='#6366F1'
            />
          <StatCard
						name='% Positive'
						icon={UserCheck}
            value={
              countP + countX + tUser === 0
                  ? "0%"
                  : `${((countP * 100) / (countP + countX + tUser)).toFixed(2)} %`
          }						color='#10B981'
            />
            
            <StatCard name='% Neutral' icon={UserPlus}   value={
        countP + countX + tUser === 0
            ? "0%"
            : `${((tUser * 100) / (countP + countX + tUser)).toFixed(2)} %`
    } color='#F59E0B' />

          <StatCard
						name='% Negative'
						icon={UserX}
            value={
              countP + countX + tUser === 0
                  ? "0%"
                  : `${((countX * 100) / (countP + countX + tUser)).toFixed(2)} %`
          }
						color='#EF4444'
            />
       </motion.div>
<div className='flex flex-row justify-start gap-4'>

       <input
						type='text'
						placeholder='Enter the query to be searched'
						className='bg-gray-700 w-[300px] text-white placeholder-gray-400 rounded-lg pl-4 pr-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 mb-2'
            onChange={(e) => setUserInput(e.target.value)}
            value={userInput}
            />
          <button  onClick={handleSubmit} className='bg-blue-600 p-2 h-[40px] rounded-md '>Search</button>
          {/* <p className='font-semibold'>Fetched Data :-</p> */}

          {isLoading && (
            
            <div className="animate-spin rounded-full h-8 w-8 border-4 border-white border-t-transparent mt-1"></div>
            
          )}
          </div>

          {/* table from here-------> */}
          <table className="w-full text-white border-collapse mt-4">
  <thead>
    <tr className="bg-gray-700">
      <th className="text-left py-2 px-4 w-[10%]">Username</th>
      <th className="text-left py-2 px-4 w-[80%]">Tweet</th>
      <th className="text-left py-2 px-4 w-[10%]">Sentiment</th>
    </tr>
  </thead>

   {/* loader */}



  <tbody>
    {data.map((item, index) => (
      <tr key={index} className={`${index % 2 === 0 ? "bg-gray-800" : "bg-gray-900"} border-b`}>
        <td className="py-2 px-4 font-semibold">{item.username}</td>
        <td className="py-2 px-4">{item.text}</td>
        <td className="py-2 px-4">
          <span
            className={`px-2 py-1 rounded-md text-white 
              ${item.sentiment === "POSITIVE" ? "bg-green-600" : 
                item.sentiment === "NEGATIVE" ? "bg-red-600" : 
                "bg-yellow-500"}`}
          >
            {item.sentiment}
          </span>
        </td>
      </tr>
    ))}
  </tbody>
          </table>

          </main>
  </div>
  )
}

export default SentimentPage