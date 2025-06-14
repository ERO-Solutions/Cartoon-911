# FiveM 911 Call System (Standalone)

A simple and standalone FiveM script that allows players to make 911 emergency calls, which create blips on the map for emergency services (police, EMS, etc.) to respond to.

## Features

- Players can make 911 calls using the `/911 [message]` command
- Creates a visible radius blip (50m) and marker blip at the caller's location
- Plays an alert sound for emergency service players
- Automatically clears blips when the call is resolved
- Server-side handling of notifications (compatible with most chat systems)

## Installation

1. Add this script to your FiveM server's `resources` folder
2. Ensure the resource is started in your `server.cfg`:


## Usage

- **For Civilians:**
- Use the command `/911 [your emergency message]` to call for help
- Example: `/911 There's a robbery at the Fleeca Bank on Alta Street!`

- **For Emergency Services:**
- Receive blip markers showing the location of 911 calls
- Blips automatically clear when the call is resolved server-side

## Configuration

The script is designed to work out-of-the-box, but you can easily modify:

- Blip colors (currently set to blue - color 5)
- Blip sprite (currently using sprite 188)
- Sound effect (currently using GTA V's "new_911" sound)

## Dependencies

- None (fully standalone)
- Compatible with most FiveM servers and chat systems

## Support

For support or feature requests, please open an issue on the GitHub repository (if available) or contact the developer directly.
