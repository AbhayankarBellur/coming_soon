import { useState, useRef, useEffect, useCallback } from 'react';

interface SplashScreenProps {
  onComplete: () => void;
}

const SplashScreen = ({ onComplete }: SplashScreenProps) => {
  const [opacity, setOpacity] = useState(1);
  const [showContent, setShowContent] = useState(false);
  const videoRef = useRef<HTMLVideoElement>(null);
  const [isMobile, setIsMobile] = useState<boolean | null>(null);
  const [videoStyle, setVideoStyle] = useState({
    width: '100vw',
    height: '100dvh',
    scale: 1.15
  });

  // Detect mobile device - run once on mount
  useEffect(() => {
    const checkMobile = () => {
      const width = window.innerWidth;
      // Mobile: < 768px, Tablet/Desktop: >= 768px
      const isMobileWidth = width < 768;
      // Also check user agent for mobile devices
      const isMobileAgent = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
      // Consider it mobile if either condition is true AND width is small
      // For tablets in portrait, still use desktop video unless width < 768
      return isMobileWidth || (isMobileAgent && width < 768);
    };
    setIsMobile(checkMobile());
  }, []);

  // Perfect fit scaling algorithm
  const calculateVideoSize = useCallback(() => {
    if (isMobile === null) return;

    const viewportWidth = window.innerWidth;
    const viewportHeight = window.innerHeight;
    const viewportRatio = viewportWidth / viewportHeight;

    // Video aspect ratios: 9:16 for mobile (portrait), 16:9 for desktop (landscape)
    const videoRatio = isMobile ? 9 / 16 : 16 / 9;

    let scale = 1.15; // Base overscale buffer
    let width = '100vw';
    let height = '100dvh';

    if (viewportRatio > videoRatio) {
      // Viewport is wider than video - scale to width, overflow height
      height = '120dvh';
    } else {
      // Viewport is taller than video - scale to height, overflow width
      width = '120vw';
    }

    // Mobile specific adjustment for browser chrome (address bars)
    if (isMobile) {
      scale = 1.25; // Extra buffer for mobile browser UI
    }

    setVideoStyle({ width, height, scale });
  }, [isMobile]);

  useEffect(() => {
    if (isMobile === null) return;
    calculateVideoSize();
    window.addEventListener('resize', calculateVideoSize);
    return () => window.removeEventListener('resize', calculateVideoSize);
  }, [calculateVideoSize, isMobile]);

  // Lock scroll during loading
  useEffect(() => {
    document.body.style.overflow = 'hidden';
    return () => {
      document.body.style.overflow = '';
    };
  }, []);

  const handleVideoEnd = () => {
    // Show content behind immediately (no black flash)
    setShowContent(true);
    
    // Hold last frame for 800ms, then fade
    setTimeout(() => {
      setOpacity(0);
      // Wait for fade animation to complete (300ms)
      setTimeout(() => {
        onComplete();
      }, 300);
    }, 800);
  };

  // Don't render until mobile detection is complete
  if (isMobile === null) {
    return (
      <div className="fixed inset-0 z-[9999] bg-black" />
    );
  }

  const videoSrc = isMobile ? '/videos/loading_phone.mov' : '/videos/loading.mov';

  return (
    <div className="fixed inset-0 z-[9999] overflow-hidden">
      {/* Background that matches end of video - prevents black flash */}
      <div 
        className="absolute inset-0 bg-black transition-opacity duration-300"
        style={{ opacity: showContent ? 0 : 1 }}
      />
      
      <video
        ref={videoRef}
        autoPlay
        muted
        playsInline
        onEnded={handleVideoEnd}
        key={videoSrc} // Force remount when source changes
        className="absolute top-1/2 left-1/2 object-cover transition-opacity duration-300 ease-out"
        style={{
          opacity: opacity,
          transform: `translate(-50%, -50%) scale(${videoStyle.scale})`,
          width: videoStyle.width,
          height: videoStyle.height,
          minWidth: '100%',
          minHeight: '100%'
        }}
      >
        <source src={videoSrc} type="video/quicktime" />
        <source src={videoSrc} type="video/mp4" />
      </video>
    </div>
  );
};

export default SplashScreen;
