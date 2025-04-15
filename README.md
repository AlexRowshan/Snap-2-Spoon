# Snap2Spoon 📱📷🍽️

[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## About
Snap2Spoon is an innovative iOS application that transforms grocery receipts into personalized recipes. Using computer vision and AI, the app analyzes receipt items and generates customized recipes based on purchased ingredients.

## Features
- **Receipt Scanning**: Capture grocery receipts with built-in camera functionality
- **Intelligent Recipe Generation**: Convert receipt ingredients into delicious recipes using OpenAI's GPT APIs
- **Manual Ingredient Entry**: Alternatively, manually enter ingredients through Chat2Spoon interface
- **Recipe Storage**: Save, view, and manage generated recipes
- **Nutritional Analysis**: Analyze recipes for nutritional content and health benefits
- **User Profiles**: Personalized experience with custom user profiles
- **Cross-Device Sync**: CloudKit integration ensures data availability across user's devices

## Technologies
- **Swift**: Core programming language for iOS development
- **SwiftUI**: Modern UI framework for responsive interfaces
- **UIKit**: Used for custom camera implementation and interface components
- **AVFoundation**: Powers camera functionality and image processing
- **CloudKit**: Apple's cloud database for data persistence and synchronization
- **Combine**: Reactive programming framework for handling asynchronous events
- **OpenAI API**: Leverages GPT models for intelligent recipe generation
- **MVVM Architecture**: Maintains separation of concerns and code reusability

## User Flow
1. Users capture a grocery receipt using the built-in camera
2. The app processes the receipt image and identifies purchased items
3. OpenAI API generates customized recipes based on available ingredients
4. Users can view, save, and analyze generated recipes
5. Alternatively, users can manually enter ingredients to generate recipes

## Implementation Details
- Implements secure user authentication and data handling
- Uses AVCaptureSession for efficient camera processing
- Applies asynchronous processing with Swift's modern concurrency features
- Integrates with OpenAI's GPT-4o for advanced natural language processing
- Maintains responsive design across various iOS devices

## Future Enhancements
- Barcode scanning for individual grocery items
- Meal planning and grocery list generation
- Social sharing functionality for recipes
- Dietary restriction and preference filtering
- Integration with health and fitness tracking

## Requirements
- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- Apple Developer Account (for CloudKit)
- OpenAI API Key

## Installation and Setup

### Clone the Repository
```bash
git clone https://github.com/AlexRowshan/Snap-2-Spoon.git
cd Snap-2-Spoon
```

### Open in Xcode
1. Launch Xcode
2. Select "Open a project or file"
3. Navigate to the cloned Snap-2-Spoon directory
4. Select the `s2s.xcodeproj` file

### Configure API Keys
1. Navigate to the `Constants.swift` file in the project
2. Replace the placeholder OpenAI API key with your own:
   ```swift
   static let openAIAPIKey : String = "YOUR_OPENAI_API_KEY"
   ```

### Set Up CloudKit
1. In Xcode, select your project in the Project Navigator
2. Select your app target and go to the "Signing & Capabilities" tab
3. Add the CloudKit capability if not already present
4. Ensure your Apple Developer account is properly configured

### Run the Application
1. Select your desired iOS simulator or connected device
2. Click the Run button (▶️) or press `Cmd+R`
3. The app should build and launch on your selected device

## Troubleshooting
- If you encounter build errors, ensure you have the latest version of Xcode
- For CloudKit-related issues, verify your Apple Developer account status
- API connection problems may indicate an invalid or expired API key
