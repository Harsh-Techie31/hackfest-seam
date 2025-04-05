// import React from "react";
// import ReactSpeedometer from "react-d3-speedometer";

// const HappinessIndex = ({ value }) => {
//   return (
//     <div className="flex justify-center items-center p-4 bg-gray-100 rounded-lg shadow-md">
//       <ReactSpeedometer
//         value={value}
//         minValue={0}
//         maxValue={100}
//         segments={5}
//         needleColor="red"
//         startColor="green"
//         endColor="red"
//         textColor="black"
//       />
//     </div>
//   );
// };

// export default HappinessIndex;


import React from "react";
import ReactSpeedometer from "react-d3-speedometer";
import { IssueContext } from "../../contexts/IssueContext";

const HappinessIndex = ({ value }) => {
    const {stats} =React.useContext(IssueContext);
  return (
    <>
    <div className="flex justify-center items-center p-10 ">
      <ReactSpeedometer
        value={stats.happiness}
        minValue={0}
        maxValue={100}
        segments={20}
        needleColor="white"
        startColor="red"
        endColor="green"
        textColor="white"
        fluidWidth={true} // Ensures it adapts to the parent container
        // segmentColors={["red", "orange", "yellow", "green"]}
      />
    </div>
      {/* <h1>hello</h1> */}
      </>
  );
};

export default HappinessIndex;
