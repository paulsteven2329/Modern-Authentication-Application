import React from 'react';
import { motion } from 'framer-motion';
import { useAuth } from '../context/AuthContext';
import ThemeToggle from '../components/ThemeToggle';
import { FiLogOut, FiUser, FiMail, FiShield, FiStar } from 'react-icons/fi';

const Dashboard = () => {
  const { user, logout } = useAuth();

  const stats = [
    { icon: FiUser, label: 'Profile', value: 'Complete' },
    { icon: FiShield, label: 'Security', value: 'Verified' },
    { icon: FiStar, label: 'Status', value: 'Active' },
  ];

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      {/* Header */}
      <header className="glass-card border-0 border-b border-gray-200 dark:border-gray-700">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <motion.div
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              className="flex items-center gap-3"
            >
              <div className="w-10 h-10 bg-primary-500 rounded-full flex items-center justify-center">
                <FiShield className="w-5 h-5 text-white" />
              </div>
              <h1 className="text-xl font-bold text-gray-900 dark:text-white">
                Modern Auth
              </h1>
            </motion.div>
            
            <div className="flex items-center gap-3">
              <ThemeToggle />
              <motion.button
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                onClick={logout}
                className="btn-glass px-4 py-2 rounded-lg text-gray-900 dark:text-white flex items-center gap-2"
              >
                <FiLogOut className="w-4 h-4" />
                Sign out
              </motion.button>
            </div>
          </div>
        </div>
      </header>

      {/* Main content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="space-y-8">
          {/* Welcome section */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="glass-card p-8"
          >
            <div className="flex items-start justify-between">
              <div className="space-y-4">
                <div>
                  <h2 className="text-3xl font-bold text-gray-900 dark:text-white">
                    Welcome back!
                  </h2>
                  <p className="text-gray-600 dark:text-gray-300 mt-2">
                    You're successfully authenticated and ready to go.
                  </p>
                </div>
                
                {user && (
                  <div className="flex items-center gap-3 p-4 glass-effect rounded-lg">
                    <div className="w-12 h-12 bg-primary-500 rounded-full flex items-center justify-center">
                      <FiUser className="w-6 h-6 text-white" />
                    </div>
                    <div>
                      <p className="font-medium text-gray-900 dark:text-white">
                        {user.name || 'User'}
                      </p>
                      <div className="flex items-center gap-1 text-gray-600 dark:text-gray-300">
                        <FiMail className="w-4 h-4" />
                        <span className="text-sm">{user.email}</span>
                      </div>
                    </div>
                  </div>
                )}
              </div>
              
              <motion.div
                animate={{ 
                  rotate: [0, 10, -10, 0],
                }}
                transition={{ 
                  duration: 2,
                  repeat: Infinity,
                  repeatDelay: 5
                }}
                className="text-6xl"
              >
                🎉
              </motion.div>
            </div>
          </motion.div>

          {/* Stats grid */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {stats.map((stat, index) => (
              <motion.div
                key={stat.label}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                className="glass-card p-6"
              >
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 bg-primary-500/10 dark:bg-primary-400/10 rounded-lg flex items-center justify-center">
                    <stat.icon className="w-6 h-6 text-primary-500 dark:text-primary-400" />
                  </div>
                  <div>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      {stat.label}
                    </p>
                    <p className="font-semibold text-gray-900 dark:text-white">
                      {stat.value}
                    </p>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>

          {/* Features section */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
            className="glass-card p-8"
          >
            <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-6">
              Authentication Features
            </h3>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-4">
                <div className="flex items-center gap-3">
                  <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                  <span className="text-gray-900 dark:text-white">Passwordless Authentication</span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                  <span className="text-gray-900 dark:text-white">Magic Link Login</span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                  <span className="text-gray-900 dark:text-white">Social Authentication</span>
                </div>
              </div>
              
              <div className="space-y-4">
                <div className="flex items-center gap-3">
                  <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                  <span className="text-gray-900 dark:text-white">JWT Token Security</span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                  <span className="text-gray-900 dark:text-white">Dark Mode Support</span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                  <span className="text-gray-900 dark:text-white">Glassmorphism UI</span>
                </div>
              </div>
            </div>
          </motion.div>
        </div>
      </main>
    </div>
  );
};

export default Dashboard;