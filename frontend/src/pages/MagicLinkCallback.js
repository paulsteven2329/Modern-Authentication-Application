import React, { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { motion } from 'framer-motion';
import { useAuth } from '../context/AuthContext';
import { FiCheck, FiX, FiLoader } from 'react-icons/fi';

const MagicLinkCallback = () => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const { verifyMagicLink, socialLogin } = useAuth();
  const [status, setStatus] = useState('loading'); // loading, success, error
  const [message, setMessage] = useState('');

  useEffect(() => {
    const handleCallback = async () => {
      try {
        const token = searchParams.get('token');
        const provider = searchParams.get('provider');
        const code = searchParams.get('code');

        if (token) {
          // Magic link verification
          await verifyMagicLink(token);
          setStatus('success');
          setMessage('Successfully signed in!');
          setTimeout(() => navigate('/dashboard'), 2000);
        } else if (provider && code) {
          // Social login callback
          await socialLogin(provider, code);
          setStatus('success');
          setMessage('Successfully signed in with ' + provider + '!');
          setTimeout(() => navigate('/dashboard'), 2000);
        } else {
          throw new Error('Invalid callback parameters');
        }
      } catch (error) {
        setStatus('error');
        setMessage(error.response?.data?.message || 'Authentication failed');
        setTimeout(() => navigate('/login'), 3000);
      }
    };

    handleCallback();
  }, [searchParams, verifyMagicLink, socialLogin, navigate]);

  const getStatusIcon = () => {
    switch (status) {
      case 'loading':
        return <FiLoader className="w-16 h-16 text-primary-500 animate-spin" />;
      case 'success':
        return <FiCheck className="w-16 h-16 text-green-500" />;
      case 'error':
        return <FiX className="w-16 h-16 text-red-500" />;
      default:
        return null;
    }
  };

  const getStatusMessage = () => {
    switch (status) {
      case 'loading':
        return 'Verifying your authentication...';
      case 'success':
        return message;
      case 'error':
        return message;
      default:
        return '';
    }
  };

  const getStatusColor = () => {
    switch (status) {
      case 'loading':
        return 'text-gray-600 dark:text-gray-300';
      case 'success':
        return 'text-green-600 dark:text-green-400';
      case 'error':
        return 'text-red-600 dark:text-red-400';
      default:
        return '';
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900 px-4">
      <motion.div
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        className="max-w-md w-full text-center"
      >
        <div className="glass-card p-8 space-y-6">
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: 0.2, type: "spring", stiffness: 300 }}
            className="flex justify-center"
          >
            {getStatusIcon()}
          </motion.div>
          
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
            className="space-y-3"
          >
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
              {status === 'loading' && 'Authenticating...'}
              {status === 'success' && 'Welcome!'}
              {status === 'error' && 'Authentication Failed'}
            </h2>
            
            <p className={`${getStatusColor()}`}>
              {getStatusMessage()}
            </p>
          </motion.div>

          {status === 'loading' && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.6 }}
              className="flex items-center justify-center space-x-2"
            >
              <div className="w-2 h-2 bg-primary-500 rounded-full animate-bounce"></div>
              <div className="w-2 h-2 bg-primary-500 rounded-full animate-bounce" style={{animationDelay: '0.1s'}}></div>
              <div className="w-2 h-2 bg-primary-500 rounded-full animate-bounce" style={{animationDelay: '0.2s'}}></div>
            </motion.div>
          )}

          {status === 'success' && (
            <motion.p
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.8 }}
              className="text-sm text-gray-500 dark:text-gray-400"
            >
              Redirecting to dashboard...
            </motion.p>
          )}

          {status === 'error' && (
            <motion.p
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.8 }}
              className="text-sm text-gray-500 dark:text-gray-400"
            >
              Redirecting to login page...
            </motion.p>
          )}
        </div>
      </motion.div>
    </div>
  );
};

export default MagicLinkCallback;