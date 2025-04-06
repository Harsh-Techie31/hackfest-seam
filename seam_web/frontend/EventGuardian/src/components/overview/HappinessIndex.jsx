// import React from "react";
// import ReactSpeedometer from "react-d3-speedometer";
// import { IssueContext } from "../../contexts/IssueContext";

// const HappinessIndex = ({ value }) => {
//     const {stats} =React.useContext(IssueContext);
//   return (
//     <>
//     <div className="flex justify-center items-center p-10 ">
//       <ReactSpeedometer
//         value={stats.happiness}
//         minValue={0}
//         maxValue={100}
//         segments={20}
//         needleColor="white"
//         startColor="red"
//         endColor="green"
//         textColor="white"
//         fluidWidth={true} // Ensures it adapts to the parent container
//       />
//     </div>
    
//       </>
//   );
// };

// export default HappinessIndex;


import React from "react";
import ReactSpeedometer from "react-d3-speedometer";
import { IssueContext } from "../../contexts/IssueContext";

const HappinessIndex = ({ value }) => {
  const { stats } = React.useContext(IssueContext);

  // Fallback if value is undefined
  const happinessValue = value ?? stats?.happiness ?? 0;

  return (
    <div className="w-full lg:w-[500px] h-[300px] flex justify-center items-center p-4">
      <ReactSpeedometer
        value={happinessValue}
        minValue={0}
        maxValue={100}
        segments={20}
        needleColor="white"
        startColor="red"
        endColor="green"
        textColor="white"
        height={300}
        width={500}
      />
    </div>
  );
};

export default HappinessIndex;
