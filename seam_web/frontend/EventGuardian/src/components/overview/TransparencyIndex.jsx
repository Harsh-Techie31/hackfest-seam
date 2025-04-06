import React from "react";

const getBoxColor = (value) => {
  if (value >= 9) return "bg-green-700 text-white";
  if (value >= 8) return "bg-yellow-400 text-black";
  if (value >= 7) return "bg-orange-400 text-black";
  if (value >= 5) return "bg-red-500 text-white";
  return "bg-red-800 text-white";
};

const TransparencyIndex = ({ value =9.8 }) => {
  const colorClass = getBoxColor(value);


  return (

<>
    
      <div className="flex items-center space-x-4">
        <h2 className="text-lg font-semibold">Transparency Index:</h2>
        <div
          className={`flex items-center justify-center px-4 py-2 rounded-xl text-5xl w-[90px] h-[90px] text-center font-bold shadow-md ${colorClass}`}
          >
          {value.toFixed(1)}
        </div>
      </div>
        </>
  );
};

export default TransparencyIndex;