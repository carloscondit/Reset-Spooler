function Reset-Spooler {
    [CmdletBinding()]
    param (
        # Имя компьютера или список компьютеров
        [Parameter(Mandatory=$true,
        ValueFromPipeLine = $true)]
        [String[]]$ComputerName
    )
    
    begin {
        Write-Verbose "Начало работы командлета"
    }
    
    process {
        Write-Verbose "Устанавливаем связь с компьютером $ComputerName"
        $Session = New-PSSession -ComputerName $ComputerName
        $ScriptBlock = {
            $ServiceName = 'Spooler'
            Stop-Service -Name $ServiceName
            Remove-Item "C:\Windows\System32\spool\PRINTERS\*" -Recurse -Force
            Start-Service -Name $ServiceName 
        }
        
        Write-Verbose "Выполняем скриптоблок на компьютере $ComputerName"
        Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock

        Write-Verbose "Прерываем связь с компьютером $ComputerName"
        Remove-PSSession -Session $Session

    }
    
    end {
        Write-Verbose "Конец работы командлета" 
    }
}