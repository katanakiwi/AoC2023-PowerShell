$sample = $false
$day = "6"

if ($sample) {
    $data = get-content ("$($PSScriptRoot)/$day"+"sample.txt")
} else {
    $data = get-content ("$($PSScriptRoot)/$day"+".txt")
}


$time = [int64]($data[0].Replace(" ","").split(":") | select -skip 1)
$distanceToBeat = [int64]($data[1].Replace(" ","").split(":") | select -skip 1)
$amountOfRacesThatCanBeatDistance = 0
$speed = 0
$remainingTime = $time
$firstRace = 0
$lastRace = 0 

for ($i = 0; $i -le $time; $i++, $speed++, $remainingTime--) {
    $distanceIfReleasedNow = $speed * $remainingTime
    if ($distanceIfReleasedNow -gt $distanceToBeat) {
        $firstRace = $i
        write-host "first $i"
        break;
    }
}

$remainingTime = 0
$speed = $time
for ($i = $time; $i -ge 0; $i--, $speed--, $remainingTime++) {
    $distanceIfReleasedNow = $speed * $remainingTime
    if ($distanceIfReleasedNow -gt $distanceToBeat) {
        $lastRace = $i
        write-host "first $i"
        break;
    }
}

$amountOfRacesThatCanBeatDistance = $lastRace - $firstRace +1

write-host "amountOfRaces: $amountOfRacesThatCanBeatDistance"