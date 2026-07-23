<#
.SYNOPSIS
  Extracts key still frames from a hitter's swing video for scouting-report analysis.

.DESCRIPTION
  Pulls two things out of a swing clip:
    1. A dense frame sequence (default 10 fps) so you can page through and pick the exact
       load / stride / contact / extension moments.
    2. A contact-sheet image (grid thumbnail) for a quick at-a-glance overview of the whole swing.

.PARAMETER VideoPath
  Path to the source video (mp4/mov) in the videos/ folder.

.PARAMETER PlayerName
  Player name/slug, used to name the output subfolder under frames/. Frames for each clip are
  further nested under the video's own filename, so multiple at-bats per player (one per game)
  don't overwrite each other.

.PARAMETER Fps
  Frames per second to extract, measured against the SLOW-MO FILE'S OWN (stretched) playback
  timeline, not real time (default 10). A Pixel slow-mo file plays back N times slower than it
  was captured (N=4 for "1/4 speed" / 120fps capture, N=8 for "1/8 speed" / 240fps capture), so
  the real-time-equivalent density is Fps x N: at the default of 10, that's ~40 real frames/sec
  of swing at 1/4 speed, ~80 real frames/sec at 1/8 speed - both already denser than a ~0.3-0.5s
  swing needs positionally. Raise -Fps for a closer look at a specific window (e.g. contact) if
  10 isn't resolving something; you don't need it for general position checkpoints.

.EXAMPLE
  ./scripts/extract_frames.ps1 -VideoPath videos/maggie_m_20260802_eagles_ab1.mp4 -PlayerName maggie_m
  # writes to frames/maggie_m/maggie_m_20260802_eagles_ab1/
#>
param(
    [Parameter(Mandatory = $true)][string]$VideoPath,
    [Parameter(Mandatory = $true)][string]$PlayerName,
    [int]$Fps = 10
)

if (-not (Test-Path $VideoPath)) {
    Write-Error "Video not found: $VideoPath"
    exit 1
}

$clipName = [System.IO.Path]::GetFileNameWithoutExtension($VideoPath)
$outDir = Join-Path "frames" (Join-Path $PlayerName $clipName)
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

# Dense frame sequence
ffmpeg -y -i $VideoPath -vf "fps=$Fps" "$outDir/frame_%03d.png"

# Contact sheet: 5x4 grid of thumbnails spanning the whole clip
ffmpeg -y -i $VideoPath -vf "select='not(mod(n\,10))',scale=320:-1,tile=5x4" -frames:v 1 "$outDir/contact_sheet.png"

Write-Host "Frames written to $outDir"
Write-Host "Review contact_sheet.png first, then pull the specific frame_###.png files for: stance, load, stride/plant, contact, extension, follow-through."
