' See http://msdn.microsoft.com/en-us/library/bb243311%28v=office.12%29.aspx
Const WdDoNotSaveChanges = 0
Const WdExportFormatPDF = 32
Const MagicFormatPDFA = 999

Dim arguments
Set arguments = WScript.Arguments

' Transforms a file using MS Powerpoint into the given format.
Function ConvertFile( inputFile, outputFile, formatEnumeration )

  Dim fileSystemObject
  Dim powerpointApplication
  Dim powerpointPresentation

  ' Get the running instance of MS Powerpoint. If Powerpoint is not running, exit the conversion.
  ' Set powerpointApplication = CreateObject("PowerPoint.Application")

  ' Get the running instance of MS Powerpoint. If PowerPoint is not running, exit the conversion.
  On Error Resume Next
  Set powerpointApplication = GetObject(, "PowerPoint.Application")
  If Err <> 0 Then
    WScript.Quit -6
  End If
  On Error GoTo 0

  ' Find the source file on the file system.
  Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
  inputFile = fileSystemObject.GetAbsolutePathName(inputFile)

  ' Convert the source file only if it exists.
  If fileSystemObject.FileExists(inputFile) Then

    ' Attempt to open the source document.
    On Error Resume Next

    ' https://docs.microsoft.com/en-us/office/vba/api/powerpoint.presentations.open
    ' 1st argument - filename together with password - see https://www.mrexcel.com/board/threads/excel-vba-to-open-a-password-protected-power-point-presentation.1015613/
    ' 2nd argument - ReadOnly'
    ' 3rd argument - Untitled'
    ' 4rd argument - WithWindow'
    Set powerpointPresentation = powerpointApplication.Presentations.Open(inputFile + "::#!#+?ß12345+!.-2vbsfgdVDFAS::", , , FALSE)

    If Err <> 0 Then
      ' MsgBox Err
      ' MsgBox Err.Description
      if Err = -2147467259 AND InStr(1, Err.Description, "Presentations.Open : Reenter the &password") = 1 Then
              WScript.Quit -10
      End If

      WScript.Quit -2
    End If
    On Error GoTo 0

    ' Convert: See http://msdn2.microsoft.com/en-us/library/bb221597.aspx
    On Error Resume Next
    
    powerpointPresentation.SaveAs outputFile, formatEnumeration, True

    ' Close the source document.
    powerpointPresentation.Close

    If Err <> 0 Then
      WScript.Quit -3
    End If
    On Error GoTo 0

    ' Signal that the conversion was successful.
    WScript.Quit 2

  Else

    ' Files does not exist, could not convert
    WScript.Quit -4

  End If

End Function


' Execute the script.
Call ConvertFile( arguments.Unnamed.Item(0), arguments.Unnamed.Item(1), CInt(arguments.Unnamed.Item(2)) )