import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { useFormik } from 'formik';
import * as yup from 'yup';
import { FiMail, FiSend, FiRefreshCw } from 'react-icons/fi';
import { useAuth } from '../context/AuthContext';
import { validateEmail } from '../utils/helpers';

const validationSchema = yup.object({
  email: yup
    .string()
    .email('Please enter a valid email address')
    .required('Email is required'),
});

const MagicLinkForm = () => {
  const { login, resendMagicLink, loading } = useAuth();
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [submittedEmail, setSubmittedEmail] = useState('');

  const formik = useFormik({
    initialValues: {
      email: '',
    },
    validationSchema,
    onSubmit: async (values) => {
      try {
        await login(values.email);
        setSubmittedEmail(values.email);
        setIsSubmitted(true);
      } catch (error) {
        // Error is already handled in the context
      }
    },
  });

  const handleResend = async () => {
    try {
      await resendMagicLink(submittedEmail);
    } catch (error) {
      // Error is already handled in the context
    }
  };

  const handleEditEmail = () => {
    setIsSubmitted(false);
    setSubmittedEmail('');
    formik.resetForm();
  };

  if (isSubmitted) {
    return (
      <motion.div
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        className="text-center space-y-6"
      >
        <div className="text-6xl mb-6">📧</div>
        <div>
          <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
            Check your email
          </h3>
          <p className="text-gray-600 dark:text-gray-300 mb-4">
            We sent a magic link to <span className="font-medium">{submittedEmail}</span>
          </p>
          <p className="text-sm text-gray-500 dark:text-gray-400 mb-6">
            Click the link in your email to sign in. The link will expire in 15 minutes.
          </p>
        </div>
        
        <div className="space-y-3">
          <button
            onClick={handleResend}
            disabled={loading}
            className="w-full btn-glass px-6 py-3 rounded-lg font-medium text-gray-900 dark:text-white flex items-center justify-center gap-2"
          >
            {loading ? (
              <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-current"></div>
            ) : (
              <FiRefreshCw className="w-5 h-5" />
            )}
            Resend magic link
          </button>
          
          <button
            onClick={handleEditEmail}
            className="w-full text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors"
          >
            Use a different email address
          </button>
        </div>
      </motion.div>
    );
  }

  return (
    <motion.form
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      onSubmit={formik.handleSubmit}
      className="space-y-6"
    >
      <div>
        <label htmlFor="email" className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          Email address
        </label>
        <div className="relative">
          <FiMail className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 dark:text-gray-500 w-5 h-5" />
          <input
            id="email"
            name="email"
            type="email"
            placeholder="Enter your email address"
            className={`input-glass w-full pl-10 pr-4 py-3 rounded-lg ${
              formik.touched.email && formik.errors.email
                ? 'ring-2 ring-red-500'
                : ''
            }`}
            {...formik.getFieldProps('email')}
          />
        </div>
        {formik.touched.email && formik.errors.email && (
          <motion.p
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            className="mt-2 text-sm text-red-600 dark:text-red-400"
          >
            {formik.errors.email}
          </motion.p>
        )}
      </div>

      <button
        type="submit"
        disabled={loading || !formik.isValid}
        className="w-full bg-primary-600 hover:bg-primary-700 disabled:opacity-50 disabled:cursor-not-allowed text-white font-medium py-3 px-6 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 transform hover:scale-105 active:scale-95"
      >
        {loading ? (
          <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
        ) : (
          <>
            <FiSend className="w-5 h-5" />
            Send magic link
          </>
        )}
      </button>

      <p className="text-xs text-gray-500 dark:text-gray-400 text-center">
        We'll send you a secure link to sign in without a password
      </p>
    </motion.form>
  );
};

export default MagicLinkForm;