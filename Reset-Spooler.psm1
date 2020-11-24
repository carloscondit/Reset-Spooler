<#
.SYNOPSIS
    Командлет для принудительной очистки каталога с файлами очереди печати.
.DESCRIPTION
    Командлет на локальном или удаленном компьютере останаливает службу печати,
    принудительно очищает каталог с файлами очереди печати и запускает службу печати.
.EXAMPLE
    PS C:\> Reset-Spooler -computername serv-1c
    Командлет выполнится на удаленном компьютере с именем serv-1c.
.INPUTS
    System.String
.NOTES
    Версия 0.1.3
    24.11.2020
#>
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
