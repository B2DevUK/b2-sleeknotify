Config = {
    Style = 'minimal', -- 'minimal' or 'advanced'
    DefaultPosition = 'TOP_RIGHT',
    DefaultDuration = 5000,
    DefaultType = 'info',
    
    Positions = {
        TOP_LEFT = true,
        TOP_RIGHT = true,
        TOP_CENTER = true,
        MIDDLE_LEFT = true,
        MIDDLE_RIGHT = true,
        MIDDLE_CENTER = true,
        BOTTOM_LEFT = true,
        BOTTOM_RIGHT = true,
        BOTTOM_CENTER = true
    },
    
    Sounds = {
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