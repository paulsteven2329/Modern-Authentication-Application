# Modern Authentication App

A complete web application featuring modern authentication methods including passwordless magic link login and social authentication, built with React frontend and NestJS backend.

## Features

🔐 **Authentication Methods**
- Passwordless authentication with magic links
- Social login (Google, Facebook, Twitter)
- JWT-based session management

🎨 **Modern UI/UX**
- Dark/Light mode toggle
- Glassmorphism design effects
- Smooth animations and transitions
- Fully responsive design
- Beautiful email templates

⚡ **Tech Stack**
- **Frontend**: React, Tailwind CSS, Framer Motion
- **Backend**: NestJS, TypeORM, SQLite
- **Authentication**: JWT, Passport.js, OAuth
- **Email**: Nodemailer

## Project Structure

```
react/
├── frontend/          # React frontend application
│   ├── src/
│   │   ├── components/    # Reusable UI components
│   │   ├── pages/         # Page components
│   │   ├── context/       # React Context providers
│   │   └── utils/         # Utility functions
│   └── package.json
├── backend/           # NestJS backend API
│   ├── src/
│   │   ├── auth/          # Authentication module
│   │   ├── user/          # User management
│   │   └── email/         # Email service
│   └── package.json
└── README.md
```

## Quick Start

### Prerequisites
- Node.js 18+
- npm or yarn

### 1. Setup Backend

```bash
cd backend
npm install

# Configure environment variables
cp .env.example .env
# Edit .env with your configuration

# Start the backend server
npm run start:dev
```

### 2. Setup Frontend

```bash
cd frontend
npm install

# Start the frontend development server
npm start
```

### 3. Access the Application

- Frontend: http://localhost:3000
- Backend API: http://localhost:3001

## Configuration

### Backend Environment Variables

Create a `.env` file in the backend directory:

```env
# Database
DB_TYPE=sqlite
DB_DATABASE=auth.db

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=7d

# Email (optional for development)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
FROM_EMAIL=your-email@gmail.com

# App URLs
PORT=3001
FRONTEND_URL=http://localhost:3000

# Social Auth (optional)
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-app-secret
```

### Frontend Environment Variables

Create a `.env` file in the frontend directory (optional):

```env
REACT_APP_API_URL=http://localhost:3001
```

## Features in Detail

### 🔗 Magic Link Authentication
- Users enter their email address
- Receive a secure, time-limited magic link
- Click the link to authenticate instantly
- No passwords required

### 🌐 Social Authentication
- Google OAuth integration
- Facebook OAuth integration
- Twitter OAuth support (configurable)
- Seamless user experience

### 🎨 Modern UI Features
- **Glassmorphism Effects**: Frosted glass design elements
- **Dark Mode**: Toggle between light and dark themes
- **Smooth Animations**: Powered by Framer Motion
- **Responsive Design**: Works on all device sizes
- **Loading States**: Beautiful loading indicators

### 🔒 Security Features
- JWT token-based authentication
- Magic link expiration (15 minutes)
- Single-use magic links
- CORS protection
- Input validation

## Development

### Backend Development

```bash
cd backend

# Install dependencies
npm install

# Start in development mode (with hot reload)
npm run start:dev

# Build for production
npm run build

# Start production server
npm run start:prod

# Run tests
npm test
```

### Frontend Development

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm start

# Build for production
npm run build

# Run tests
npm test
```

## API Endpoints

### Authentication
- `POST /api/auth/send-magic-link` - Send magic link to email
- `POST /api/auth/verify-magic-link` - Verify magic link token
- `GET /api/auth/google` - Google OAuth login
- `GET /api/auth/google/callback` - Google OAuth callback
- `GET /api/auth/facebook` - Facebook OAuth login
- `GET /api/auth/facebook/callback` - Facebook OAuth callback

### User
- `GET /api/user/profile` - Get user profile (protected)

## Email Configuration

For development, the app will log magic links to the console. For production:

1. **Gmail SMTP** (recommended for testing):
   - Enable 2FA on your Google account
   - Generate an App Password
   - Use the App Password as `SMTP_PASS`

2. **Other SMTP providers**:
   - Configure `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`

## Social Auth Setup

### Google OAuth
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URI: `http://localhost:3001/api/auth/google/callback`

### Facebook OAuth
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app
3. Add Facebook Login product
4. Configure redirect URI: `http://localhost:3001/api/auth/facebook/callback`

## Production Deployment

### Backend Deployment
1. Set environment variables for production
2. Use a production database (PostgreSQL recommended)
3. Configure proper CORS origins
4. Set up HTTPS
5. Use PM2 or similar for process management

### Frontend Deployment
1. Set `REACT_APP_API_URL` to your production API URL
2. Build the production bundle: `npm run build`
3. Deploy to Netlify, Vercel, or any static hosting service

## Troubleshooting

### Common Issues

1. **Magic links not working**
   - Check email configuration
   - Verify console logs for development
   - Ensure frontend and backend URLs are correct

2. **Social login not working**
   - Verify OAuth client IDs and secrets
   - Check redirect URIs match exactly
   - Ensure OAuth apps are properly configured

3. **CORS issues**
   - Verify `FRONTEND_URL` environment variable
   - Check CORS configuration in `main.ts`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

---

Built with ❤️ using React, NestJS, and modern web technologies.