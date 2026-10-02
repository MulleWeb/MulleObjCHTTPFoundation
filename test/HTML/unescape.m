//
//  unescape.m
//  MulleObjCHTTPFoundation
//
//  Copyright (c) 2026 Nat! - Mulle kybernetiK. All rights reserved.
//
//  Entities are printed as code points, so a supplementary plane character shows
//  up as the surrogate pair it is rather than as a shape in the terminal.
//

#import <MulleObjCHTTPFoundation/MulleObjCHTTPFoundation.h>

#include <stdio.h>


static void   show( NSString *entity)
{
   NSString     *result;
   NSUInteger   i;

   result = [entity mulleStringByUnescapingHTML];
   mulle_printf( "%-20s ->", [entity UTF8String]);
   for( i = 0; i < [result length]; i++)
      mulle_printf( " %04X", (unsigned) [result characterAtIndex:i]);
   mulle_printf( "  (len %lu)\n", (unsigned long) [result length]);
}


int   main( void)
{
   show( @"no entities here");

   //
   // "standard" sequences
   //
   show( @"&amp;");
   show( @"&lt;b&gt;");
   show( @"&quot;x&quot;");
   show( @"&nbsp;");
   show( @"&notanentity;");

   //
   // decimal
   //
   show( @"&#65;&#66;&#67;");
   show( @"&#38;");
   show( @"&#1234;");
   show( @"&#913;");

   //
   // hex
   //
   show( @"&#x41;&#x42;");
   show( @"&#XA3;");
   show( @"&#x263A;");
   show( @"&#x3c3;");

   //
   // supplementary planes
   //
   show( @"&#x1F600;");
   show( @"&#128512;");

   //
   // malformed, or out of range, has to come out untouched
   //
   show( @"&#;");
   show( @"&#x;");
   show( @"&#xZZ;");
   show( @"&#110000;");
   show( @"&#x110000;");

   //
   // surrogates are not code points: the old BMP branch fed them straight to
   // +stringWithCharacters: and the runtime rejected them
   //
   show( @"&#xD800;");
   show( @"&#55296;");
   show( @"&#xD83D;&#xDE00;");
   show( @"&;");
   show( @"a & b");
   show( @"&#x1F6000000;");

   //
   // mixed, and adjacent
   //
   show( @"&lt;&#65;&#x42;&amp;");
   show( @"&amp;amp;");
   show( @"<&amp;>");

   return( 0);
}
