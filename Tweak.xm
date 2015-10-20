// Return a version of the input string where all misspellings have been fixed
static NSString * correctWords(NSString * input, NSString * lang = @"en-US") {
	if (input && [input length]) {
		// Setup
		UITextChecker *checker = [[%c(UITextChecker) alloc] init];
		NSRange checkRange = NSMakeRange(0, [input length]);
		NSRange misspelledRange;

		// Correct every word until we can't find any more
		while (true) {
			// Check for next misspelled word
			misspelledRange = [checker rangeOfMisspelledWordInString:input
																												 range:checkRange
																										startingAt:checkRange.location
																													wrap:NO
																											language:lang];

			// If a misspelled word was detected
			if (misspelledRange.location == NSNotFound) {
				break;
			} else {
				// Retrieve correction guesses
				NSArray *arrGuessed = [checker guessesForWordRange:misspelledRange inString:input language:lang];
				if ([arrGuessed count]) {
					// Substitute correction
					input = [input stringByReplacingCharactersInRange:misspelledRange
																								 withString:[arrGuessed objectAtIndex:0]];
				}

				// Push checkRange forward
				checkRange.location = misspelledRange.location + misspelledRange.length;
				checkRange.length = [input length] - checkRange.location;
			}
		}

		// Spell checking is finished; Clean up
		[checker release];
	}
	return input;
}

%hook UILabel
-(void)_setText:(id)arg1 {
	%orig(correctWords(arg1));
	return;
}
%end

%hook SBIconLabelImageParameters
// Note: Hooking this getter is probably expensive. Find a better alternative?
// (Hooking setText did not work)
-(NSString *)text {
	return correctWords(%orig());
}
%end
