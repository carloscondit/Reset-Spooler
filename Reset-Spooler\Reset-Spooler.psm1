<#
.SYNOPSIS
    Командлет для принудительной очистки каталога с файлами очереди печати.
.DESCRIPTION
    Командлет на локальном или удаленном компьютере останаливает службу печати,
    принудительно очищает каталог с файлами очереди печати и запускает службу печати.
.EXAMPLE
    PS C:\> Reset-Spooler -ComputerName HV-IT -Verbose
    VERBOSE: Начало работы командлета
    VERBOSE: Устанавливаем связь с компьютером HV-IT
    VERBOSE: Выполняем скриптоблок на компьютере HV-IT
    VERBOSE: Прерываем связь с компьютером HV-IT
    VERBOSE: Конец работы командлета
    PS C:\>
    Командлет выполнится на удаленном компьютере с именем HV-IT с выводом подробной информации.
.INPUTS
    System.String
.NOTES
    Версия 0.1.4
    29.11.2020
#>
function Reset-Spooler {
    [CmdletBinding()]
    param (
        # Имя компьютера или список имен компьютеров
        [Parameter(ValueFromPipeLine = $true)]
        [Alias("CN", "MachineName")]
        [String[]]$ComputerName
    )
    
    begin {
        Write-Verbose "Начало работы функции"
        Set-StrictMode –Version 2.0
    }
    
    process {
        $ScriptBlock = {
            $ServiceName = 'Spooler'
            Stop-Service -Name $ServiceName
            $SpoolerFolder = "$($(Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Print\Printers').DefaultSpoolDirectory)"
            Remove-Item "$SpoolerFolder\*" -Recurse -Force
            Start-Service -Name $ServiceName 
        }
        if ($ComputerName) {
            Write-Verbose "Устанавливаем связь с компьютером $ComputerName"
            $Session = New-PSSession -ComputerName $ComputerName
        
            Write-Verbose "Выполняем скриптоблок на компьютере $ComputerName"
            Invoke-Command -Session $Session -ScriptBlock $ScriptBlock

            Write-Verbose "Прерываем связь с компьютером $ComputerName"
            Remove-PSSession -Session $Session
        } #If
        else {
            Write-Verbose 'Выполняем скриптоблок на локальном компьютере'
            Invoke-Command -ScriptBlock $ScriptBlock
        } #else

    } #Process
    
    end {
        Write-Verbose "Конец работы функции" 
    }
}
