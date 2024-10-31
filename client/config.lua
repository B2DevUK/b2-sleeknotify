-- client/config.lua
Config = {
    Positions = {
        TOP_LEFT = {
            x = 0.01,
            y = 0.02,
            align = 'left'
        },
        TOP_RIGHT = {
            x = 0.99,
            y = 0.02,
            align = 'right'
        },
        TOP_CENTER = {
            x = 0.5,
            y = 0.02,
            align = 'center'
        },
        MIDDLE_LEFT = {
            x = 0.01,
            y = 0.5,
            align = 'left'
        },
        MIDDLE_RIGHT = {
            x = 0.99,
            y = 0.5,
            align = 'right'
        },
        MIDDLE_CENTER = {
            x = 0.5,
            y = 0.5,
            align = 'center'
        },
        BOTTOM_LEFT = {
            x = 0.01,
            y = 0.95,
            align = 'left'
        },
        BOTTOM_RIGHT = {
            x = 0.99,
            y = 0.95,
            align = 'right'
        },
        BOTTOM_CENTER = {
            x = 0.5,
            y = 0.95,
            align = 'center'
        }
    },
    DefaultPosition = 'TOP_RIGHT',
    DefaultDuration = 5000,
    Types = {
        success = {
            soundName = "CHALLENGE_UNLOCKED",
            soundRef = "HUD_AWARDS",
        },
        error = {
            soundName = "ERROR",
            soundRef = "HUD_FRONTEND_DEFAULT_SOUNDSET",
        },
        info = {
            soundName = "FocusIn",
            soundRef = "HUD_FRONTEND_DEFAULT_SOUNDSET",
        },
        warning = {
            soundName = "CHECKPOINT_MISSED",
            soundRef = "HUD_MINI_GAME_SOUNDSET",
        }
    }
}