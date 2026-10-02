//
//  NSDate+MulleHTTP.m
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
#import "NSDate+MulleHTTP.h"


@implementation NSDate( MulleHTTP)

static struct
{
   mulle_atomic_pointer_t   _formatter;
   mulle_atomic_pointer_t   _httpDateParsers;
   mulle_atomic_pointer_t   _iso8601Parsers;
} Self;


+ (void) unload
{
   @autoreleasepool
   {
      [(id) _mulle_atomic_pointer_nonatomic_read( &Self._formatter) release];
      [(id) _mulle_atomic_pointer_nonatomic_read( &Self._httpDateParsers) release];
      [(id) _mulle_atomic_pointer_nonatomic_read( &Self._iso8601Parsers) release];
   }
}


//
// for this we need the MulleObjCOSFoundation
//
static NSDateFormatter  *getHTTPDateFormatter( void)
{
   NSDateFormatter  *formatter;

   /*
    * Cache
    */
   formatter = (NSDateFormatter *) _mulle_atomic_pointer_read( &Self._formatter);
   if( ! formatter)
   {
      formatter = [NSDateFormatter instance];
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


// The feed date dialects, each as a list of strftime-style formats tried in
// order. RFC 822 uses a numeric offset or a literal "GMT"; RFC 3339 uses "Z"
// or a numeric offset, optionally with a date-only or zone-less form.
static NSString  *http_date_formats[] =
{
   @"%a, %d %b %Y %H:%M:%S %z",
   @"%a, %d %b %Y %H:%M:%S GMT",
   @"%d %b %Y %H:%M:%S %z",
   @"%d %b %Y %H:%M:%S",
   nil
};


static NSString  *iso8601_date_formats[] =
{
   @"%Y-%m-%dT%H:%M:%S%z",
   @"%Y-%m-%dT%H:%M:%SZ",
   @"%Y-%m-%dT%H:%M:%S",
   @"%Y-%m-%d",
   nil
};


static NSArray  *getDateParsers( mulle_atomic_pointer_t *cache,
                                 NSString **formats,
                                 NSTimeZone *timeZone)
{
   NSArray         *parsers;
   NSMutableArray  *array;
   NSDateFormatter *formatter;
   NSLocale        *locale;

   parsers = (NSArray *) _mulle_atomic_pointer_read( cache);
   if( parsers)
      return( parsers);

   locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
   array  = [NSMutableArray arrayWithCapacity:4];
   for( ; *formats; ++formats)
   {
      formatter = [NSDateFormatter instance];
      [formatter setLocale:locale];
      [formatter setDateFormat:*formats];
      if( timeZone)
         [formatter setTimeZone:timeZone];
      [array addObject:formatter];
   }

   parsers = [array retain];
   mulle_atomic_memory_barrier();
   if( ! _mulle_atomic_pointer_cas( cache, parsers, NULL))
   {
      // another thread beat us, keep its parsers
      [parsers release];
      parsers = (NSArray *) _mulle_atomic_pointer_read( cache);
   }
   return( parsers);
}


static NSDate  *parseWithParsers( NSArray *parsers, NSString *string)
{
   NSDateFormatter  *formatter;
   NSDate           *date;

   for( formatter in parsers)
   {
      date = [formatter dateFromString:string];
      if( date)
         return( date);
   }
   return( nil);
}


+ (instancetype) mulleDateWithHTTPDateString:(NSString *) string
{
   NSArray  *parsers;

   if( ! [string length])
      return( nil);

   parsers = getDateParsers( &Self._httpDateParsers,
                             http_date_formats,
                             [NSTimeZone mulleGMTTimeZone]);
   return( parseWithParsers( parsers, string));
}


+ (instancetype) mulleDateWithISO8601String:(NSString *) string
{
   NSArray  *parsers;

   if( ! [string length])
      return( nil);

   parsers = getDateParsers( &Self._iso8601Parsers,
                             iso8601_date_formats,
                             [NSTimeZone mulleGMTTimeZone]);
   return( parseWithParsers( parsers, string));
}


+ (instancetype) mulleDateWithString:(NSString *) string
{
   id   date;

   date = [self mulleDateWithHTTPDateString:string];
   if( ! date)
      date = [self mulleDateWithISO8601String:string];
   return( date);
}

@end

