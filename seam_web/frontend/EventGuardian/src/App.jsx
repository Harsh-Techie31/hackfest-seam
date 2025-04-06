import { Route, Routes } from "react-router-dom";

import Sidebar from "./components/common/Sidebar";

import OverviewPage from "./pages/OverviewPage";

import UsersPage from "./pages/UsersPage";

import AnalyticsPage from "./pages/AnalyticsPage";
import SettingsPage from "./pages/SettingsPage";
import SentimentPage from "./pages/SentimentPage";
import HeatMapPage from "./pages/HeatMapPage";
import IssueResolver from "./pages/IssueResolver";
import { IssueProvider } from "./contexts/IssueContext";
import LostFoundPage from "./pages/LostFoundPage";
import { LostFoundProvider } from "./contexts/LostFoundContext";

function App() {
  return (
    <IssueProvider>
      <LostFoundProvider>
        

    <div className="flex h-screen bg-gray-900 text-gray-100 overflow-hidden">
      {/* BG */}
      <div className="fixed inset-0 z-0">
        <div className="absolute inset-0 bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 opacity-80" />
        <div className="absolute inset-0 backdrop-blur-sm" />
      </div>

      <Sidebar />
      <Routes>
        <Route path="/" element={<OverviewPage />} />

        <Route path="/users" element={<UsersPage />} />
        <Route path="/analytics" element={<AnalyticsPage />} />
        <Route path="/settings" element={<SettingsPage />} />
        <Route path="/sentiment-analysis" element={<SentimentPage />} />
        <Route path="/heatmap" element={<HeatMapPage />} />
        <Route path="/issueresolve" element={<IssueResolver />} />
        <Route path="/lostfound" element={<LostFoundPage />} /> 
      </Routes>
    </div>
      </LostFoundProvider>
      </IssueProvider>
  );
}

export default App;
