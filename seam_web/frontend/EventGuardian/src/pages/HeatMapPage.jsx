import React from 'react'
import Header from '../components/common/Header'
import Heatmap1 from '../components/analytics/Heatmap1'


function HeatMapPage() {
    return (
        <>
		<div className='flex-1 overflow-auto relative z-10'>
			<Header title='HeatMap' />
            <Heatmap1 />
        </div>
        </>
            )
            }

export default HeatMapPage