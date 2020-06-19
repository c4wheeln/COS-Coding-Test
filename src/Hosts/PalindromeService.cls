/* Ens.BusinessService*/

Class INFORMATION.PalindromeService Extends EnsLib.File.PassthroughService
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

/// Main class for reading in a file.
/// Parameters
/// pInput - This is the %FileCharacterStream found in the input folder.
/// Return
/// pOutput - Returning message of type %RegisteredObject
/// %Status - 
Method Main(pInput As %FileCharacterStream, pOutput As %RegisteredObject) As %Status
{
	set tSC = $$$OK
	
	try {
		// Get the size of the input file
		set OldSize = pInput.Size
		// Wait 1 second
		Hang 1
		// While the OldSize and the pInput.Size are different, the file is still being saved.
		while OldSize '= pInput.Size {
			// Save the OldSize for comparison
			set OldSize = pInput.Size
			Hang .5 
		}
		// The file is not changing anymore, so the file will just be passed through to the BusinessProcess
		
	} catch ex {
		
	}
	Quit tSC
}

}

