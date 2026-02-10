## ez_lib
A modern, feature-rich FiveM library providing elegant UI components and utility functions for GTA5 roleplay servers.

## Description

**ez_lib** is a comprehensive library designed to simplify FiveM resource development by offering ready-to-use UI components and helper functions. Built with React, TypeScript, and Mantine UI, it provides a cohesive, modern interface for common gameplay interactions.

### Key Features

- **Modern UI Components**: Beautiful, responsive interfaces built with React 19 and Mantine UI
- **Alert & Confirmation Dialogs**: Customizable modal dialogs for user confirmations and notifications
- **Input Forms**: Dynamic form builder with validation, multiple input types, and React Hook Form integration
- **Progress Indicators**: Linear and circular progress bars for timed actions and skill checks
- **Text UI System**: Persistent on-screen text with icon support and flexible positioning
- **Notification System**: Toast-style notifications with multiple types (success, error, warning, info)
- **Framework Integration**: Automatic detection and support for ESX and QBCore frameworks
- **NUI Communication**: Seamless Lua ↔ React communication layer for real-time UI updates
- **TypeScript Support**: Fully typed interfaces for better development experience
- **Customizable Styling**: Dark theme with customizable colors and animations

### Technology Stack

- **Frontend**: React 19.1.0, TypeScript 5.8.3, Vite 6.3.5
- **UI Framework**: Mantine 8.0.2 with custom theming
- **Icons**: FontAwesome 6.7.2 (Solid, Regular, Brands)
- **Form Handling**: React Hook Form 7.57.0
- **Date Utilities**: dayjs 1.11.13
- **Backend**: Lua 5.4 (FiveM Cerulean)
- **Dependencies**: ox_lib (required)

### Use Cases

- Interactive menus and dialogs for player interactions
- Inventory systems with confirmation prompts
- Job-specific interfaces (police, medical, mechanic)
- Skill-based minigames with progress tracking
- Quest and mission systems with objective displays
- Admin tools and management interfaces
- Vehicle shops, stores, and trading systems

## ! IMPORTANT !
Keep in mind, that this resource is "fork" from [ox_lib](https://github.com/overextended/ox_lib) resource from Overextended.

We have just edited some lines in interface/client and highly changed style of the library.

So everything you see in this resource is basically Overextended's code, we copied it here so we could easilly manipulate with "our" library for FiveM.

## Installation
- Download the latest version
- Copy and paste the "ez_lib" folder to your resources folder
- Make sure you have installed [ox_lib](https://github.com/overextended/ox_lib)
- Add to your `server.cfg`:
```cfg
ensure ox_lib
ensure ez_lib
```

## Usage in Other Scripts

### 1. Add Dependency
In your resource's `fxmanifest.lua`, add ez_lib as a dependency:

```lua
fx_version 'cerulean'
game 'gta5'

-- Add this line
dependencies {
    'ez_lib'
}

-- Your other configuration...
```

### 2. Client-Side Usage

#### Alert Dialog
```lua
-- Show a confirmation dialog
ez.alertDialog({
    header = 'Confirm Action',
    content = 'Are you sure you want to continue?',
    centered = true,
    cancel = true
}, function(response)
    if response == 'confirm' then
        print('User confirmed!')
    else
        print('User cancelled')
    end
end)
```

#### Text UI
```lua
-- Show persistent text UI
ez.showTextUI('[E] - Interact', {
    position = 'right-center',
    icon = 'hand'
})

-- Hide text UI
ez.hideTextUI()
```

#### Input Dialog
```lua
-- Show input form
local input = ez.inputDialog('User Information', {
    {type = 'input', label = 'Name', required = true},
    {type = 'number', label = 'Age', min = 18, max = 100},
    {type = 'checkbox', label = 'Accept Terms'}
})

if input then
    print('Name:', input[1])
    print('Age:', input[2])
    print('Accepted:', input[3])
end
```

#### Progress Bar
```lua
-- Show progress bar
if ez.progressBar({
    duration = 5000,
    label = 'Processing...',
    useWhileDead = false,
    canCancel = true,
    disable = {
        car = true,
        move = true
    }
}) then
    print('Progress completed!')
else
    print('Progress cancelled')
end
```

#### Circle Progress
```lua
-- Show circular progress indicator
if ez.progressCircle({
    duration = 3000,
    label = 'Loading...',
    position = 'bottom',
    canCancel = false
}) then
    print('Circle progress completed!')
end
```

#### Notifications
```lua
-- Show notification
ez.notify({
    title = 'Success',
    description = 'Action completed successfully',
    type = 'success'
})

-- Different types: 'success', 'error', 'warning', 'info'
```

### 3. Framework Support

The library automatically detects ESX or QBCore frameworks:

```lua
-- Get player job
local job = ez.getJob()
print('Job:', job.name, 'Grade:', job.grade)

-- Check if player has item
local hasItem = ez.hasItem('water', 1)

-- Get player status (hunger, thirst, etc.)
local hunger = ez.getStatus('hunger')
```

### 4. Available Functions

#### Client-Side
- `ez.alertDialog(data, cb)` - Show alert/confirmation dialog
- `ez.inputDialog(heading, rows, options)` - Show input form
- `ez.showTextUI(text, options)` - Display text UI
- `ez.hideTextUI()` - Hide text UI
- `ez.progressBar(data)` - Show progress bar
- `ez.progressCircle(data)` - Show circular progress
- `ez.notify(data)` - Show notification
- `ez.getJob()` - Get player job (framework)
- `ez.hasItem(item, count)` - Check item possession
- `ez.getStatus(status)` - Get player status

#### Server-Side
Access via exports or direct module loading as needed.

## API Documentation

For complete API documentation and advanced usage, refer to the [ox_lib documentation](https://overextended.github.io/docs/ox_lib/) as this library maintains compatibility with ox_lib's interface patterns.
