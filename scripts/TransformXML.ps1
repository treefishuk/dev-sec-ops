param(
    [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $PathToXsltFile,

    [Parameter(Mandatory=$True, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $PathOfXMLInputFile,

    [Parameter(Mandatory=$True, Position=2, ValueFromPipeline=$false)]
    [System.String]
    $PathOfOutputFile,

    [Parameter(Mandatory=$False, Position=3, ValueFromPipeline=$false)]
    [System.String]
    $ExcludeAlertRefs
)

Write-Host $PathToXsltFile
Write-Host $PathOfXMLInputFile
Write-Host $PathOfOutputFile
Write-Host $ExcludeAlertRefs

if( ! (test-path $PathToXsltFile)) { Throw "Xslt input file not found: $PathToXsltFile"}
$PathToXsltFile = resolve-path $PathToXsltFile

 if( ! (test-path $PathOfXMLInputFile)) { Throw "XML input file not found: $PathOfXMLInputFile"}
$PathOfXMLInputFile = resolve-path $PathOfXMLInputFile

$Xslt = New-Object System.Xml.Xsl.XslCompiledTransform

$Xslt.Load($PathToXsltFile)

$argList = New-Object System.Xml.Xsl.XsltArgumentList
$argList.AddParam("excludeAlertRef", "", $ExcludeAlertRefs)

$fileStream = New-Object System.IO.FileStream($PathOfOutputFile, [System.IO.FileMode]::Create)

Write-Host "Applying transform to Xml object"

$Xslt.Transform($PathOfXMLInputFile, $argList, $fileStream)

$fileStream.Close()