#import "NSString+ListComponents.h"

#import "import-private.h"



@implementation NSString( ListComponents)

- (NSRange) mulleRangeOfListComponent:(NSString *) component
                            separator:(NSString *) separator
{
   NSRange      search;
   NSRange      range;
   BOOL         match;
   NSUInteger   length;
   NSUInteger   preceeding;
   NSUInteger   following;
   NSUInteger   separatorLength;

   separatorLength = [separator length];
   if( separatorLength < 1)
      return( NSMakeRange( NSNotFound, 0));

   length = [self length];
   search = NSMakeRange( 0, length);
   for(;;)
   {
      range = [self rangeOfString:component
                          options:NSLiteralSearch
                            range:search];
      if( ! range.length)
         return( NSMakeRange( NSNotFound, 0));

      match = YES;
      if( range.location >= separatorLength)
      {
         // look for separator preceeding
         preceeding = range.location - separatorLength;
         match      = [self rangeOfString:separator
                                  options:NSLiteralSearch
                                    range:NSMakeRange( preceeding,
                                                       separatorLength)].length != 0;
      }

      if( match)
      {
         // look for separator following
         following = range.location + range.length;
         if( following + separatorLength <= length)
         {
            match = [self rangeOfString:separator
                                options:NSLiteralSearch
                                  range:NSMakeRange( following,
                                                     separatorLength)].length != 0;
         }
      }

      if( match)
         return( range);

      search = NSMakeRange( range.location + 1, length - (range.location + 1));
   }
}


- (NSString *) mulleStringByAddingListComponent:(NSString *) component
                                      separator:(NSString *) separator
{
   NSRange           range;
   NSMutableString   *s;

   if( [separator length] < 1)
      return( self);

   range = [self mulleRangeOfListComponent:component
                                 separator:separator];
   if( range.length)
      return( self);

   if( ! [self length])
      return( component);

   s = [NSMutableString stringWithString:self];
   [s appendString:separator];
   [s appendString:component];

   return( s);
}


- (NSString *) mulleStringByRemovingListComponent:(NSString *) component
                                        separator:(NSString *) separator
{
   NSRange      range;
   NSUInteger   length;
   NSUInteger   separatorLength;

   separatorLength = [separator length];
   if( separatorLength < 1)
      return( self);

   range = [self mulleRangeOfListComponent:component
                                 separator:separator];
   if( ! range.length)
      return( self);

   length = [self length];

   // 1 component
   if( range.length == length)
      return( @"");

   // 2 or more components, component is leading
   if( range.location == 0)
      return( [self stringByReplacingCharactersInRange:NSMakeRange( range.location,
                                                                    range.length + separatorLength)
                                            withString:nil]);

   return( [self stringByReplacingCharactersInRange:NSMakeRange( range.location - separatorLength,
                                                                 range.length + separatorLength)
                                         withString:nil]);
}

@end
