#!/bin/bash

# Modern Auth App Setup Script
echo "🚀 Setting up Modern Authentication App..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ and try again."
    exit 1
fi

echo "✅ Node.js version: $(node --version)"

# Setup Backend
echo "📦 Setting up backend..."
cd backend

if [ ! -f ".env" ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit backend/.env with your configuration (especially JWT_SECRET)"
fi

echo "📥 Installing backend dependencies..."
npm install

echo "🔧 Building backend..."
npm run build

cd ..

# Setup Frontend
echo "🎨 Setting up frontend..."
cd frontend

echo "📥 Installing frontend dependencies..."
npm install

cd ..

echo "✅ Setup complete!"
echo ""
echo "🚀 To start the application:"
echo "1. Start backend:  cd backend && npm run start:dev"
echo "2. Start frontend: cd frontend && npm start"
echo ""
echo "🌐 Access the app at http://localhost:3000"
echo "📋 API will be available at http://localhost:3001"
echo ""
echo "📖 Check README.md for more information"