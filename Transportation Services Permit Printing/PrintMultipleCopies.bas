Attribute VB_Name = "Module1"
Sub PrintMultipleCopies()
    Dim i As Integer
    Dim w As Integer
    Dim x As Integer
    Dim y As Integer
    Dim z As Integer
    w = 1
    x = (Range("O17") / 4) + 1
    y = (Range("O17") / 2) + 1
    z = (Range("O17") / (4 / 3)) + 1
    For i = 1 To (Range("O17") / 4)
        Range("D26") = w
        Range("D26").Font.Bold = True
        Range("D26").HorizontalAlignment = xlLeft
        
        Range("H26") = x
        Range("H26").Font.Bold = True
        Range("H26").HorizontalAlignment = xlLeft
        
        Range("D55") = y
        Range("D55").Font.Bold = True
        Range("D55").HorizontalAlignment = xlLeft
        
        Range("H55") = z
        Range("H55").Font.Bold = True
        Range("H55").HorizontalAlignment = xlLeft
        
        With ActiveSheet.PageSetup.PrintGridlines = True
        End With
        ActiveSheet.PrintOut
        w = w + 1
        x = x + 1
        y = y + 1
        z = z + 1
    Next
    Range("D26").Clear
    Range("H26").Clear
    Range("D55").Clear
    Range("H55").Clear
End Sub
