// useSpamDetection.js
import { useCallback } from 'react';

export const useSpamDetection = () => {
  const perspectiveKey = import.meta.env.VITE_PERSPECTIVE_API_KEY;

  const detectSpam = useCallback(async (text) => {
    try {
      const response = await fetch(
        `https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=${perspectiveKey}`,
        {
          method: "POST",
          body: JSON.stringify({
            comment: { text },
            requestedAttributes: { SPAM: {} }
          }),
          headers: {
            "Content-Type": "application/json",
          },
        }
      );

      const result = await response.json();
      const score = result.attributeScores.SPAM.summaryScore.value;

      return score > 0.8; // You can tweak this threshold
    } catch (error) {
      console.error("Error detecting spam:", error);
      return false;
    }
  }, [perspectiveKey]);

  return { detectSpam };
};
