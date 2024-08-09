param(
    [Parameter(Mandatory=$True, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $PathOfInputFile,

    [Parameter(Mandatory=$True, Position=2, ValueFromPipeline=$false)]
    [System.String]
    $PathOfOutputFile
)

Write-Host $PathOfInputFile
Write-Host $PathOfOutputFile

$scanOutput = Get-Content -Path $PathOfInputFile

# Split the scan output into individual lines
$lines = $scanOutput -split "`n"

# Create an XML document
$xmlDoc = New-Object System.Xml.XmlDocument
$xmlDeclaration = $xmlDoc.CreateXmlDeclaration("1.0", "utf-8", $null)
$xmlDoc.AppendChild($xmlDeclaration)

# Create a root element named "testsuites"
$xmlRoot = $xmlDoc.CreateElement("testsuites")
$xmlDoc.AppendChild($xmlRoot)

# Parse each line and add to the XML
foreach ($line in $scanOutput) {
    $cleanedLine = $line -replace "[\[\]]", ""  # Remove square brackets
    $parts = $cleanedLine -split " "
    $testSuiteName = $parts[0]
    $failureType = $parts[1]
    $failureMessage = $parts[2..($parts.Length - 1)] -join " "

    # Create <testsuite> element
    $testSuiteElement = $xmlDoc.CreateElement("testsuite")
    $testSuiteElement.SetAttribute("name", $testSuiteName)
    $testSuiteElement.SetAttribute("time", "0")

    # Create <testcase> element
    $testCaseElement = $xmlDoc.CreateElement("testcase")
    $testCaseElement.SetAttribute("name", $testSuiteName)
    $testCaseElement.SetAttribute("time", "0")

    # Create <failure> element
    $failureElement = $xmlDoc.CreateElement("failure")
    $failureElement.SetAttribute("type", $failureType)
    $failureElement.SetAttribute("message", $failureMessage)

    # Append elements to the hierarchy
    $testCaseElement.AppendChild($failureElement)
    $testSuiteElement.AppendChild($testCaseElement)
    $xmlRoot.AppendChild($testSuiteElement)
}

# Save the XML to a file
$xmlDoc.Save("nuclei_scan_results.xml")