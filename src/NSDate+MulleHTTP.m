//
//  NSDate+MulleHTTP.m
//  MulleCivetWeb
//
//  Created by Nat! on 02.02.20.
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK
//  All rights reserved.
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

#import "NSDate+MulleHTTP.h"


@implementation NSDate( MulleHTTP)

static struct
{
   mulle_atomic_pointer_t   _formatter;
} Self;


+ (void) unload
{
   @autoreleasepool
   {
      [(id) _mulle_atomic_pointer_nonatomic_read( &Self._formatter) release];
   }
}


static NSDateFormatter  *getHTTPDateFormatter( void)
{
   NSDateFormatter  *formatter;

   /*
    * Cache
    */
   formatter = (NSDateFormatter *) _mulle_atomic_pointer_read( &Self._formatter);
   if( ! formatter)
   {
      formatter = [[NSDateFormatter new] autorelease];
      [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
   // http://tools.ietf.org/html/rfc2616#section-3.3
      [formatter setDateFormat:@"%a, %d %b %Y %H:%M:%S GMT"];
      [formatter setTimeZone:[NSTimeZone mulleGMTTimeZone]];

      // if
      mulle_atomic_memory_barrier();
      if( _mulle_atomic_pointer_cas( &Self._formatter, formatter, NULL))
         [formatter retain];
   }
   return( formatter);
}


- (NSString *) mulleHTTPDescription
{
// Sun, 06 Nov 1994 08:49:37 GMT
   NSDateFormatter  *formatter;

   formatter = getHTTPDateFormatter();
   return( [formatter stringFromDate:self]);
}

@end

