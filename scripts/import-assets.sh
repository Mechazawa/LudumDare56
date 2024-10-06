#!/bin/sh

# I'm lazy, sue me (please don't)
cp -rv "/run/user/1000/gvfs/smb-share:server=172.16.1.101,share=shared/Ludum Dare 56/assets/"* assets/
cp -rv "/run/user/1000/gvfs/smb-share:server=172.16.1.101,share=shared/Ludum Dare 56/sound/"* sound/

find sound assets -iname thumbs.db -delete -print
