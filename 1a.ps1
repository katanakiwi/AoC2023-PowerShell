$sample = $false
$day = "1"
set-location "$PSScriptRoot"

if ($sample) {
    $inputFile = "$day"+"sample.txt"
} else {
    $inputFile = "$day"+".txt"
}
$sum = 0
foreach ($line in $(get-content $inputFile)) {
    $digits = $line.ToCharArray() | ? {$_ -match '[0-9]'}
    if ($digits.length -eq 1) {
        [int]$value = "$digits"
        $sum += $value*11
    } else {
        [int]$v1 = "$($digits[0])"
        [int]$v2 = "$($digits[$($digits.length-1)])"
        $sum += 10*$v1 + $v2
    }
}

write-host $sum