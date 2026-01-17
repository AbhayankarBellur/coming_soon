import { motion } from 'framer-motion';

const ComingSoon = () => {
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.6, ease: 'easeOut' }}
      className="min-h-screen bg-survey-gradient flex flex-col items-center justify-center p-6"
    >
      <motion.h1
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2, duration: 0.5 }}
        className="text-5xl md:text-7xl font-bold text-center"
        style={{ 
          fontFamily: "'Baloo 2', cursive",
          color: 'hsl(25, 30%, 25%)'
        }}
      >
        Coming Soon!
      </motion.h1>
    </motion.div>
  );
};

export default ComingSoon;
