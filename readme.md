# 10U Softball Swing Scouting Reports — Bethlehem Boom 10U

Video-based swing analysis for the Bethlehem Boom 10U roster: extract key frames from phone
video, diagnose mechanical issues against a standard checklist, and produce per-player +
team-level reports.

**Filming source:** live game at-bats only (no tee/BP/practice reps) — game swings are more
indicative of a player's real at-bats than a controlled rep, so every player's checklist should
be built from a running log of her actual at-bats across the season (see each report's Game Log
section), not a single staged swing.

**Coaches:** Bill Lynch, Doron Bruns, Kathleen Turner, Katie Melnikoff, Kayla Lupi

**Roster:** #1 Maggie M · #2 Ellie T · #3 Clare C · #5 Felicia A · #10 Anya O · #12 Payton M ·
#16 Lucy L · #23 Harper B · #25 Emily Y · #44 Chloe R · #66 Madison W

## Live site

Reports are hosted on GitHub Pages (public — no video/photos are hosted, only text: names,
jersey numbers, coach names, and written swing notes):

- **Team summary:** https://jonmcurry.github.io/bethlehem-boom-10u-scouting/reports/team_summary.html
- **Repo:** https://github.com/jonmcurry/bethlehem-boom-10u-scouting

Share the team summary link with coaches/parents — every player's report is one tap away from
there. To publish an update after editing a report locally:
```powershell
git add -A
git commit -m "describe what changed"
git push
```
GitHub Pages rebuilds automatically within a minute or two of a push. `videos/` and `frames/`
are gitignored — real footage never leaves your machine.

## Folder layout

- `videos/` — drop raw game clips here (`.mp4`/`.mov` from your Pixel), one file per at-bat. Suggested naming: `<player_slug>_<YYYYMMDD>_<opponent>_ab<N>.mp4`, e.g. `videos/maggie_m_20260802_eagles_ab1.mp4` — the date/opponent/AB# should match a row you add to that player's Game Log.
- `frames/<player_slug>/<clip_name>/` — extracted stills + a contact-sheet thumbnail grid, generated per clip (nested per at-bat so multiple games don't overwrite each other).
- `reports/` — filled-in scouting reports, one per player, plus a team side-by-side summary. Reports are self-contained, interactive HTML — open them straight in a browser (double-click, no server needed). Each has a light/dark toggle in the top corner.
  - `team_summary.html` — the real team overview for Bethlehem Boom 10U. Currently shows every player as "awaiting video" — updates automatically once individual reports are filled in.
  - `<player_slug>.html` (e.g. `maggie_m.html`) — one per roster player, currently placeholders awaiting video. Slugs are first-name_last-initial, matching the roster above. Each has a **Game Log** section (one row per at-bat filmed) above the mechanics checklist.
  - `_individual_report_template.html` / `_team_comparison_template.html` — blank templates, in case you add a player later or start a new season/team.
  - `example_maddie.html` / `example_team_summary.html` — filled-in mock examples (fictional players) showing what a fully-scored report looks like.
- `scripts/extract_frames.ps1` — pulls frames + a contact sheet out of a video.
- `scripts/generate_roster_reports.ps1` — one-time generator that created the 11 placeholder player pages + wired up `team_summary.html`. Re-run it if you add a new player to the `$Players` list inside; it won't touch existing players' files.

## Filming at games

- Film **every at-bat**, not just the good or bad ones — a checklist built from a cherry-picked swing will mislead more than help.
- Slow-mo (240fps on most Pixels) still works fine in games: start recording as the pitcher begins her windup (not when you see the bat start moving) — 10U pitch speed gives plenty of reaction time, and this gets you clean slow-mo without needing to react to the swing itself.
- Slow-mo needs light. Day games: no problem. Dusk/evening or a dim field: drop to normal 60fps rather than getting dark, blurry slow-mo footage.
- Shoot from a consistent spot each game if you can (behind the backstop is usually the best angle to see both stance and swing plane) — if shooting through fence mesh, get the lens close to the mesh to avoid moiré/focus issues.
- Heads up: filming from behind a public backstop will incidentally catch other teams' players in frame — worth keeping in mind if clips ever get shared beyond your own coaching use.

## Workflow

1. Film an at-bat (see filming tips above).
2. Copy the clip into `videos/`, e.g. `videos/maggie_m_20260802_eagles_ab1.mp4`.
3. Extract frames:
   ```powershell
   ./scripts/extract_frames.ps1 -VideoPath videos/maggie_m_20260802_eagles_ab1.mp4 -PlayerName maggie_m
   ```
4. Review the clip's `contact_sheet.png` under `frames/maggie_m/maggie_m_20260802_eagles_ab1/` for the overall shape, then pull specific `frame_###.png` files for stance / load / stride / contact / extension / follow-through.
5. Open `reports/maggie_m.html` (already created for every roster player). Add a row to the `GAME_LOG` array for this at-bat (date, opponent, AB #, result, clip filename).
6. Once a few at-bats are logged, fill in the `CHECKLIST` array (score 1-3 + notes per checkpoint, describing the *pattern* across logged at-bats, not just one swing) and the issue/comp/drill sections in the body — cite which at-bat(s) show each issue.
7. Copy that player's `strength` / `issue` / `drill` / `comp` / `scores` into the matching entry in `reports/team_summary.html`'s `PLAYERS` array. The side-by-side table, heat map, and live team-average row are all generated from that array — sortable and filterable in the browser, and the average row recalculates automatically as more players get scored.

## On the MLB legend comps

Shoeless Joe Jackson, Ty Cobb, Pete Rose, Ted Williams, Barry Bonds, Lou Gehrig, Babe Ruth, and
Ichiro Suzuki are used in the individual report template as **named cues for isolated mechanics**
(e.g. "get your hip drive like Ted Williams," "short direct hands like Ichiro") — not as literal
swing templates. Softball and baseball differ enough (rise ball, pitch distance, bat weighting)
that the primary comps for anything rise-ball- or timing-specific should be elite softball
hitters (e.g. Jocelyn Alo, Lauren Chamberlain, Amanda Chidester, Natasha Watley for slap-style
hitters). Build out a running list of softball comps as you identify good reference clips.
