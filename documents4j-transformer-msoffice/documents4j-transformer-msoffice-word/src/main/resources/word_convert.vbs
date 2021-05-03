' See http://msdn.microsoft.com/en-us/library/bb243311%28v=office.12%29.aspx
Const WdDoNotSaveChanges = 0
Const WdExportFormatPDF = 17
Const MagicFormatPDFA = 999
Const MagicFormatFilteredHTML = 10
Const msoEncodingUTF8 = 65001

Dim arguments
Set arguments = WScript.Arguments

' Transforms a file using MS Word into the given format.
Function ConvertFile( inputFile, outputFile, formatEnumeration )

  Dim fileSystemObject
  Dim wordApplication
  Dim wordDocument

  ' Get the running instance of MS Word. If Word is not running, exit the conversion.
  On Error Resume Next
  Set wordApplication = GetObject(, "Word.Application")
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

    ' Open: See https://msdn.microsoft.com/en-us/library/office/ff835182.aspx
    ' PasswordDocument	Optional	Variant	The password for opening the document.
    ' PasswordTemplate	Optional	Variant	The password for opening the template.
    ' Revert	Optional	Variant	Controls what happens if FileName is the name of an open document. True to discard any unsaved changes to the open document and reopen the file. False to activate the open document.
    ' WritePasswordDocument	Optional	Variant	The password for saving changes to the document.
    ' WritePasswordTemplate	Optional	Variant	The password for saving changes to the template.
    ' Format	Optional	Variant	The file converter to be used to open the document. Can be one of the WdOpenFormat constants. The default value is wdOpenFormatAuto. To specify an external file format, apply the OpenFormat property to a FileConverter object to determine the value to use with this argument.
    ' Encoding	Optional	Variant	The document encoding (code page or character set) to be used by Microsoft Word when you view the saved document. Can be any valid MsoEncoding constant. For the list of valid MsoEncoding constants, see the Object Browser in the Visual Basic Editor. The default value is the system code page.
    ' Visible	Optional	Variant	True if the document is opened in a visible window. The default value is True.
    ' OpenConflictDocument	Optional	Variant	Specifies whether to open the conflict file for a document with an offline conflict.
    ' OpenAndRepair	Optional	Variant	True to repair the document to prevent document corruption.
    ' DocumentDirection	Optional	WdDocumentDirection	Indicates the horizontal flow of text in a document. The default value is wdLeftToRight.
    ' NoEncodingDialog	Optional	Variant	True to skip displaying the Encoding dialog box that Word displays if the text encoding cannot be recognized. The default value is False.'
    Set wordDocument = wordApplication.Documents.Open(inputFile, False, True, False,"#!#+?ß12345+!.-2vbsfgdVDFAS", "#!#+?ß12345+!.-2vbsfgdVDFAS")

    ' If the document cannot be opened due to it, its handle is empty.
    If wordDocument = "" OR Err <> 0 Then
        ' Wrong password detected (5408 for password for doc files, 5121 password for ott files)
        If Err = 5408 OR Err = 5121 Then
            WScript.Quit -10
        End If
      WScript.Quit -2
    End If
    On Error GoTo 0

    If formatEnumeration = MagicFormatFilteredHTML Then
      wordDocument.WebOptions.Encoding = msoEncodingUTF8
    End If

    ' Convert: See http://msdn2.microsoft.com/en-us/library/bb221597.aspx
    On Error Resume Next
    If formatEnumeration = MagicFormatPDFA Then
      wordDocument.ExportAsFixedFormat outputFile, WdExportFormatPDF, False, , , , , , , , , , , True
    Else
      wordDocument.SaveAs outputFile, formatEnumeration
    End If

    ' Close the source document.
    wordDocument.Close WdDoNotSaveChanges
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
Call ConvertFile( WScript.Arguments.Unnamed.Item(0), WScript.Arguments.Unnamed.Item(1), CInt(WScript.Arguments.Unnamed.Item(2)) )
