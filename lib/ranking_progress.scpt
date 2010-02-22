log "running progress update script"
property changePhrase : "Changing iChat Status Message.  "

on debug(phrase)
	--say phrase
end debug

on getRatingsStats()
	set trackCount to 0
	set ratedCount to 0
	set ratedPct to 0
	set ratingSum to 0
	set averageRating to 0.0
	set lastTrackId to 0
	set lastTrack to ""
	set lastArtist to ""
	set lastRating to ""
	
	tell application "iTunes"
		tell source "Library" to tell playlist "Library" to set allTracks to (every track)
		repeat with x from 1 to the count of allTracks
			set aTrack to item x of allTracks
			set trackCount to trackCount + 1
			if (rating of aTrack) is not 0 then
				set playedDate to (played date of aTrack)
				if (ratedCount is 0) or (playedDate > lastRatedDate) then
					set lastRatedDate to playedDate
					set lastTrackId to x
				end if
				set ratedCount to ratedCount + 1
				set ratingSum to ratingSum + ((rating of item x of allTracks) / 20)
			end if
		end repeat
		if lastTrackId > 0 then
			set lastTrack to (name of item lastTrackId of allTracks)
			set lastArtist to (artist of item lastTrackId of allTracks)
			set lastRating to ((rating of item lastTrackId of allTracks) / 20)
		end if
	end tell
	
	-- Calculate stats
	set ratedPct to ((ratedCount / trackCount) * 100) * 100 div 1 / 100
	set averageRating to ((ratingSum / ratedCount)) * 100 div 1 / 100
	return {trackCount:trackCount, ratedCount:ratedCount, ratingSum:ratingSum, ratedPct:ratedPct, averageRating:averageRating, lastTrack:lastTrack, lastArtist:lastArtist, lastRating:lastRating}
end getRatingsStats

on ratingsStatusMessage()
	set stats to my getRatingsStats()
	set lastRated to ""
	if (lastTrack in stats is not "") then
		set lastTrackRating to ""
		if (lastRating in stats is not "") then
			set lastTrackRating to " (" & lastRating in stats & ")"
		end if
		set lastRated to "Last Rated: \"" & lastTrack in stats & "\" by " & lastArtist in stats & lastTrackRating
	end if
	set fullStatus to "tracks: " & trackCount in stats & ", rated: " & ratedCount in stats & ", ratedPct: " & ratedPct in stats & ", averageRating: " & averageRating in stats & ", ratingSum: " & ratingSum in stats & ", lastTrack: " & lastTrack in stats & ", lastArtist: " & lastArtist in stats
	set iChatStatus to ratedPct in stats & "% complete (" & ratedCount in stats & "/" & trackCount in stats & ").  Average rating: " & averageRating in stats & ".  " & lastRated
	return iChatStatus as text
end ratingsStatusMessage

on setStatus()
	tell application "System Events" to set iChatRunning to name of processes contains "iChat"
	
	if iChatRunning is false then
		my debug("iChat is not running")
		return false
	end if
	
	set newStatus to ratingsStatusMessage()
	
	tell application "iChat"
		
		if status is offline then
			my debug("iChat is offline")
			return false
		end if
		
		return my changeStatusTo(newStatus)
		
	end tell
	
end setStatus

on changeStatusTo(newMessage)
	tell application "iChat"
		if status message is not equal to newMessage then
			set status message to newMessage
			--say changePhrase & newMessage
			return true
		else
			my debug("status message is correct")
			return false
		end if
	end tell
end changeStatusTo

--my ratingsStatusMessage()
my setStatus()
