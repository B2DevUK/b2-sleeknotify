# Sleek Notify

A minimal, modern notification system for FiveM.

## Features
- 9 different notification positions (top, middle, bottom with left/right/center variants)
- 4 notification types (success, error, info, warning)
- Modern, clean UI with blur effects
- Non-stacking notifications
- Configurable durations
- Sound effects for different notification types

## Quick Installation (Production Release)
1. Download the latest release from the "Releases" page
2. Extract the `b2-sleeknotify` folder to your server's resources directory
3. Add `ensure b2-sleeknotify` to your server.cfg
4. Restart your server

## Development Installation (Source Code)
1. Clone the repository
2. Navigate to the `ui` directory
3. Install dependencies:
```bash
cd ui
npm install
```
4. Build the UI:
```bash
npm run build
```
5. Ensure the resource in your server.cfg

## Usage
```lua
-- Client-side
exports['b2-sleeknotify']:CreateNotification({
    type = 'success', -- success, error, info, warning
    message = 'Vehicle stored successfully!',
    position = 'TOP_RIGHT', -- See positions list below
    duration = 5000 -- Duration in milliseconds
})

-- Server-side
TriggerClientEvent('notifications:create', playerId, {
    type = 'info',
    message = 'Server message',
    position = 'TOP_CENTER'
})
```

### Available Positions
- TOP_LEFT
- TOP_CENTER
- TOP_RIGHT
- MIDDLE_LEFT
- MIDDLE_CENTER
- MIDDLE_RIGHT
- BOTTOM_LEFT
- BOTTOM_CENTER
- BOTTOM_RIGHT

## Building for Development
```bash
cd ui
npm install
npm run watch # Automatically rebuilds on changes
```

## License
[MIT License](LICENSE)