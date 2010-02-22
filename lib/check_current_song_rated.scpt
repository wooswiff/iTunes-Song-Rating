log "running progress update script"

on checkCurrentSong()
	
	tell application "iTunes"
		if (exists current track) and (player state is playing) then
			set aTrack to current track
			if (rating of aTrack) is 0 then
				set total_time to ((duration of aTrack) div 1)
				set marker to player position
				if (total_time - marker) < 61 or marker > 90 then
					say "Rate this track"
				end if
			end if
		end if
		
	end tell
end checkCurrentSong

my checkCurrentSong()
