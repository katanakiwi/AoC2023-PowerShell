$sample = $false
$day = "2"
set-location "$PSScriptRoot"

if ($sample) {
    $inputFile = "$day"+"sample.txt"
} else {
    $inputFile = "$day"+".txt"
}

$sumPossible = 0

$maxRedCubes = 12
$maxGreenCubes = 13
$maxBlueCUbes = 14

foreach ($line in $(get-content $inputFile)) {
    $possible = $true
    $parts = $line.split(":")
    $gameID = [int]$($parts[0]).remove(0,5)
    $reveals = $parts[1].split(";")
    $nrOfShows = $reveals.count
    foreach ($reveal in $reveals) {
        $setOfCubes = $reveal.split(",")
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