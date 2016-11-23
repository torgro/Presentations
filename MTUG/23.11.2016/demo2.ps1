#region Collections

#region Array

    [gc]::Collect()
    $array = @()
    Measure-Command -Expression {
        foreach ($int in (0..10000))
        {
            $array += Get-Random
        }
    }

    $array.Count
   


    [gc]::Collect()
    $arrayList = New-Object -TypeName System.Collections.ArrayList
    Measure-Command -Expression {
        foreach ($int in (0..10000))
        {
            $null = $arrayList.Add((Get-Random))
        }
    }

    $arrayList.GetType()

    $arrayList.Count



    [gc]::Collect()
    Measure-Command -Expression {
        $array = $arrayList.ToArray()
    }

    $array.GetType()

    $array.Count

#endregion

#region HashTables

    Get-ChildItem -Path .\upn.csv | 
        foreach {
            [PScustomobject]@{
                File = $_.Name 
                SizeKB = [int]($_.Length / 1kb)
                }
        }

    $userList.Count

    $upnList = Import-Csv -Path .\upn.csv -Delimiter "," -Encoding UTF8
    $upnList.Count

    $upnList | Select-Object -first 10


    [gc]::Collect()
    $upnHashLookup = @{}
    Measure-Command -Expression {
        foreach ($upn in $upnList)
        {
            $upnHashLookup.Add($upn.id,$upn)
        }
    }


    
    $newUserList = New-Object -TypeName System.Collections.ArrayList

    [gc]::Collect()
    Measure-Command -Expression {
        foreach ($User in $userList)
        {
            $upn = $upnHashLookup[$user.id].UserPrincipalName        
            $newUser = [pscustomobject]@{
                id = $user.id
                UserName = $user.UserName
                Location = $user.Location
                Description = $user.Description
                Upn = $upn
            }
            $null = $newUserList.Add($newUser)
        
            #Add-Member -InputObject $user -MemberType NoteProperty -Name Upn -Value $upn -PassThru
        }
    }

#endregion

#region Select-Object Unique
    
    # Took 00:13:23
    [gc]::Collect()
    Measure-Command -Expression {
        $userList.id | Select-Object -Unique
    }
    

    function Select-UniqueObject
    {
    [cmdletbinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [array]$Inputobject
    )
    Begin
    {
        $hashtable = @{}
    }

    Process
    {
        foreach($element in $Inputobject)
        {
            if (-not $hashtable.ContainsKey($element))
            {
                $hashtable.Add($element,[string]::Empty)
            }
        }
    }

    End
    {
        $hashtable.Keys
    }

    }


    $id = $userList[1].id

    $userList[1].id = $userList[0].id

    $userList | Select-Object -First 2

    $userList[1].id = $id


    [gc]::Collect()
    Measure-Command -Expression {
        (Select-UniqueObject -Inputobject $userList.id).count
    }

#endregion

#endregion