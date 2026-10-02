//
//  parse.m
//  MulleObjCHTTPFoundation
//
//  Copyright (c) 2026 Nat! - Mulle kybernetiK. All rights reserved.
//
//  Dates are printed with -mulleHTTPDescription, so the output is a fixed
//  RFC 1123 GMT string and not locale or timezone dependent. An input that
//  does not parse prints "nil".
//

#import <MulleObjCHTTPFoundation/MulleObjCHTTPFoundation.h>

#include <stdio.h>


static void   show( char *label, NSDate *date)
{
   mulle_printf( "%-42s -> %s\n",
                 label,
                 date ? [[date mulleHTTPDescription] UTF8String] : "nil");
}


static void   showCombined( NSString *string)
{
   show( [string UTF8String], [NSDate mulleDateWithString:string]);
}


int   main( void)
{
   //
   // RFC 822 / HTTP dates: numeric offset, literal GMT, with and without
   // a weekday, with and without a zone.
   //
   showCombined( @"Tue, 08 Sep 2026 10:00:00 +0000");
   showCombined( @"Tue, 08 Sep 2026 10:00:00 +0200");
   showCombined( @"Sun, 06 Nov 1994 08:49:37 GMT");
   showCombined( @"08 Sep 2026 10:00:00 +0000");
   showCombined( @"08 Sep 2026 10:00:00");

   //
   // RFC 3339 / ISO 8601: Z, numeric offset, zone-less and date-only.
   //
   showCombined( @"2026-09-08T10:00:00Z");
   showCombined( @"2026-09-08T10:00:00+02:00");
   showCombined( @"2026-09-08T10:00:00");
   showCombined( @"2026-09-08");

   //
   // nothing
   //
   showCombined( @"");
   showCombined( @"not a date");

   //
   // the specific parsers do not accept the other dialect
   //
   show( "HTTP parser, ISO string",
         [NSDate mulleDateWithHTTPDateString:@"2026-09-08T10:00:00Z"]);
   show( "ISO parser, RFC 822 string",
         [NSDate mulleDateWithISO8601String:@"Tue, 08 Sep 2026 10:00:00 +0000"]);

   return( 0);
}