// import React, { useEffect } from "react";
// import { MapContainer, TileLayer } from "react-leaflet";
// import "leaflet/dist/leaflet.css";
// import L from "leaflet";
// import "leaflet.heat";

// const Heatmap = () => {
//   const position = [51.505, -0.09]; // Center of the map
//   const heatmapPoints = [
//     [51.505, -0.09, 0.5], // [lat, lng, intensity]
//     [51.51, -0.1, 0.8],
//     [51.52, -0.12, 0.3],
//   ];

//   useEffect(() => {
//     // ✅ Check if the map is already initialized
//     if (L.DomUtil.get("heatmap") !== null) {
//       L.DomUtil.get("heatmap")._leaflet_id = null;
//     }

//     const map = L.map("heatmap").setView(position, 13);

//     L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
//       attribution: "© OpenStreetMap contributors",
//     }).addTo(map);

//     L.heatLayer(heatmapPoints, { radius: 25 }).addTo(map);
//   }, []);

//   return <div id="heatmap" style={{ height: "500px", width: "100%" }} />;
// };

// export default Heatmap;

// import React, { useEffect } from 'react';
// import { MapContainer, TileLayer, useMap } from 'react-leaflet';
// import 'leaflet/dist/leaflet.css';
// import L from 'leaflet';

// const Heatmap = () => {
//   const mapContainerRef = React.useRef(null);
//   const mapRef = React.useRef(null);

//   useEffect(() => {
//     if (!mapContainerRef.current) return;

//     // Initialize map
//     mapRef.current = L.map(mapContainerRef.current).setView([51.505, -0.09], 13);

//     L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
//       attribution: '&copy; OpenStreetMap contributors'
//     }).addTo(mapRef.current);

//     // Dynamically load heatmap library
//     const script = document.createElement('script');
//     script.src = 'https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js';
//     script.onload = () => {
//       const heatPoints = [
//         [51.505, -0.09, 1],
//         [51.51, -0.1, 0.5],
//         [51.52, -0.12, 0.8]
//       ];
//       L.heatLayer(heatPoints, { radius: 25 }).addTo(mapRef.current);
//     };
//     document.head.appendChild(script);

//     return () => {
//       if (mapRef.current) {
//         mapRef.current.remove();
//       }
//       document.head.removeChild(script);
//     };
//   }, []);

//   return <div ref={mapContainerRef} style={{ height: '500px', width: '100%' }} />;
// };

// export default Heatmap;


import React, { useEffect } from 'react';
import { MapContainer, TileLayer, useMap } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';

const Heatmap = () => {
  const mapContainerRef = React.useRef(null);
  const mapRef = React.useRef(null);

  useEffect(() => {
    if (!mapContainerRef.current) return;

    // Initialize map with IIT ISM Dhanbad coordinates
    mapRef.current = L.map(mapContainerRef.current).setView([23.8144, 86.4412], 15);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors'
    }).addTo(mapRef.current);

    // Dynamically load heatmap library
    const script = document.createElement('script');
    script.src = 'https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js';
    script.onload = () => {
      const heatPoints = [
        [23.8144, 86.4412, 1],   // Central location
        [23.8150, 86.4420, 0.9], // Nearby point
        [23.8125, 86.4405, 0.8],
        [23.8132, 86.4398, 1],
        [23.8160, 86.4430, 0.7],
        [23.8170, 86.4450, 1],   // Higher intensity
        [23.8185, 86.4442, 0.9],
        [23.8120, 86.4385, 1]
      ];
      L.heatLayer(heatPoints, { radius: 30, blur: 15, maxZoom: 17 }).addTo(mapRef.current);
    };
    document.head.appendChild(script);

    return () => {
      if (mapRef.current) {
        mapRef.current.remove();
      }
      document.head.removeChild(script);
    };
  }, []);

  return <div ref={mapContainerRef} style={{ height: '500px', width: '100%' }} />;
};

export default Heatmap;
 
