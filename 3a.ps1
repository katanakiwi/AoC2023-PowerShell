$sample = $false
$day = "3"

if ($sample) {
    $data = get-content ("$($PSScriptRoot)/$day"+"sample.txt")
} else {
    $data = get-content ("$($PSScriptRoot)/$day"+".txt")
}

function getSymbolIndices{
    param (
        $line
    )
    $indices = @()

    for ($i = 0; $i -lt $line.Length; $i++) {
        $character = $line[$i]
        if($character -match "[^0-9^.]") {
            $indices += $i
        }
    }

    return $indices
}

function scanNumbers {
    param (
        $currentLine
    )
    $numbers = @()
    $indices = @()

    for ($i = 0; $i -lt $currentLine.length; $i++) {
        if ($($currentLine[$i]) -match "^[\d]") {
            $number = [System.Int32]::Parse($($currentLine[$i]))
            $indices += $i
            $isParsingNumber = $true
            for ($j = $i+1; $j -lt $currentLine.length; $j++, $i++) {
                if ($($currentLine[$j]) -match "^[\d]") {
                    $number = $number*10 + [System.Int32]::Parse($($currentLine[$j]))
                    continue
                    #next character also a number
                } else {
                    $numbers += $number
                    $number = 0
                    $isParsingNumber = $false
                    #no longer a number
                    break
                }
            }
            if($isParsingNumber) {
                $numbers += $number
                $number = 0
                $isParsingNumber = $false
            }
        }
    }

    return $numbers, $indices
}

$sumTotal = 0

for ($i = 0; $i -lt $data.Length; $i++) {
    $line = $($data[$i])
    $numbers, $positions = scanNumbers $line

    $previousLineSymbolIndices = @()
    $currentLineSymbolIndices = getSymbolIndices -line $line
    $nextLineSymbolIndices = @()

    if ($i -eq 0) {
        $nextLineSymbolIndices = getSymbolIndices -line $($data[$i+1])
    } elseif ($i -eq ($data.Length - 1)) {
        $previousLineSymbolIndices = getSymbolIndices -line $($data[$i-1])
    } else {
        $nextLineSymbolIndices = getSymbolIndices -line $($data[$i+1])
        $previousLineSymbolIndices = getSymbolIndices -line $($data[$i-1])
    }
    $indicesInAdjacentLines = @()
    $indicesInAdjacentLines += $previousLineSymbolIndices
    $indicesInAdjacentLines += $currentLineSymbolIndices
    $indicesInAdjacentLines += $nextLineSymbolIndices

    for ($v = 0; $v -lt $numbers.Length; $v++) {
        $isPartNumber = $false
        #get range of valid positions for symbols, accounting for edges (min/max)
        $validRange = (([Math]::max($($positions[$v])-1,0))..([Math]::min($($positions[$v])+$($numbers[$v].toString().length),$line.Length-1)))
        for ($a = 0; $a -lt $indicesInAdjacentLines.Length; $a++) {
            if ($validRange -contains $($indicesInAdjacentLines[$a])) {
                $isPartNumber = $true
                $sumTotal += $numbers[$v]
            }
        }
    }
}

write-host "Total sum of valid part numbers: $sumTotal"