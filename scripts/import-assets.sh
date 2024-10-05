#!/bin/sh

# I'm lazy, sue me (please don't)
cp -v "/run/user/1000/gvfs/smb-share:server=172.16.1.101,share=shared/Ludum Dare 56/assets/"* assets/
rm assets/Thumbs.db
