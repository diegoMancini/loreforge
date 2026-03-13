# loreforge
Build your own adventure game

## Overview
Loreforge is an AI-powered interactive adventure game built with Flutter and Flame. It features dynamic storytelling with multiple genres, RPG mechanics, and streaming narrative generation.

## Game Design Document
See [Loreforge_GDD_v2.pdf](Loreforge_GDD_v2.pdf) for the complete design specification.

## Development Status
- ✅ Project setup with Flutter + Flame
- ✅ Basic dependencies installed (Riverpod, Freezed, Drift, etc.)
- ✅ CLI prototype with mock AI story loop
- ✅ Flame game scaffold
- ✅ AI agent architecture (Story Director, Scene Writer, Choice Generator, Skill Check Arbiter, Consistency Auditor, Visual Director, World State Manager)
- ✅ State management with Riverpod
- ✅ Session Zero wizard with 7 steps
- ✅ Gameplay screen with streaming text simulation
- ✅ Genre craft rules system
- ✅ Twist state management
- ✅ RPG mechanics foundation (stats, inventory, skill checks)
- ✅ Visual asset system (backgrounds, sprites)
- ✅ Audio system with adaptive BGM and SFX
- ✅ UI overlays (character sheet, inventory)
- 🔄 Implementing database persistence
- 🔄 Adding real AI API integration
- 🔄 Building offline mode with local models

## Tech Stack
- **Game Engine**: Flutter + Flame 1.x
- **State Management**: Riverpod + Freezed
- **Database**: Drift (SQLite)
- **AI**: Multi-provider abstraction (DeepSeek, Gemini, Claude, etc.)
- **Audio**: Flame Audio + Audioplayers
- **Backend**: Supabase/Firebase

## Getting Started
1. Install Flutter SDK
2. Run `flutter pub get`
3. For CLI prototype: `dart run bin/loreforge_cli.dart`

## Roadmap
See the GDD for detailed development phases.
