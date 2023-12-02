$sample = $false
$day = "1"


if ($sample) {
    $data = get-content ("$($PSScriptRoot)/$day"+"sample-a.txt")
} else {
    $data = get-content ("$($PSScriptRoot)/$day"+".txt")
}

function textToNumbers {
    param (
    $in,
    $digits = [ordered]@{one = "1e"; two = "2o"; three = "3e"; four = 4; five = "5e"; six = 6; seven = 7; eight = "8t"; nine = "9e";},
    #the job is not to replace numbers, but find the numbers written out. 
    #Therefore, replacing numbers with the last letter when it can be the start of a new number is required when replacing in the string.
    $ndex = 0
    )
    $maxLength = 5
    $minLength = 3

    for ($i = 0; $i -lt ($in.length -$minlength); $i++) {
        if ($i -lt $in.length -2) {
            $a = $([string]$($in[$i..$($i+2)])).replace(" ","")
            if ($digits.keys -contains $a) {
                $in = $in.remove($i,3).insert($i,$digits[$a])
                continue
            }
        }
        if ($i -lt $in.length -3) {
            $a = $([string]$($in[$i..$($i+3)])).replace(" ","")
            if ($digits.keys -contains $a) {
                $in = $in.remove($i,4).insert($i,$digits[$a])
                continue
            }
        }
        if ($i -lt $in.length -4) {
            $a = $([string]$($in[$i..$($i+4)])).replace(" ","")
            if ($digits.keys -contains $a) {
                $in = $in.remove($i,5).insert($i,$digits[$a])
                continue
            }
        }
    }
    foreach ($dig in $digitsAsText) {
        $ndex += 1
        if ($in -match $dig) {
            $in = $in.replace($dig,$ndex)
        }
    }
    return $in
}
$sum = 0
foreach ($line in $data) {

    $editedLine = textToNumbers -in $line
    $digits = $editedLine.ToCharArray() | ? {$_ -match '[0-9]'}
    if ($digits.length -eq 1) {
        [int]$value = "$digits"
        $sum += $value*11
    } else {
        [int]$v1 = "$($digits[0])"
        [int]$v2 = "$($digits[$($digits.length-1)])"
        $sum += 10*$v1 + $v2
    }
}

write-host "Sum: $sum"