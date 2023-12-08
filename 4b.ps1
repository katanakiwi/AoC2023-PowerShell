$sample = $false
$day = "4"

if ($sample) {
    $data = get-content ("$($PSScriptRoot)/$day"+"sample.txt")
} else {
    $data = get-content ("$($PSScriptRoot)/$day"+".txt")
}

$cardPoints = @()
$cardAmount = @(1)*$data.Length

for ($i = 0; $i -lt $data.Length; $i++) {
    $line = $data[$i]

    $cardPoints += [int]0
    $nrWon = 0

    $parts = $line.split(":|")
    $prizeNumbersString = $parts[1].split(" ") | Select-Object -SkipLast 1 | Select-Object -skip 1
    $parts[2] = $parts[2].Replace("  "," ")
    $drawnNumbersString = $parts[2].split(" ") | Select-Object -skip 1
    $prizeNumbers = @()
    $drawnNumbers = @()
    for ($j = 0; $j -lt $prizeNumbersString.Length; $j++) {
        $prizeNumbers += [int]$prizeNumbersString[$j]
    }
    for ($j = 0; $j -lt $drawnNumbersString.Length; $j++) {
        $nr = $drawnNumbersString[$j]

        if ($prizeNumbers -contains $nr) {
            $nrWon += 1
        }
        $drawnNumbers += [int]$drawnNumbersString[$j]
    }
    write-host "nr won: $nrwon"
    for ($j = 0; $j -lt $nrWon; $j++) {
        $cardAmount[$i+$j+1] += $cardAmount[$i]
    }
}

$totalCards = ($cardAmount | Measure-Object -Sum).sum
write-host "total cards: $totalCards"