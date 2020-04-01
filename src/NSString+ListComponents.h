#import "import.h"



// mere string operations
@interface NSString( ListComponents)

// you can't have a nil or empty separator
- (NSRange) mulleRangeOfListComponent:(NSString *) component
                            separator:(NSString *) separator;

- (NSString *) mulleStringByAddingListComponent:(NSString *) component
                                     separator:(NSString *) separator;

- (NSString *) mulleStringByRemovingListComponent:(NSString *) component
                                        separator:(NSString *) separator;

@end