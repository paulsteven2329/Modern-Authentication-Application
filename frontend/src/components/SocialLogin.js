import React from 'react';
import { motion } from 'framer-motion';
import { FaGoogle, FaFacebook, FaTwitter } from 'react-icons/fa';
import { getSocialAuthUrl } from '../utils/helpers';

const SocialLogin = () => {
  const handleSocialLogin = (provider) => {
    const authUrl = getSocialAuthUrl(provider);
    window.location.href = authUrl;
  };

  const socialProviders = [
    {
      name: 'Google',
      icon: FaGoogle,
      color: 'text-red-500',
      hoverColor: 'hover:bg-red-50 dark:hover:bg-red-900/20',
      provider: 'google',
    },
    {
      name: 'Facebook',
      icon: FaFacebook,
      color: 'text-blue-600',
      hoverColor: 'hover:bg-blue-50 dark:hover:bg-blue-900/20',
      provider: 'facebook',
    },
    {
      name: 'Twitter',
      icon: FaTwitter,
      color: 'text-blue-400',
      hoverColor: 'hover:bg-blue-50 dark:hover:bg-blue-900/20',
      provider: 'twitter',
    },
  ];

  return (
    <div className="space-y-4">
      <div className="relative">
        <div className="absolute inset-0 flex items-center">
          <div className="w-full border-t border-gray-300 dark:border-gray-600"></div>
        </div>
        <div className="relative flex justify-center text-sm">
          <span className="bg-gray-50 dark:bg-gray-900 px-2 text-gray-500 dark:text-gray-400">
            Or continue with
          </span>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-3">
        {socialProviders.map((provider, index) => (
          <motion.button
            key={provider.provider}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={() => handleSocialLogin(provider.provider)}
            className={`glass-effect ${provider.hoverColor} w-full py-3 px-4 rounded-lg font-medium text-gray-900 dark:text-white flex items-center justify-center gap-3 transition-all duration-200`}
          >
            <provider.icon className={`w-5 h-5 ${provider.color}`} />
            Continue with {provider.name}
          </motion.button>
        ))}
      </div>
    </div>
  );
};

export default SocialLogin;