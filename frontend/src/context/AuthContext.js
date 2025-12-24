import React, { createContext, useContext, useState, useEffect } from 'react';
import { jwtDecode } from 'jwt-decode';
import api from '../utils/api';
import toast from 'react-hot-toast';

const AuthContext = createContext();

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  // Check if user is authenticated on app load
  useEffect(() => {
    checkAuth();
  }, []);

  const checkAuth = () => {
    try {
      const token = localStorage.getItem('token');
      if (token) {
        const decodedToken = jwtDecode(token);
        
        // Check if token is expired
        if (decodedToken.exp * 1000 > Date.now()) {
          setUser(decodedToken);
          setIsAuthenticated(true);
        } else {
          // Token is expired, remove it
          localStorage.removeItem('token');
        }
      }
    } catch (error) {
      console.error('Error checking authentication:', error);
      localStorage.removeItem('token');
    }
    setLoading(false);
  };

  const login = async (email) => {
    try {
      setLoading(true);
      const response = await api.post('/auth/send-magic-link', { email });
      toast.success('Magic link sent to your email!');
      return response.data;
    } catch (error) {
      toast.error(error.response?.data?.message || 'Failed to send magic link');
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const verifyMagicLink = async (token) => {
    try {
      setLoading(true);
      const response = await api.post('/auth/verify-magic-link', { token });
      const { access_token, user } = response.data;
      
      localStorage.setItem('token', access_token);
      setUser(user);
      setIsAuthenticated(true);
      toast.success('Login successful!');
      return response.data;
    } catch (error) {
      toast.error(error.response?.data?.message || 'Invalid or expired magic link');
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const socialLogin = async (provider, code) => {
    try {
      setLoading(true);
      const response = await api.post(`/auth/${provider}/callback`, { code });
      const { access_token, user } = response.data;
      
      localStorage.setItem('token', access_token);
      setUser(user);
      setIsAuthenticated(true);
      toast.success('Login successful!');
      return response.data;
    } catch (error) {
      toast.error(error.response?.data?.message || 'Social login failed');
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const logout = () => {
    localStorage.removeItem('token');
    setUser(null);
    setIsAuthenticated(false);
    toast.success('Logged out successfully');
  };

  const resendMagicLink = async (email) => {
    try {
      await api.post('/auth/send-magic-link', { email });
      toast.success('Magic link resent to your email!');
    } catch (error) {
      toast.error(error.response?.data?.message || 'Failed to resend magic link');
      throw error;
    }
  };

  const value = {
    user,
    isAuthenticated,
    loading,
    login,
    verifyMagicLink,
    socialLogin,
    logout,
    resendMagicLink,
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};