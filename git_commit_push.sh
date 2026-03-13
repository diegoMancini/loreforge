#!/bin/bash
cd /workspaces/loreforge

# Kill any stuck processes
pkill -9 -f "dart.*loreforge_cli" 2>/dev/null || true
pkill -9 -f flutter 2>/dev/null || true
pkill -9 -f dart 2>/dev/null || true

sleep 1

# Add all changes
git add .

# Commit with message
git commit -m "Implement complete Loreforge AI-powered adventure game

- Add JSON-based persistence system with shared_preferences
- Implement save/load functionality in gameplay screen
- Create character sheet and inventory overlays for RPG mode
- Add streaming AI narrative generation with mock providers
- Complete Session Zero wizard with 7-step setup process
- Integrate audio system with adaptive background music
- Add comprehensive AI agent pipeline (Story Director, Scene Writer, etc.)
- Implement RPG mechanics with d20-style stat system
- Add genre and twist frameworks for dynamic storytelling
- Create cross-platform Flutter app with Flame game engine"

# Push to remote
git push origin main

echo "Commit and push completed successfully"