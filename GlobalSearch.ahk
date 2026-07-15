#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_id " GSearchGui.Hwnd)

; -- Execute Search --
Enter:: {
    global GSearchGui
    Saved := GSearchGui.Submit()

    query := Trim(Saved.SearchQuery)
    if (query != "") {
        ; Save to history if it's not empty/duplicate of the last entry
        if (GSearchHistory.Length = 0 || GSearchHistory[GSearchHistory.Length] != query) {
            GSearchHistory.Push(query)
        }

        ; Keep only the last 50 items
        if (GSearchHistory.Length > 50) {
            GSearchHistory.RemoveAt(1)
        }
    }

    ExecuteSearch(query)
}

; History Navigation
; -------------------------------

; -- Cycle History Up (Older Queries) --
Up:: {
    global GSearchHistory, historyIndex, GSearchInput
    if (GSearchHistory.Length = 0)
        return

    ; If we haven't started cycling or are at the oldest entry, lock to oldest
    if (historyIndex = 0) {
        historyIndex := GSearchHistory.Length
    } else if (historyIndex > 1) {
        historyIndex--
    }

    GSearchInput.Value := GSearchHistory[historyIndex]
    Send("{End}")
}

; -- Cycle History Down (Newer Queries) --
Down:: {
    global GSearchHistory, historyIndex, GSearchInput
    if (GSearchHistory.Length = 0)
        return

    if (historyIndex > 0 && historyIndex < GSearchHistory.Length) {
        historyIndex++
        GSearchInput.Value := GSearchHistory[historyIndex]
    } else {
        ; Clear the input bar if pressed Down at the very end of history
        historyIndex := 0
        GSearchInput.Value := ""
    }
    Send("{End}") ; Move caret to the end of the loaded string
}

#HotIf

; --- Search Logic Engine ---
ExecuteSearch(query) {
    query := Trim(query)
    if (query = "")
        return

    ; 1. Youtube Web Search ("yt:")
    else if (SubStr(query, 1, 3) = "yt:") {
        rawQuery := Trim(SubStr(query, 4))
        encodedQuery := StrReplace(rawQuery, " ", "%20")
        Run("https://www.youtube.com/results?search_query=" encodedQuery)
    }

    ; 2. Spotify Web Search ("sp:")
    else if (SubStr(query, 1, 3) = "sp:") {
        rawQuery := Trim(SubStr(query, 3))
        encodedQuery := StrReplace(rawQuery, " ", "%20")
        Run("https://open.spotify.com/search/" encodedQuery)
    }

    ; 3. Default Fallback (Normal Google Search)
    else {
        encodedQuery := StrReplace(query, " ", "%20")
        Run("https://search.brave.com/search?q=" encodedQuery)
    }
}
