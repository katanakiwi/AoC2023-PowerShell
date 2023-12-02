$sample = $false
$day = "2"

if ($sample) {
    $data = get-content ("$($PSScriptRoot)/$day"+"sample.txt")
} else {
    $data = get-content ("$($PSScriptRoot)/$day"+".txt")
}

$sumPossible = 0

$maxRedCubes = 12
$maxGreenCubes = 13
$maxBlueCUbes = 14

foreach ($line in $data) {
    $possible = $true
    $parts = $line.split(":")
    $gameID = [int]$($parts[0]).remove(0,5)
    $shows = $parts[1].split(";")
    $nrOfShows = $reveals.count
    foreach ($handShow in $shows) {
        $setOfCubes = $handShow.split(",")
        foreach ($singleColor in $setOfCubes) {
            $nr = [int]$singleColor.split(" ")[1]
            $color = $singleColor.split(" ")[2]
            if ($color -eq "red") {
                if ($nr -gt $maxRedCubes) { $possible = $false; continue }
            }elseif ($color -eq "blue") {
                if ($nr -gt $maxBlueCubes) { $possible = $false; continue }
            }elseif ($color -eq "green") {
                if ($nr -gt $maxGreenCUbes) { $possible = $false; continue }
            }
        }
    }
    if ($possible) { $sumPossible += $gameID }
}

write-host "sum of IDs of possible games: $sumPossible"