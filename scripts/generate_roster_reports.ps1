<#
.SYNOPSIS
  One-time generator: creates a placeholder ("awaiting video") individual report
  per roster player from _individual_report_template.html, and a real
  team_summary.html wired up to link to them.

  Safe to re-run for a NEW player added to $Players — it will only overwrite
  files for players still listed here. It will NOT touch a player's report
  once you've started filling in real checklist scores, because at that point
  you should just edit that player's .html directly instead of re-running this.
#>

$Team = "Bethlehem Boom 10U"
$Coaches = @("Bill Lynch", "Doron Bruns", "Kathleen Turner", "Katie Melnikoff", "Kayla Lupi")

$Players = @(
    @{ Number = 1;  Name = "Maggie M";  Slug = "maggie_m" }
    @{ Number = 2;  Name = "Ellie T";   Slug = "ellie_t" }
    @{ Number = 3;  Name = "Clare C";   Slug = "clare_c" }
    @{ Number = 5;  Name = "Felicia A"; Slug = "felicia_a" }
    @{ Number = 10; Name = "Anya O";    Slug = "anya_o" }
    @{ Number = 12; Name = "Payton M";  Slug = "payton_m" }
    @{ Number = 16; Name = "Lucy L";    Slug = "lucy_l" }
    @{ Number = 23; Name = "Harper B";  Slug = "harper_b" }
    @{ Number = 25; Name = "Emily Y";   Slug = "emily_y" }
    @{ Number = 44; Name = "Chloe R";   Slug = "chloe_r" }
    @{ Number = 66; Name = "Madison W"; Slug = "madison_w" }
)

$reportsDir = Join-Path $PSScriptRoot "..\reports"
$templatePath = Join-Path $reportsDir "_individual_report_template.html"
$template = Get-Content $templatePath -Raw

foreach ($p in $Players) {
    $displayName = "$($p.Name) (#$($p.Number))"
    $html = $template

    $html = $html.Replace(
        "TEMPLATE — copy this file per player, rename it, and edit the placeholders below (header text + the GAME_LOG array + the CHECKLIST array + the diagnosis/comps/drills sections near the bottom of the &lt;body&gt;).",
        "AWAITING VIDEO — no at-bats filmed yet for $displayName. Film her at-bats in a game (every AB, not just notable ones), drop the clip(s) in videos/, run scripts/extract_frames.ps1, then fill in this report."
    )

    $html = $html.Replace("Swing Scouting Report — {{PLAYER_NAME}}", "Swing Scouting Report — $displayName")
    # Catches the remaining bare {{PLAYER_NAME}} tokens: the static "no video" fallback
    # paragraph and the JS `const PLAYER_NAME` used by the issues-rendering code.
    $html = $html.Replace("{{PLAYER_NAME}}", $displayName)

    $html = $html.Replace(
@'
    <div class="meta">
      <span><b>Last updated:</b> {{DATE}}</span>
      <span><b>At-bats reviewed:</b> <span id="abCount">0</span></span>
      <span><b>Vantage:</b> {{e.g. behind backstop}}</span>
    </div>
'@,
@"
    <div class="meta">
      <span><b>Team:</b> $Team</span>
      <span><b>Jersey:</b> #$($p.Number)</span>
      <span><b>Last updated:</b> Awaiting video</span>
      <span><b>At-bats reviewed:</b> <span id="abCount">0</span></span>
      <span><b>Vantage:</b> —</span>
    </div>
"@
    )

    $html = $html.Replace(
@'
        <table class="comp-table">
          <tbody>
            <tr><td>{{e.g. Ichiro Suzuki}}</td><td>{{hands stay inside the ball, short direct path — good for a caster}}</td></tr>
            <tr><td>{{e.g. Ted Williams}}</td><td>{{hip drive initiates rotation, slight upward bat path through the zone}}</td></tr>
            <tr><td>{{e.g. Jocelyn Alo / modern softball comp}}</td><td>{{rotational power off a stable back hip — most directly transferable since same sport/rise ball}}</td></tr>
          </tbody>
        </table>
'@,
        "        <p>Comp cues will be picked once the specific issue is identified from film — see the reference bank below for the menu of options.</p>"
    )

    $html = $html.Replace(
@'
        <ul class="drills">
          <li><b>{{Drill 1}}</b> — {{targets Issue 1}}</li>
          <li><b>{{Drill 2}}</b> — {{targets Issue 2, if applicable}}</li>
        </ul>
'@,
        "        <p>Drills will be recommended once the primary issue(s) are identified from film.</p>"
    )

    $html = $html.Replace(
@'
          <div><b>Re-film by</b>{{date}}</div>
          <div><b>What to check next time</b>{{specific checkpoint(s) from section 1}}</div>
'@,
@'
          <div><b>Re-film by</b>TBD — awaiting first clip</div>
          <div><b>What to check next time</b>Full checklist (section 1)</div>
'@
    )

    $outPath = Join-Path $reportsDir "$($p.Slug).html"
    Set-Content -Path $outPath -Value $html -NoNewline
    Write-Host "Wrote $outPath"
}

Write-Host "`nDone. $($Players.Count) placeholder player reports generated."
