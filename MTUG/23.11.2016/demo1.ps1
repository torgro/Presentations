#region Know thy cmdlets

#region Get-Content

    Get-ChildItem -Path .\strings1.txt | 
        foreach {
            [PScustomobject]@{
                File = $_.Name 
                SizeKB = [int]($_.Length / 1kb)
                }
        }

    [gc]::Collect()
    Measure-Command -Expression {
        $Content = Get-Content -Path .\strings1.txt -Encoding UTF8
    }
    
    $Content.GetType()
    $content.Count
    $Content[0]


    [gc]::Collect()
    Measure-Command -Expression {
        $Content = Get-Content -Raw -Path .\strings1.txt -Encoding UTF8
    }

    $Content.GetType()
    $content.Count
    $Content[0]



    [gc]::Collect()
    Measure-Command -Expression {
        $Content = Get-Content -ReadCount 0 -Path .\strings1.txt -Encoding UTF8
    }

    $Content.GetType()
    $content.Count
    $Content[0]



    [gc]::Collect()
    Measure-Command -Expression {
        $Content = Get-Content -Raw -Path .\strings1.txt
    }

    $Content.GetType()
    $Content.Length
    $Content[0..15] -join ""



    Get-ChildItem -Path ".\strings?.txt" | 
        foreach {
            [PScustomobject]@{
                File = $_.Name 
                SizeKB = [int]($_.Length / 1kb)
                }
        }

    $measure = foreach ($file in (Get-ChildItem -Path ".\strings?.txt")) 
    {
        [gc]::Collect()
        $m = Measure-Command -Expression {
            $content = [System.IO.File]::ReadAllBytes($File.fullname)
        }
        [pscustomobject]@{
            File = $file.Name
            ms = $m.Milliseconds
            Ticks = $m.Ticks
        }
    } 

    $Content.GetType()
    $content[0..10]

    $measure

    #endregion

#region Select-String

    Get-Content -Path .\strings1.txt -Encoding UTF8 | Select-Object -first 10
    
    [gc]::Collect()
    Measure-Command -Expression {
        Get-ChildItem -Filter strings?.txt | Get-Content | Select-String -Pattern "Results"
    }


    
    [gc]::Collect()
    Measure-Command -Expression {
        Get-ChildItem -Filter strings?.txt | Select-String -Pattern "Results"
    }


#endregion

#region Where-Object

    Get-ChildItem -Path .\userlist.csv | 
        foreach {
            [PScustomobject]@{
                File = $_.Name 
                SizeKB = [int]($_.Length / 1kb)
                }
        }

    $userList = Import-Csv -Path .\userlist.csv -Delimiter "," -Encoding UTF8

    $userList.Count

    $userList | Select-Object -first 10

    

    [gc]::Collect()
    Measure-Command -Expression {
        $userList | Where-Object id -eq 1813981965
    }



    [gc]::Collect()
    Measure-Command -Expression {
        $userList.Where({ $_.id -eq 1813981965 })
    }




    [gc]::Collect()
    Measure-Command -Expression {
        for ($i = 1; $i -lt $userList.Count; $i++)
        { 
            if ($userList[$i].id -eq 1813981965)
            {
                $user
            }
        }
    }



    [gc]::Collect()
    Measure-Command -Expression {
        foreach ($user in $userList)
        {
            if ($user.id -eq 1813981965)
            {
                $user
            }
        }
    }



    $userHashList = @{}

    foreach ($user in $userList)
    {
        $userHashList.Add($user.id,$user)
    }


    [gc]::Collect()
    Measure-Command -Expression {
        $userHashList["1813981965"]
    }

    


#endregion

#region Foreach-Object

    [gc]::Collect()
    Measure-Command -Expression {
        $userList | ForEach-Object {
            if($_.id -eq 1813981965)
            {
                $_
            }
       }
    }

    [gc]::Collect()
    Measure-Command -Expression {
        $userList.ForEach({
            if($_.id -eq 1813981965)
            {
                $_
            }
       })
    }

    [gc]::Collect()
    Measure-Command -Expression {
        foreach ($user in $userList)
        {
            if ($user.id -eq 1813981965)
            {
                $user
            }
        }
    }


#endregion

#endregion