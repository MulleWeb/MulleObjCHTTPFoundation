//
//  main.m
//  NSURLTest
//
//  Created by Nat! on 24.02.20.
//  Copyright © 2020 Nat!. All rights reserved.
//
#ifdef __MULLE_OBJC__
# import <MulleObjCInetFoundation/MulleObjCInetFoundation.h>
# include <mulle-stacktrace/mulle-stacktrace.h>
#else
# import <Foundation/Foundation.h>
#endif

@interface NSObject( CStringDescription)
@end


@implementation NSObject( CStringDescription)

- (char *) cStringDescription
{
   return( [[self description] UTF8String]);
}

@end


static void   print_url( NSURL  *url)
{
   char  *s;

   printf( "Scheme            : %s\n", (s = [[url scheme] cStringDescription]) ? s : "*nil*");
   printf( "User              : %s\n", (s = [[url user] cStringDescription]) ? s : "*nil*");
   printf( "Password          : %s\n", (s = [[url password] cStringDescription]) ? s : "*nil*");
   printf( "Host              : %s\n", (s = [[url host] cStringDescription]) ? s : "*nil*");
   printf( "Port              : %ld\n",[[url port] longValue]);
   printf( "Path              : %s\n", (s = [[url path] cStringDescription]) ? s : "*nil*");
   printf( "Parameter         : %s\n", (s = [[url parameterString] cStringDescription]) ? s : "*nil*");
   printf( "Query             : %s\n", (s = [[url query] cStringDescription]) ? s : "*nil*");
   printf( "Fragment          : %s\n", (s = [[url fragment] cStringDescription]) ? s : "*nil*");
   printf( "ResourceSpecifier : %s\n", (s = [[url resourceSpecifier] cStringDescription]) ? s : "*nil*");
}


static void   print( NSURL *url)
{
#ifdef __MULLE_OBJC__
   [url mulleDump];
#endif

   if( url)
      print_url( url);
   else
      printf( "nil");
   printf( "\n");
}


int   main( int argc, const char * argv[])
{
   NSURL                             *url;
   struct MulleEscapedURLPartsUTF8   parts;

   /**/
   memset( &parts, 0, sizeof( parts));
   parts.escaped_parameter.characters = (mulle_utf8_t *) "a=1";
   parts.escaped_parameter.length     = -1;

   url = [[[NSURL alloc] mulleInitWithEscapedURLPartsUTF8:&parts
                                   allowedURICharacterSet:nil] autorelease];
   print( url);


   /**/
   memset( &parts, 0, sizeof( parts));
   parts.escaped_parameter.characters = (mulle_utf8_t *) "a=1;b=3";
   parts.escaped_parameter.length     = -1;

   url = [[[NSURL alloc] mulleInitWithEscapedURLPartsUTF8:&parts
                                   allowedURICharacterSet:nil] autorelease];
   print( url);

   /**/
   memset( &parts, 0, sizeof( parts));
   parts.escaped_parameter.characters = (mulle_utf8_t *) "a=1;b=1%202%203";
   parts.escaped_parameter.length     = -1;

   url = [[[NSURL alloc] mulleInitWithEscapedURLPartsUTF8:&parts
                                   allowedURICharacterSet:nil] autorelease];
   print( url);
   return 0;
}


