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

- (char *) UTF8String
{
   return( [[self description] UTF8String]);
}

@end


static void   print_url( NSURL  *url)
{
   char  *s;

   printf( "Scheme            : %s\n", (s = [[url scheme] UTF8String]) ? s : "*nil*");
   printf( "User              : %s\n", (s = [[url user] UTF8String]) ? s : "*nil*");
   printf( "Password          : %s\n", (s = [[url password] UTF8String]) ? s : "*nil*");
   printf( "Host              : %s\n", (s = [[url host] UTF8String]) ? s : "*nil*");
   printf( "Port              : %ld\n",[[url port] longValue]);
   printf( "Path              : %s\n", (s = [[url path] UTF8String]) ? s : "*nil*");
   printf( "Parameter         : %s\n", (s = [[url parameterString] UTF8String]) ? s : "*nil*");
   printf( "Query             : %s\n", (s = [[url query] UTF8String]) ? s : "*nil*");
   printf( "Fragment          : %s\n", (s = [[url fragment] UTF8String]) ? s : "*nil*");
   printf( "ResourceSpecifier : %s\n", (s = [[url resourceSpecifier] UTF8String]) ? s : "*nil*");
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
   parts.escaped_query.characters = "a=1";
   parts.escaped_query.length     = -1;

   url = [[[NSURL alloc] mulleInitWithEscapedURLPartsUTF8:&parts
                                   allowedURICharacterSet:nil] autorelease];
   print( url);


   /**/
   memset( &parts, 0, sizeof( parts));
   parts.escaped_query.characters = "a=1;b=3";
   parts.escaped_query.length     = -1;

   url = [[[NSURL alloc] mulleInitWithEscapedURLPartsUTF8:&parts
                                   allowedURICharacterSet:nil] autorelease];
   print( url);

   /**/
   memset( &parts, 0, sizeof( parts));
   parts.escaped_query.characters = "a=1;b=1%202%203";
   parts.escaped_query.length     = -1;

   url = [[[NSURL alloc] mulleInitWithEscapedURLPartsUTF8:&parts
                                   allowedURICharacterSet:nil] autorelease];
   print( url);
   return 0;
}


