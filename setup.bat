@echo off
echo 🚀 Setting up Modern Authentication App...

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js 18+ and try again.
    pause
    exit /b 1
)

echo ✅ Node.js version:
node --version

REM Setup Backend
echo 📦 Setting up backend...
cd backend

if not exist ".env" (
    echo 📝 Creating .env file from template...
    copy .env.example .env
    echo ⚠️  Please edit backend\.env with your configuration (especially JWT_SECRET)
)

echo 📥 Installing backend dependencies...
npm install

echo 🔧 Building backend...
npm run build

cd ..

REM Setup Frontend
echo 🎨 Setting up frontend...
cd frontend

echo 📥 Installing frontend dependencies...
npm install

cd ..

echo ✅ Setup complete!
echo.
echo 🚀 To start the application:
echo 1. Start backend:  cd backend ^&^& npm run start:dev
echo 2. Start frontend: cd frontend ^&^& npm start
echo.
echo 🌐 Access the app at http://localhost:3000
echo 📋 API will be available at http://localhost:3001
echo.
echo 📖 Check README.md for more information
pause