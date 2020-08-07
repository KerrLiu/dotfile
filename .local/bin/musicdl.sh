#!/usr/bin/env bash

# @file		musicdl.sh
# @author	Kerr	printf("");[qq:1224472370]
# @date		Mon 27 Jul 2020 11:48:20 AM CST
# @pkgs		base curl jq
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

total_num=$(jq '.data.list | length' $listfile)

echo "Download Start total=$total_num"

for ((i=0;i<$total_num;i++))
do
	echo "Download num=$i start"
	song_name=$(jq ".data.list[${i}].name" $listfile)
	song_artist=$(jq ".data.list[${i}].artist" $listfile)
	song_url=$(jq ".data.list[${i}].url_flac" $listfile)
	song_type='.flac'
	[ $song_url == 'null' ] && song_url=$(jq ".data.list[${i}].url_320" $listfile) && song_type='.mp3'
	[ $song_url == 'null' ] && song_url=$(jq ".data.list[${i}].url_128" $listfile)
	[ $song_url == 'null' ] && song_url=$(jq ".data.list[${i}].url" $listfile)
	song_dl_path=$(echo "$music_path$song_name - $song_artist$song_type" | tr -d '"')
	echo "Download num=$i name=$song_name type=$song_type"
	[ "$song_url" ] && curl -sL $(echo $song_url | tr -d '"') -o "$song_dl_path" || echo "song null"
	echo "Download num$i name=$song_name type=cover"
	song_cover=$(jq ".data.list[${i}].cover" $listfile)
	cover_dl_path=$(echo "$cover_path$song_name - $song_artist.jpg" | tr -d '"')
	[ "$song_cover" ] && curl -sL $(echo $song_cover | tr -d '"') -o "$cover_dl_path" || echo "cover null"
	echo "Download num$i name=$song_name type=lrc"
	song_lrc=$(jq ".data.list[${i}].lrc" $listfile)
	lrc_dl_path=$(echo "$lrc_path$song_name - $song_artist.lrc" | tr -d '"')
	[ "$song_lrc" ] && curl -sL $(echo $song_lrc | tr -d '"') -o "$lrc_dl_path" || echo "lrc null"
	echo "Download num $i end"
	sleep 1
done

echo "Download End total=$total_num"
