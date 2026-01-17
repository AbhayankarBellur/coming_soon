import { useState, useEffect } from 'react';
import SplashScreen from './SplashScreen';
import ComingSoon from './ComingSoon';

const SPLASH_SEEN_KEY = 'loading_animation_splash_seen_session';

function App() {
  const [showSplash, setShowSplash] = useState(false);
  const [isInitialized, setIsInitialized] = useState(false);
  const [contentVisible, setContentVisible] = useState(false);

  useEffect(() => {
    // Use sessionStorage - persists only for current browser session
    const hasSeenSplash = sessionStorage.getItem(SPLASH_SEEN_KEY);
    
    if (!hasSeenSplash) {
      setShowSplash(true);
    } else {
      // If already seen, show content immediately
      setContentVisible(true);
    }
    
    setIsInitialized(true);
  }, []);

  const handleSplashComplete = () => {
    sessionStorage.setItem(SPLASH_SEEN_KEY, 'true');
    setShowSplash(false);
    // Small delay for smooth DOM entry
    setTimeout(() => setContentVisible(true), 50);
  };

  // Don't render anything until initialized to prevent flash
  if (!isInitialized) {
    return <div className="fixed inset-0 bg-white" />;
  }

  // Show splash screen on first visit
  if (showSplash) {
    return (
      <>
        {/* Pre-render content behind splash for seamless transition */}
        <div className="opacity-0">
          <ComingSoon />
        </div>
        <SplashScreen onComplete={handleSplashComplete} />
      </>
    );
  }

  // Show Coming Soon page with fade-in
  return (
    <div className={`transition-all duration-500 ${contentVisible ? 'opacity-100' : 'opacity-0'}`}>
      <ComingSoon />
    </div>
  );
}

export default App;
