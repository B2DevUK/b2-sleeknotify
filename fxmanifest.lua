fx_version 'cerulean'
game 'gta5'

author 'B2DevUK'
description 'B2-SleekNotify Minimal Notification System'
version '1.0.0'

ui_page 'ui/dist/index.html'

files {
    'ui/dist/index.html',
    'ui/dist/assets/*.js',
    'ui/dist/assets/*.css',
    'ui/dist/assets/*.svg',
    'ui/dist/assets/*.png',
}

client_scripts {
    'client/config.lua',
    'client/main.lua'
}

server_script 'server/main.lua'