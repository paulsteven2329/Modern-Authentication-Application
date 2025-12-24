import React from 'react';
import { motion } from 'framer-motion';
import MagicLinkForm from '../components/MagicLinkForm';
import SocialLogin from '../components/SocialLogin';
import ThemeToggle from '../components/ThemeToggle';
import FloatingElements from '../components/FloatingElements';
import { FiLock } from 'react-icons/fi';

const LoginPage = () => {
  return (
    <div className="min-h-screen relative overflow-hidden">
      {/* Floating background elements */}
      <FloatingElements />
      
      {/* Background gradient */}
      <div className="absolute inset-0 gradient-bg dark:dark-gradient-bg opacity-90"></div>
      
      {/* Theme toggle */}
      <div className="absolute top-6 right-6 z-10">
        <ThemeToggle />
      </div>

      {/* Main content */}
      <div className="relative z-10 min-h-screen flex items-center justify-center px-4 sm:px-6 lg:px-8">
        <motion.div
          initial={{ opacity: 0, y: 40 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="max-w-md w-full"
        >
          {/* Login card */}
          <div className="glass-card p-8 space-y-8">
            {/* Header */}
            <div className="text-center space-y-4">
              <motion.div
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.2, type: "spring", stiffness: 300 }}
                className="inline-flex items-center justify-center w-16 h-16 bg-primary-500 rounded-full mb-4"
              >
                <FiLock className="w-8 h-8 text-white" />
              </motion.div>
              
              <motion.h1
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.3 }}
                className="text-3xl font-bold text-gray-900 dark:text-white"
              >
                Welcome back
              </motion.h1>
              
              <motion.p
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.4 }}
                className="text-gray-600 dark:text-gray-300"
              >
                Sign in to your account using magic link or social login
              </motion.p>
            </div>

            {/* Magic link form */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.5 }}
            >
              <MagicLinkForm />
            </motion.div>

            {/* Social login */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.6 }}
            >
              <SocialLogin />
            </motion.div>

            {/* Footer */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.7 }}
              className="text-center"
            >
              <p className="text-xs text-gray-500 dark:text-gray-400">
                Secure, passwordless authentication powered by modern technology
              </p>
            </motion.div>
          </div>

          {/* Additional info */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.8 }}
            className="mt-8 text-center"
          >
            <p className="text-sm text-white/80 dark:text-gray-300">
              No passwords to remember • No forms to fill • Just click and go
            </p>
          </motion.div>
        </motion.div>
      </div>

      {/* Bottom decoration */}
      <div className="absolute bottom-0 left-0 right-0 h-32 bg-gradient-to-t from-black/20 to-transparent"></div>
    </div>
  );
};

export default LoginPage;