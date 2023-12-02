$sample = $false
$day = "2"

if ($sample) {
    $data = get-content ("$($PSScriptRoot)/$day"+"sample.txt")
} else {
    $data = get-content ("$($PSScriptRoot)/$day"+".txt")
}

$sumPower = 0

foreach ($line in $data) {
    $parts = $line.split(":")
    $gameID = [int]$($parts[0]).remove(0,5)
    $shows = $parts[1].split(";")
    $nrOfShows = $shows.count
    #minimum can be 0 in cases, but that doesn't matter for the purpose of cubing
    $minRedNeeded = 1 
    $minBlueNeeded = 1
    $minGreenNeeded = 1
    foreach ($handShow in $shows) {
        $setOfCubes = $handshow.split(",")
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
    $sumPower += $power
}

write-host "sum of power of possible games: $sumPower"