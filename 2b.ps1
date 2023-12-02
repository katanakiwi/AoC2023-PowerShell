$sample = $false
$day = "2"
set-location "$PSScriptRoot"

$maxRedCubes = 12
$maxGreenCubes = 13
$maxBlueCUbes = 14

if ($sample) {
    $inputFile = "$day"+"sample.txt"
} else {
    $inputFile = "$day"+".txt"
}

$sumPower = 0

foreach ($line in $(get-content $inputFile)) {
    $parts = $line.split(":")
    $gameID = [int]$($parts[0]).remove(0,5)
    $reveals = $parts[1].split(";")
    $nrOfShows = $reveals.count
    $minRedNeeded = 1
    $minBlueNeeded = 1
    $minGreenNeeded = 1
    foreach ($reveal in $reveals) {
        $setOfCubes = $reveal.split(",")
        foreach ($singleColor in $setOfCubes) {
            $nr = [int]$singleColor.split(" ")[1]
            $color = $singleColor.split(" ")[2]
            if ($color -eq "red") {
                if ($nr -gt $minRedNeeded) {$minRedNeeded = $nr}
            } elseif ($color -eq "blue") {
                if ($nr -gt $minBlueNeeded) {$minBlueNeeded = $nr}
            } elseif ($color -eq "green") {
                if ($nr -gt $minGreenNeeded) {$minGreenNeeded = $nr}
            }
        }
    }
    $power = $minRedNeeded * $minBlueNeeded * $minGreenNeeded
    write-host "game: $gameID `nPower: $power"
    $sumPower += $power
}

write-host "sum of power of possible games: $sumPower"