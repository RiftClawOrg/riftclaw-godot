# RiftClaw Godot Project Plan

## Overview
Mirror of riftclaw-client (Electron) rebuilt in Godot 4.6.1

---

## Architecture

### Core Systems (Autoload Singletons)
```
Autoload/
├── PassportManager.gd      # Agent identity, ed25519 signatures
├── InventoryManager.gd     # 8-slot inventory, items
├── SceneManager.gd         # World loading, scene transitions
├── NetworkManager.gd       # WebSocket relay connection
├── UIManager.gd            # Overlay management
└── AudioManager.gd         # Ambient music, SFX
```

### Scene Structure
```
scenes/
├── limbo/
│   ├── limbo.tscn          # Main Limbo world (default load)
│   └── limbo_data.json     # Scene data (like old limbo.json)
├── the_rift/
│   ├── the_rift.tscn       # Hub world
│   └── the_rift_data.json
├── components/
│   ├── portal.tscn         # Reusable portal
│   ├── crystal.tscn        # Floating crystal
│   ├── floor_grid.tscn     # Floor + grid helper
│   └── starfield.tscn      # Particle starfield
└── ui/
    ├── overlays/
    │   ├── inventory_overlay.tscn
    │   ├── passport_overlay.tscn
    │   ├── help_overlay.tscn
    │   └── settings_overlay.tscn
    └── hud/
        ├── main_hud.tscn
        ├── chat_panel.tscn
        └── connection_status.tscn
```

### Player System
```
player/
├── player.tscn             # CharacterBody3D
├── player.gd               # Movement, camera, input
└── camera_controller.gd    # 3rd person camera
```

### Editor System
```
editor/
├── editor_overlay.tscn     # Scene Editor UI
├── editor_controller.gd    # Editor logic
├── gizmo/
│   ├── translate_gizmo.tscn  # XYZ arrows
│   ├── rotate_gizmo.tscn     # Rotation rings
│   └── scale_gizmo.tscn      # Scale boxes
└── inspectors/
    ├── object_inspector.tscn
    └── transform_gizmo.gd
```

---

## Features Checklist

### Phase 1: Core World (Limbo)
- [ ] Limbo scene with:
  - [ ] Dark floor (50x50)
  - [ ] Cyan grid helper
  - [ ] Portal to The Rift (position: 0,2,-10)
  - [ ] 10 floating crystals (animated)
  - [ ] Starfield background (1000 particles)
  - [ ] "The Rift Portal →" label
- [ ] Player controller:
  - [ ] WASD movement
  - [ ] Space to jump
  - [ ] 3rd person camera (follow + orbit)
  - [ ] Mouse drag to rotate camera
- [ ] Portal collision (2.5 radius)

### Phase 2: UI Overlays
- [ ] Main HUD:
  - [ ] Current world name
  - [ ] Connection status indicator
  - [ ] Quick action buttons (I, P, H, E)
- [ ] Inventory overlay (I key):
  - [ ] 8 slot grid
  - [ ] Item icons + quantities
  - [ ] Close button
- [ ] Passport overlay (P key):
  - [ ] Agent ID
  - [ ] Agent name
  - [ ] Reputation score
  - [ ] Home world
- [ ] Help overlay (H key):
  - [ ] Key bindings list
  - [ ] Quick tips

### Phase 3: Scene Editor (E key)
- [ ] Editor overlay UI:
  - [ ] Menu bar (File, Tools, Entities, Objects, View)
  - [ ] Scene Objects panel (left)
  - [ ] Properties panel (right)
  - [ ] Status bar (bottom)
- [ ] Selection system:
  - [ ] Click to select objects
  - [ ] Highlight selected
  - [ ] Show properties
- [ ] Transform gizmos:
  - [ ] Translate (X/Y/Z arrows)
  - [ ] Rotate (X/Y/Z rings)
  - [ ] Scale (X/Y/Z boxes + center)
- [ ] Tools:
  - [ ] Move Tool (T)
  - [ ] Rotate Tool (R)
  - [ ] Scale Tool (S)
  - [ ] Duplicate (Ctrl+D)
  - [ ] Delete (Del)
- [ ] Object creation:
  - [ ] Add Portal
  - [ ] Add Crystal
  - [ ] Add Light
  - [ ] Add Platform
- [ ] File operations:
  - [ ] New Scene
  - [ ] Save Scene (JSON)
  - [ ] Load Scene (JSON)

### Phase 4: The Rift Hub
- [ ] The Rift scene:
  - [ ] Larger floor (100x100)
  - [ ] 4 portals in circle:
    - [ ] Limbo (cyan)
    - [ ] Arena (red)
    - [ ] Forest (green)
    - [ ] Cyb3r (magenta)
  - [ ] 20 floating crystals
  - [ ] Starfield (2000 particles)
  - [ ] Direction labels
- [ ] Portal travel:
  - [ ] Walk through to travel
  - [ ] Transition effect
  - [ ] Load destination scene

### Phase 5: Networking
- [ ] WebSocket connection to relay
- [ ] Passport authentication
- [ ] Handoff protocol:
  - [ ] Send handoff_request
  - [ ] Receive handoff_confirm
  - [ ] Handle handoff_rejected
- [ ] Chat system:
  - [ ] Send messages
  - [ ] Receive messages
  - [ ] Display in chat panel
- [ ] Inventory sync via passport

### Phase 6: Inventory System
- [ ] 8 unique slots
- [ ] Item stacking (x999)
- [ ] Item types:
  - [ ] Portal Shard
  - [ ] Data Crystal
  - [ ] Victory Medal
  - [ ] etc. (35 total items)
- [ ] Item pickup
- [ ] Item drop
- [ ] Storage chest (100 slots)

---

## Technical Specs

### Rendering
- Renderer: Forward+
- Background: #050510 (dark void)
- Fog: Exp2, density 0.02
- Ambient Light: #404060

### Physics
- Player: CharacterBody3D
- Floor: StaticBody3D
- Portals: Area3D (trigger detection)
- Gravity: -20 m/s²
- Jump Force: 8 m/s

### Input Actions
```gdscript
move_forward    -> W / Up Arrow
move_backward   -> S / Down Arrow
move_left       -> A / Left Arrow
move_right      -> D / Right Arrow
jump            -> Space
toggle_inventory-> I
toggle_passport -> P
go_home         -> G
go_to_rift      -> R
toggle_editor   -> E
toggle_help     -> H
```

### File Formats
- Scenes: `.tscn` (Godot), `.json` (export/import)
- Scripts: `.gd` (GDScript)
- Assets: `.glb` (models), `.png` (textures), `.ogg` (audio)

---

## Project Structure

```
riftclaw-godot/
├── project.godot
├── icon.svg
├── README.md
├── .gitignore
├── autoload/
│   ├── passport_manager.gd
│   ├── inventory_manager.gd
│   ├── scene_manager.gd
│   ├── network_manager.gd
│   ├── ui_manager.gd
│   └── audio_manager.gd
├── assets/
│   ├── models/
│   ├── textures/
│   ├── fonts/
│   └── audio/
├── scenes/
│   ├── limbo/
│   ├── the_rift/
│   ├── components/
│   └── ui/
├── scripts/
│   ├── player/
│   ├── editor/
│   └── utils/
└── resources/
    ├── materials/
    └── themes/
```

---

## Build Pipeline

### Export Presets
- Windows Desktop
- Linux/X11
- macOS

### CI/CD (GitHub Actions)
- Build on push to main
- Export to all platforms
- Create releases

---

## Milestones

### Week 1: Foundation
- [ ] Project setup
- [ ] Player controller
- [ ] Limbo world
- [ ] Basic UI

### Week 2: Editor
- [ ] Scene Editor UI
- [ ] Gizmo system
- [ ] Object manipulation
- [ ] Save/Load JSON

### Week 3: Multi-world
- [ ] The Rift hub
- [ ] Portal system
- [ ] Scene transitions

### Week 4: Networking
- [ ] Relay connection
- [ ] Passport system
- [ ] Inventory sync

---

## Notes
- Mirror riftclaw-client features exactly
- Use Godot's built-in systems where possible
- Keep code modular and reusable
- Document everything
