Class INFORMATION.PalindromeOperation Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Property Adapter As EnsLib.File.OutboundAdapter;

Parameter INVOCATION = "InProc";

/// Write the string to a file
/// Parameters
/// pRequest - Ens.StringRequest message type
/// Return
/// pResponse - Ens.Response message type reference
/// %Status - Successful method execution will return 1 
Method WriteString(pRequest As Ens.StringRequest, Output pResponse As Ens.Response) As %Status
{
	// Intantiate the response message
	set pResponse = ##class(Ens.Response).%New()
	
	// Get the string to save to a file
	set str = pRequest.StringValue
	// If the string is empty, return without error
	if str = "" return 1
	
	// Root of the output file name
	set filename = "Output"
	// Get the date/time stamp to use in the filename
	set stamp = $zdt($h,3)
	// Adjust the date/time stamp format to clean up and remove illegal filename characters
	set stamp = $replace(stamp," ","_")
	set stamp = $replace(stamp,"-","")
	set stamp = $replace(stamp,":","")
	// Filename to save
	set filename = filename _ stamp _ ".txt"
	
	// Count how many pieces are going to be written to the file, one per line.
	set len = $length(str,",")
	
	// Create a temporary stream to hold the file content
	set tTmpStream=##class(%FileCharacterStream).%New()
	
	set offset = 1
	// Loop on all of the pieces to be written to the output file
	while (offset <= len) {
		// Get each piece
		set line = $piece(str,",",offset)
		// Write the line to the stream
		d tTmpStream.WriteLine(line)
		// Increment to the next piece
		set offset = offset + 1
	}
	
	// Write the stream to the output file
	set tSC = ..Adapter.PutStream(filename,tTmpStream)
	
	return 1
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StringRequest"> 
		<Method>WriteString</Method>
	</MapItem>
</MapItems>
}

}

