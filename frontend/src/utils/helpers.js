// Validation utilities
export const validateEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

// URL utilities
export const getUrlParameter = (name) => {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get(name);
};

// Social auth URLs
export const getSocialAuthUrl = (provider) => {
  const baseUrl = process.env.REACT_APP_API_URL || 'http://localhost:3001';
  const redirectUri = encodeURIComponent(`${window.location.origin}/auth/callback`);
  
  switch (provider) {
    case 'google':
      return `${baseUrl}/auth/google?redirect_uri=${redirectUri}`;
    case 'facebook':
      return `${baseUrl}/auth/facebook?redirect_uri=${redirectUri}`;
    case 'twitter':
      return `${baseUrl}/auth/twitter?redirect_uri=${redirectUri}`;
    default:
      throw new Error(`Unknown provider: ${provider}`);
  }
};

// Animation utilities
export const fadeInUp = {
  initial: { opacity: 0, y: 20 },
  animate: { opacity: 1, y: 0 },
  exit: { opacity: 0, y: -20 },
};

export const staggerContainer = {
  animate: {
    transition: {
      staggerChildren: 0.1
    }
  }
};

// Storage utilities
export const storage = {
  get: (key) => {
    try {
      return JSON.parse(localStorage.getItem(key));
    } catch {
      return localStorage.getItem(key);
    }
  },
  set: (key, value) => {
    if (typeof value === 'object') {
      localStorage.setItem(key, JSON.stringify(value));
    } else {
      localStorage.setItem(key, value);
    }
  },
  remove: (key) => {
    localStorage.removeItem(key);
  },
};