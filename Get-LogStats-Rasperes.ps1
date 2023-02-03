$ErrorActionPreference = 'Stop';
$logFileName = 'C:\Users\Rubens\OneDrive\Documents\sc_w3c_1.log';
$finalReport = [System.Collections.ArrayList]::new();

try {
    $logFile = Get-Content $logFileName | Select-Object -Skip 3;
}
catch {
    Write-Error "Error reading log file. Please check the path and file name.";
}

if ($logFile.Count -gt 0) {
    foreach ($line in $logFile) {
        $lineArray = $line.split(' ');
        $lineObjects = @{
            IPAddress = $lineArray[0]
            DateTime  = $lineArray[2] + " - " + $lineArray[3]
            StreamedMusic = $lineArray[4] -replace '\%[0-9]{1,2}',' ' -replace '\/stream\?title\=',''
            StreamClient = $lineArray[6] -replace '(\%[0-9A-Z]{1,2})', ' ' -replace '\s{2,}',' '
        }
        [void]$finalReport.Add($lineObjects);
    }    
}

#Top 20 IP Addresses
$finalReport | Group-Object IPAddress -NoElement     | Sort-Object Count -Descending -Top 20 | Format-Table -Auto -Wrap;
#top 20 Musics
$finalReport | Group-Object StreamedMusic -NoElement | Sort-Object Count -Descending -Top 20 | Format-Table -Auto -Wrap;
#top 20 Clients
$finalReport | Group-Object StreamClient -NoElement  | Sort-Object Count -Descending -Top 20 | Format-Table -Auto -Wrap;