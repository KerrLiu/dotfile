#!/usr/bin/env bash

# @file		musiced.sh
# @author	Kerr	printf("");[qq:1224472370]
# @date		Mon 27 Jul 2020 12:55:54 PM CST
# @pkgs		base jq metaflac python-eyed3
# @version	1.0

listfile="$1"
music_path="$HOME/Downloads/Music/song/"
cover_path="$HOME/Downloads/Music/cover/"
lrc_path="$HOME/Downloads/Music/lrc/"

[[ -f "$listfile" && $(file "$listfile" | grep JSON ) ]] || exit 1
[ $(jq ".code" "$listfile") == 200 ] && echo ok! || exit 2

[ -d "$music_path" ] && echo "music path have" || mkdir -p "$music_path"
[ -d "$cover_path" ] && echo "cover path have" || mkdir -p "$cover_path"
[ -d "$lrc_path" ] && echo "lrc path have" || mkdir -p "$lrc_path"

jsondata=$(cat $listfile)

total_num=$(jq '.data.list | length' <<< $jsondata)

echo "Edit Start total=$total_num"

for ((i=0;i<$total_num;i++))
do
	echo "Edit num=$i start"
	song_name=$(jq ".data.list[${i}].name" <<< $jsondata)
	song_artist=$(jq ".data.list[${i}].artist" <<< $jsondata)
	song_url=$(jq ".data.list[${i}].url_flac" <<< $jsondata)
	song_type='.flac'
	[ $song_url == 'null' ] && song_type='.mp3'

	song_file_path=$(echo "$music_path$song_name - $song_artist$song_type" | tr -d '"')
	song_cover_path=$(echo "$cover_path$song_name - $song_artist.jpg" | tr -d '"')
	song_lrc_path=$(echo "$lrc_path$song_name - $song_artist.lrc" | tr -d '"')
	
	isFlac=$(file "$song_file_path" | grep FLAC)

	if [ "$isFlac" ]; then
		[ -f "$song_cover_path" ] && metaflac --import-picture-from="$song_cover_path" "$song_file_path" || echo "cover not found"
		metaflac --remove-tag=Comment "$song_file_path"
		metaflac --set-tag Artist="$(echo "$song_artist" | tr -d '"')" "$song_file_path"
		metaflac --set-tag Title="$(echo "$song_name" | tr -d '"')" "$song_file_path"
	else
		eyeD3 -a "$(echo "$song_artist" | tr -d '"')" "$song_file_path"
		eyeD3 -t "$(echo "$song_name" | tr -d '"')" "$song_file_path"
		[ -f "$song_cover_path" ] && eyeD3 --add-image="$song_cover_path":FRONT_COVER "$song_file_path" || echo "cover not found"
		[ -f "$song_lrc_path" ] && eyeD3 --add-lyrics "$song_lrc_path" "$song_file_path" || echo "lrc not found"

	fi
	sleep 1
done

echo "Edit End total=$total_num"
