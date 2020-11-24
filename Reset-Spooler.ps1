function Reset-Spooler {
    [CmdletBinding()]
    param (
        # Имя компьютера или список компьютеров
        [Parameter(ValueFromPipeLine = $true)]
        [String[]]$ComputerName="$env:computername"
    )
    
    begin {
        Write-Verbose "Начало работы командлета"
    }
    
    process {
        $Session = New-PSSession -ComputerName $ComputerName
        $ScriptBlock = {
            $ServiceName = 'Spooler'
            Stop-Service -Name $ServiceName  
            Remove-Item "C:\Windows\System32\spool\PRINTERS\*" -Recurse -Force
            Start-Service -Name $ServiceName 
        }

        Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock
        Remove-PSSession -Session $Session

    }
    
    end {
        Write-Verbose "Конец работы командлета" 
    }
}