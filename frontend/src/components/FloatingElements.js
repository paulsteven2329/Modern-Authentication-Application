import React from 'react';
import { motion } from 'framer-motion';
import { FiStar, FiShield, FiZap } from 'react-icons/fi';

const FloatingElements = () => {
  const elements = [
    { icon: FiStar, delay: 0, x: '10%', y: '20%' },
    { icon: FiShield, delay: 1, x: '80%', y: '15%' },
    { icon: FiZap, delay: 2, x: '15%', y: '70%' },
    { icon: FiStar, delay: 3, x: '85%', y: '75%' },
  ];

  return (
    <div className="fixed inset-0 pointer-events-none overflow-hidden">
      {elements.map((element, index) => (
        <motion.div
          key={index}
          initial={{ opacity: 0, scale: 0 }}
          animate={{ 
            opacity: [0, 1, 0],
            scale: [0, 1, 0],
            rotate: [0, 360],
          }}
          transition={{
            duration: 4,
            delay: element.delay,
            repeat: Infinity,
            repeatDelay: 6,
          }}
          style={{
            position: 'absolute',
            left: element.x,
            top: element.y,
          }}
          className="text-primary-500/20 dark:text-primary-400/20"
        >
          <element.icon size={24} />
        </motion.div>
      ))}
    </div>
  );
};

export default FloatingElements;