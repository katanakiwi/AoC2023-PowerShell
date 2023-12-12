$sample = $false
$day = "7"

if ($sample) {
    $data = get-content ("$($PSScriptRoot)/$day"+"sample.txt")
} else {
    $data = get-content ("$($PSScriptRoot)/$day"+".txt")
}

$cardValueOrdered = @("2","3","4","5","6","7","8","9","A","B","C","D","E")

$unsortedHands = @()

for ($i = 0; $i -lt $data.Length; $i++) {
    #replacing the cards with numbers so we can sort them easily with 'sort ascending/descending'
    $line = $data[$i] -replace "A","E" -replace "K","D" -replace "Q","C" -replace "J","B" -replace "T","A" 
    $cards, $bet = $line.Split(" ")
    
    $handValue = @()
    #create an array with the counts of each card
    foreach ($card in $cardValueOrdered) {
        $count = ($cards | Select-String -Pattern $card -AllMatches).Matches.Count
        $handValue += $count 
    }
    #sort it, so we always have highest indices fist
    $handValue = $handValue | sort -Descending

    #determine the type of hand
    if ($handValue[0] -eq 5) {$HandStrength = 7} #5 of a kind
    elseif ($handValue[0] -eq 4) {$HandStrength = 6} #4 of a kind
    elseif (($handValue[0] -eq 3) -and ($handValue[1] -eq 2)) {$HandStrength = 5}
    elseif (($handValue[0] -eq 3) -and ($handValue[1] -eq 1)) {$HandStrength = 4}
    elseif (($handValue[0] -eq 2) -and ($handValue[1] -eq 2)) {$HandStrength = 3}
    elseif (($handValue[0] -eq 2) -and ($handValue[1] -eq 1)) {$HandStrength = 2}
    elseif ($handValue[0] -eq 1) {$HandStrength = 1}
    else {write-host "this shouldnt occur"}
    $unsortedHands +=  "$HandStrength $line"
    #write-host "hand strength: $HandStrength"
}
$sortedHands = $unsortedHands | sort -Descending
$amountOfHandsLeft = $sortedHands.count
$resultSum = 0
foreach ($hand in $sortedHands) {
    $bet = [int]($hand -split " ")[2] * $amountOfHandsLeft
    $resultSum += $bet
    $amountOfHandsLeft--
}

write-host "output: $resultSum"