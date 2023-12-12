$sample = $false
$day = "6"

if ($sample) {
    $data = get-content ("$($PSScriptRoot)/$day"+"sample.txt")
} else {
    $data = get-content ("$($PSScriptRoot)/$day"+".txt")
}


$times = ($data[0].split(":") | Select-Object -skip 1).split(" ") | ? {$_ -ne ""}
$dists = ($data[1].split(":") | Select-Object -skip 1).split(" ") | ? {$_ -ne ""}
$nrOfRaces = $times.length
$outPut = 1

for ($i = 0; $i -lt $nrOfRaces; $i++) {
    $distanceToBeat = [int]$dists[$i]
    $speed = 0
    $currentTime = 0
    $maximumTime = [int]$times[$i]
    $remainingTime = [int]$times[$i]
    $amountOfRacesThatCanBeatDistance = 0

    for ($j = 0; $j -le $times[$i]; $j++,$speed++,$remainingTime--) {
        $distanceIfReleasedNow = $speed * $remainingTime
        if ($distanceIfReleasedNow -gt $distanceToBeat) {
            $amountOfRacesThatCanBeatDistance++
        }
    }
    $output *= $amountOfRacesThatCanBeatDistance
}

write-host "output: $output"