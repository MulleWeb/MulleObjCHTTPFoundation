#import "import.h"



//
// A list is something like @"a,b,c".
// @"a" @"b" @"c" are three components, @"," is the separator.
// A list can not have duplicate components, i.e. @"a,a,b" is invalid
//
@interface NSString( ListComponents)

// you can't have a nil or empty separator
- (NSRange) mulleRangeOfListComponent:(NSString *) component
                            separator:(NSString *) separator;

- (NSString *) mulleStringByAddingListComponent:(NSString *) component
                                     separator:(NSString *) separator;

- (NSString *) mulleStringByRemovingListComponent:(NSString *) component
                                        separator:(NSString *) separator;

@end