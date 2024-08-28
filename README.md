# Animations.lua

### Description

Designed for photographers, this script is an all in one package for casual users and advanced users as well.

Important: I recommend binding clear tasks to a key `Player >> Clear Tasks`


### Features

- 116 Emotes
- 138 Scenarios
- 341 Animations
- 257 Animal Scenarios
- Manual Input for direct animation play
  - Supports auto-search for similar animation names if an exact match isn't found
- Walking/Upper Body Animation
- Animation Speed
- Clear Nearby Peds
- Clear Tasks

### Advanced

- Play Nearby Scenario
- Play Nearby Train Scenario
- Scenario Range 
- Render Scenario Range
- Warp to Scenario

#### Settings

- Force Rest Scenario
- Ground Detection
- Play Animations on Scenarios
- Look at me
- Move Distance 
- Move Forward
- Move Backward
- Move Left
- Move Right

#### Spawner

- Ped Model (321 Peds)
- Ped Variant
- Spawn Ped
- Animal Model (79 Animals)
- Animal Variant
- Spawn Animal
- Manual Input Spawn
  - Supports auto-search for similar ped names if an exact match isn't found
- Clone Ped
  - Clone Ped can also be found in `Network >> Players >> Player#1 >> Animations.lua >> Clone Ped`
- Play Animations on spawned ped
- Play animations on horse
- Teleport ped to me
- Teleport me to ped
- Next Ped
- Clear tasks for spawned ped
- Delete spawned ped


## Explanation of features

- Play Nearby Scenario: This feature makes it so your player can play scenarios that npc's play all the time. See a npc sitting on a bench? You can play that exact scenario in the same position.
  - Nearby Scenarios are tied to objects so benches, railings, water pumps, the list goes on they are all objects that Nearby Scenarios can be used with. Since they go off of objects this means if you have a world creation you can do nearby scenarios in it.
  - Nearby Train Scenarios are the same thing just only for trains.
- Force Rest Scenario: When you go afk and your player takes a knee its a rest scenario you can now force it to happen whenever you want.
- Move Forward/Backward/Left/Right: This will move the ped based on where they are looking
- Play Animations on spawned ped: If you spawn a ped and want the ped to do an animation or scenario or nearby scenaro you need to toggle this first.
- Play Animations on horse: If you want to play animations on your horse you will need to toggle this and "Play Animations on spawned ped" this will look for your active mount either the one you are riding when you toggle it on or the one you have previously riden.
- Next Ped: This will clear the current ped reference so if you have a spawned ped and want to spawn another one you will need to click this first.

## Discord Community

Are you an aspiring Lua developer or just passionate about scripting? Join our Discord community! It's a fantastic place for learning, sharing scripts, and getting insights directly from experienced developers.
Lua Devs can interact with the community, discuss features, and collaborate on projects. [Join Discord](https://discord.gg/7AKbaUfsjy)

## Installation Guide

### Downloading Animations.lua
You can download Animations.lua from one of the following sources:
- [Github Releases](https://github.com/Nobody277/Animations.lua/releases)
- [Fortitude Script Corral](https://discord.gg/7AKbaUfsjy)
- [Fortitude Discord Server](https://discord.gg/fortitudemod)
- [Fortitude Library](https://fortitudemod.com/dashboard/library)

### Installing the Script
1. Once downloaded, locate the script file (usually a `.lua` file).
2. Place the script file in the Fortitude Lua folder. This is usually found at `Documents\Fortitude\Red Dead Redemption 2\LUA`.
3. Launch the game and open the Fortitude menu.

### Loading the Script
1. In the Fortitude menu, navigate to `Creator >> Lua Scripts >> Animations.lua`.
2. If you don't immediately see the script, go to `Creator >> Lua Scripts >> Load Scripts From Disk`. This should refresh the list and show Animations.lua.
3. Once loaded, you are good to go have fun making the best photos!

