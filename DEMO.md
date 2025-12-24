# 🎯 Modern Auth App - Demo & Testing Guide

## 🚀 Quick Demo

This guide will help you test all the features of the Modern Authentication App.

## Prerequisites

- Node.js 18+ installed
- Terminal/Command Prompt access

## 🔧 Setup (Choose One Method)

### Method 1: Automatic Setup (Recommended)
```bash
# For Linux/Mac
./setup.sh

# For Windows
setup.bat
```

### Method 2: Manual Setup
```bash
# Backend
cd backend
npm install
cp .env.example .env
# Edit .env file with your settings

# Frontend (in new terminal)
cd frontend
npm install
```

## 🏃‍♂️ Running the App

### 1. Start Backend Server
```bash
cd backend
npm run start:dev
```
*Backend will run on http://localhost:3001*

### 2. Start Frontend (New Terminal)
```bash
cd frontend
npm start
```
*Frontend will run on http://localhost:3000*

## 🧪 Testing Features

### 🔗 Magic Link Authentication

1. **Access the App**: Open http://localhost:3000
2. **Enter Email**: Type any valid email address
3. **Send Magic Link**: Click "Send magic link"
4. **Check Console**: Since email isn't configured, the magic link will appear in the backend console
5. **Use Magic Link**: Copy the link from console and paste in browser
6. **Success**: You should be redirected to the dashboard

### 🎨 UI/UX Features

1. **Dark Mode Toggle**: Click the sun/moon icon in top-right
2. **Glassmorphism**: Notice the frosted glass effects on cards
3. **Animations**: Observe smooth transitions and hover effects
4. **Responsive Design**: Resize browser window to test responsiveness

### 🌐 Social Login (Optional Setup Required)

To test social login, you need to configure OAuth:

#### Google OAuth Setup:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create project and enable Google+ API
3. Create OAuth credentials
4. Add redirect URI: `http://localhost:3001/api/auth/google/callback`
5. Update `.env` with `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`

#### Facebook OAuth Setup:
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create app and add Facebook Login
3. Add redirect URI: `http://localhost:3001/api/auth/facebook/callback`
4. Update `.env` with `FACEBOOK_APP_ID` and `FACEBOOK_APP_SECRET`

### 📧 Email Configuration (Optional)

For real email sending:

1. **Gmail Setup**:
   ```env
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SMTP_USER=your-email@gmail.com
   SMTP_PASS=your-app-password
   FROM_EMAIL=your-email@gmail.com
   ```

2. **Generate App Password**: Enable 2FA on Gmail and create app password
3. **Restart Backend**: Stop and restart the backend server

## 🔍 What to Look For

### ✅ Frontend Features
- [x] Beautiful login page with glassmorphism
- [x] Dark/light mode toggle
- [x] Smooth animations and transitions
- [x] Responsive design
- [x] Magic link form with validation
- [x] Social login buttons
- [x] Loading states and error handling
- [x] Toast notifications
- [x] Protected dashboard page

### ✅ Backend Features
- [x] Magic link generation and validation
- [x] Email service (console logging for development)
- [x] JWT token generation and validation
- [x] User management with SQLite database
- [x] Social OAuth integration
- [x] CORS configuration
- [x] Input validation and security

### ✅ Security Features
- [x] JWT token authentication
- [x] Magic link expiration (15 minutes)
- [x] Single-use magic links
- [x] Protected API routes
- [x] CORS protection
- [x] Input validation

## 🐛 Troubleshooting

### Common Issues:

1. **Port already in use**:
   ```bash
   # Kill process on port 3000 or 3001
   sudo lsof -t -i tcp:3000 | xargs kill
   sudo lsof -t -i tcp:3001 | xargs kill
   ```

2. **Dependencies not installing**:
   ```bash
   # Clear npm cache
   npm cache clean --force
   rm -rf node_modules package-lock.json
   npm install
   ```

3. **Database issues**:
   ```bash
   # Delete and recreate database
   rm backend/auth.db
   # Restart backend - database will be recreated
   ```

4. **CORS errors**:
   - Ensure `FRONTEND_URL` is set correctly in backend `.env`
   - Check that both servers are running on correct ports

## 📊 Testing Checklist

### Magic Link Flow:
- [ ] Enter email address
- [ ] Receive success message
- [ ] Magic link appears in backend console
- [ ] Clicking link redirects to callback page
- [ ] Authentication successful, redirected to dashboard
- [ ] JWT token stored in localStorage
- [ ] User info displayed on dashboard
- [ ] Logout works correctly

### UI/UX Testing:
- [ ] Dark mode toggle works
- [ ] Glassmorphism effects visible
- [ ] Smooth animations on interactions
- [ ] Mobile responsive design
- [ ] Error messages display correctly
- [ ] Loading states work
- [ ] Toast notifications appear

### API Testing:
- [ ] POST `/api/auth/send-magic-link` works
- [ ] POST `/api/auth/verify-magic-link` works
- [ ] GET `/api/user/profile` requires authentication
- [ ] Invalid tokens return 401 errors
- [ ] Magic links expire after 15 minutes

## 🎉 Success Criteria

If you can complete the following flow, the app is working perfectly:

1. ✅ Access login page
2. ✅ Enter email and send magic link
3. ✅ Use magic link from console to authenticate
4. ✅ Land on dashboard with user info
5. ✅ Toggle dark/light mode
6. ✅ Logout and return to login page

## 🚀 Next Steps

After testing, you can:
- Configure real email sending
- Set up social OAuth providers
- Deploy to production
- Customize the UI/UX
- Add more authentication features

## 📞 Support

If you encounter issues:
1. Check the console logs (both browser and backend)
2. Verify environment variables are set correctly
3. Ensure all dependencies are installed
4. Check that ports 3000 and 3001 are available

---

Happy testing! 🎉