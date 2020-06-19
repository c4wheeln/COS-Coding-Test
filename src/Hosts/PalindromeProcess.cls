Class INFORMATION.PalindromeProcess Extends Ens.BusinessProcess [ ClassType = persistent, Language = objectscript ]
{

/// Process the request message for this Process
/// This Process reads the file contents, check each string for the longest palindrome,
/// then sends the longest palindrome to the BusinessOperation to save the strings to a file.
/// Parameters
/// pRequest - Ens.Request message type
/// Return
/// pResponse - Ens.Response message type
/// %Status - Successful processing is 1
Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	// Create the global and variables
	k ^Palindrome
	set tSC = $$$OK
	set Delimiter = ","
	// Get the filename from the request message
	set filename = pRequest.OriginalFilename
	
	// Check to see if the file really exists before trying to open it
	if (##class(%File).Exists(filename)) {
		// Instantiate the object for the file and set the reading flag
		set file = ##class(%File).%New(filename)
		set tSC = file.Open( "R" ) 
		if $$$ISERR(tSC) quit
		
		// Read the file. Read the file contents into an array and close the file before checking any palindromes.
		while 'file.AtEnd {
			set str = file.ReadLine() 
			for i=1:1:$length(str, Delimiter) {
				set word = $piece(str, Delimiter, i) 
				// Put each word in an array
				set array(i) = word
			}
		}
		do file.Close()
		
		// Evaluate for palindrome entries
		set idx = ""
		for {
			set idx = $o(array(idx)) q:idx=""
			set str = array(idx)
			// Get the longest palindrome
			set substr = ..LongestPalindrome(str)
			if (substr '= "") {
				// Save to global
				set ^Palindrome(substr) = ""
			}
		}
		
		// Setup the properties for the SendRequestSync to the BusinessOperation
		set pTargetDispatchName = "PalindromeOperation"
		set pReq = ##class(Ens.StringRequest).%New()
		// pResp is of type Ens.Response
		set (str,pals) = "", k = 0
		for {
			// Get all of the strings out of the global to pass to the BusinessOperation
			set str = $o(^Palindrome(str)) q:str=""
			set pals = $s(pals="":str,1:pals_","_str)
		}
		// Put the comma delimited string into the request message
		set pReq.StringValue = pals
		set pTimeOut = -1
		set pDescription = ""	// "Palindrome Operation"
		// Call the BusinessOperation
		set tSC = ..SendRequestSync(pTargetDispatchName, pReq, .pResp,, pDescription)
	}
	// Clean up. Kill the global.
	k ^Palindrome
	return 1
}

/// Check the input string for the longest palindrome.
/// --This method need to be enhanced to handle palindromes that are phrases.
/// --Also the original string has been modified to check since this checking does not handle non-palindrome characters.
/// Parameters
/// input - The string to check to see if there is a palindrome and find the longest in the string
/// Return
/// String - The string of the longest palindrone found in the input
Method LongestPalindrome(input As %String) As %String
{
	set k = 0
	// Remove characters that are not considered to be part of the palindrome
	set input = $replace(input," ","")
	set input = $replace(input,"?","")
	set input = $replace(input,".","")

	// Initialize variables
	set (rightIndex,leftIndex) = 0
	set currentPalindrome = "", longestPalindrome = ""
	set centerIndex = 1
	
	// Search for the center of the palindrome
	while (centerIndex <= ($length(input))) {
		set leftIndex = centerIndex - 1,rightIndex = centerIndex + 1
		
		// Loop checking the left and right characters from the centerIndex
		while ((leftIndex >= 0) && (rightIndex <= $length(input))) {
			// This checks for the case where the palindrome center is the same two characters or a single character is the center
			if ($zcvt($extract(input,leftIndex),"L") '= $zcvt($extract(input,rightIndex),"L")) &&
				($zcvt($extract(input,leftIndex),"L") '= $zcvt($extract(input,rightIndex-1),"L")) && 
				($zcvt($extract(input,leftIndex+1),"L") '= $zcvt($extract(input,rightIndex),"L")) {
				quit	// If the above 3 comparisons are false, the center has not been found or the whole palindrome has already been found
			}
			// Keep track of the current palindrome to compare it with the longest
			set currentPalindrome = $extract(input,leftIndex, rightIndex)
			// Keep the longest either from current or what has already been found
			set longestPalindrome = $s($length(currentPalindrome) > $length(longestPalindrome):currentPalindrome,1:longestPalindrome)

			// Adjust the indexes for checking more characters
			set leftIndex=leftIndex-1,rightIndex=rightIndex+1
		}
		// Move the centerIndex one more character to the right to start checking.
		set centerIndex = centerIndex + 1
	}
	// Return the longest palindrome found.
	return longestPalindrome
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

