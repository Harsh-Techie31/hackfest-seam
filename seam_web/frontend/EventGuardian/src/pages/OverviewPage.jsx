import { BarChart2, CheckCheck, CircleDashed, Crosshair, ShoppingBag, Users, Zap } from "lucide-react";
import { motion } from "framer-motion";
import  { useContext } from 'react';
import Header from "../components/common/Header";
import StatCard from "../components/common/StatCard";
import SalesOverviewChart from "../components/overview/SalesOverviewChart";
import CategoryDistributionChart from "../components/overview/CategoryDistributionChart";
import SalesChannelChart from "../components/overview/SalesChannelChart";
import HappinessIndex from "../components/overview/HappinessIndex";
import { IssueContext } from "../contexts/IssueContext";
import TransparencyIndex from "../components/overview/TransparencyIndex";

const OverviewPage = () => {
	const { stats } = useContext(IssueContext);

	return (
		<div className='flex-1 overflow-auto relative z-10'>
			<Header title='Overview' />

			<main className='max-w-7xl mx-auto py-6 px-4 lg:px-8'>
				{/* STATS */}
				<motion.div
					className='grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4 mb-8'
					initial={{ opacity: 0, y: 20 }}
					animate={{ opacity: 1, y: 0 }}
					transition={{ duration: 1 }}
				>
					 <StatCard name='Total Issues Raised' icon={Crosshair} value={stats.total} color='#6366F1' />
           			 <StatCard name='Issues Resolved' icon={CheckCheck} value={stats.solved} color='#8B5CF6' />
           			 <StatCard name='Pending issues' icon={CircleDashed} value={stats.pending} color='#EC4899' />
					{/* <StatCard name='Conversion Rate' icon={BarChart2} value='12.5%' color='#10B981' /> */}
				</motion.div>

				{/* CHARTS */}

				{/* grid grid-cols-1 lg:grid-cols-2 gap-8  */}
				{/* <div className='	grid grid-cols-1 lg:grid-cols-2 gap-2'>
					<HappinessIndex value={stats.happiness} />
					<CategoryDistributionChart />
					<TransparencyIndex/>
		
				</div> */}


					<div className="grid grid-cols-1 lg:grid-cols-2 gap-2">
					{/* Row 1 - Column 1 */}
					<div className="row-span-1">
						<HappinessIndex value={stats.happiness} />
					</div>

					{/* Row 1 - Column 2 */}
					<div className="row-span-1">
						<CategoryDistributionChart />
					</div>

					{/* Row 2 - spans only first column */}
					<div className="lg:col-span-1">
						{/* <TransparencyIndex /> */}
					</div>
					</div>


			</main>
		</div>
	);
};
export default OverviewPage;
