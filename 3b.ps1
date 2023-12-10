$sample = $false
$day = "3"

if ($sample) {
    $data = get-content ("$($PSScriptRoot)/$day"+"sample.txt")
} else {
    $data = get-content ("$($PSScriptRoot)/$day"+".txt")
}

function getAsteriskLocations{
    param (
        $allLines
    )
    $gearPositions = @()

    for ($i = 0; $i -lt $allLines.Length; $i++) {
        $line = $allLines[$i]
        for ($j = 0; $j -lt $line.Length; $j++) {
            if($($line[$j]) -eq "*") {
                $gear = [PSCustomObject]@{
                    x = $j
                    y = $i
                }
                $gearpositions += $gear
            }
        }
    }
    return $gearPositions
}

function findAdjacentNumbers {
    param (
        $potentialGear
    )
    if ($potentialGear.Y -ne 0) { $aboveNumbers = scanNumbers $($data[$potentialGear.y -1])
    } else { $aboveNumbers = @() }
    $currentNumbers = scanNumbers $($data[$potentialGear.y])
    if ($potentialGear.Y -ne ($data.Length-1)) { $belowNumbers = scanNumbers $($data[$potentialGear.y +1])
    } else { $belowNumbers = @() }

    #found numbers, determine if adjacent...
    $allCloseNumbers = @()
    $allCloseNumbers += $aboveNumbers
    $allCloseNumbers += $currentNumbers
    $allCloseNumbers += $belowNumbers

    return $allCloseNumbers
}

function scanNumbers {
    param (
        $currentLine
    )
    $numbers = @()

    for ($i = 0; $i -lt $currentLine.length; $i++) {
        if ($($currentLine[$i]) -match "^[\d]") {
            $potentialPartNumber = [PSCustomObject]@{
                value = [System.Int32]::Parse($($currentLine[$i]))
                startPoint = $i
                indices = @($i)
                potentialPartOfGear = $false                
            }
            for ($j = $i+1; $j -lt $currentLine.length; $j++, $i++) {
                if ($($currentLine[$j]) -match "^[\d]") {
                    $potentialPartNumber.value = $($potentialPartNumber.value)*10 + [System.Int32]::Parse($($currentLine[$j]))
                    $potentialPartNumber.indices += $j
                    continue
                    #next character also a number
                } else {
                    $numbers += $potentialPartNumber
                    #no longer a number
                    break
                }
            }
            if ($j -eq $currentLine.length) {
                #when the loop is finished we reach the end of the line, and still need to add the number to the return-arary.
                $numbers += $potentialPartNumber
            }
        }
    }
    for ($n = 0; $n -lt $numbers.length; $n++) {
        $firstIndex = $($numbers[$n].indices[0])
        $lastIndex = $($numbers[$n].indices[$indices.length-1])

        if ($firstIndex -ne 0) { $($numbers[$n]).indices += $($firstIndex -1) }
        if ($lastIndex -ne ($currentLine.length -1)) { $($numbers[$n]).indices += $($lastIndex +1) }
    }
    return $numbers
}

$sumTotal = 0
$potentialGearLocations = getAsteriskLocations $data

for ($i = 0; $i -lt $potentialGearLocations.Length; $i++) {
    $adjacentNumbers = findAdjacentNumbers $potentialGearLocations[$i]

    
    for ($j = 0; $j -lt $adjacentNumbers.Length; $j++) {
        if ($adjacentNumbers[$j].indices -contains $potentialGearLocations[$i].x) { #fix -contains criteria
            $adjacentNumbers[$j].potentialPartOfGear = $true
            #do something
        }
    }
    $count = ($adjacentNumbers.potentialPartOfGear | ? {$_ -eq $true}).count
    if ($count -eq 2) {
        $intermediate = $adjacentNumbers | ? {$_.potentialPartOfGear -eq $true}
        $intermediateSum = $intermediate[0].value * $intermediate[1].value
        $sumTotal += $intermediateSum
    }
}

write-host "Total sum of valid part numbers: $sumTotal"
