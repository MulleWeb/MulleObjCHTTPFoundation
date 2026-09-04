//
//  NSString+ListComponents.m
//  MulleObjCHTTPFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
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
