$sample = $false
$day = "4"

if ($sample) {
    $data = get-content ("$($PSScriptRoot)/$day"+"sample.txt")
} else {
    $data = get-content ("$($PSScriptRoot)/$day"+".txt")
}

$cardPoints = @()

for ($i = 0; $i -lt $data.Length; $i++) {
    $line = $data[$i]

    $cardPoints += [int]0

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
            if ($cardPoints[$i] -eq 0) {
                $cardPoints[$i] = 1
            } else {
                $cardPoints[$i] = $cardPoints[$i] * 2
            }
        }
    }
    #write-host "card $i awards $($cardPoints[$i]) points!"

}

$totalPoints = ($cardPoints | Measure-Object -Sum).sum

write-host "total points: $totalPoints"