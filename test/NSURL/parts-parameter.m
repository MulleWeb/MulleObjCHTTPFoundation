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

@interface NSObject( ForwardDeclaration)

- (void) mulleDump;

@end


static void   print_url( NSURL  *url)
{
   mulle_printf( "Scheme            : %@\n", [url scheme]);
   mulle_printf( "User              : %@\n", [url user]);
   mulle_printf( "Password          : %@\n", [url password]);
   mulle_printf( "Host              : %@\n", [url host]);
   mulle_printf( "Port              : %td\n", [url port]);
   mulle_printf( "Path              : %@\n", [url path]);
   mulle_printf( "Parameter         : %@\n", [url parameterString]);
   mulle_printf( "Query             : %@\n", [url query]);
   mulle_printf( "Fragment          : %@\n", [url fragment]);
   mulle_printf( "ResourceSpecifier : %@\n", [url resourceSpecifier]);
}


static void   print( NSURL *url)
{
#ifdef __MULLE_OBJC__
   [url mulleDump];
#endif

   if( url)
      print_url( url);
   else
      mulle_printf( "nil");
   mulle_printf( "\n");
}


int   main( int argc, const char * argv[])
{
   NSURL                             *url;
   struct MulleEscapedURLPartsUTF8   parts;

   /**/
   memset( &parts, 0, sizeof( parts));
   parts.escaped_parameter.characters = "a=1";
   parts.escaped_parameter.length     = -1;

   url = [[[NSURL alloc] mulleInitWithEscapedURLPartsUTF8:&parts
                                   allowedURICharacterSet:nil] autorelease];
   print( url);


   /**/
   memset( &parts, 0, sizeof( parts));
   parts.escaped_parameter.characters = "a=1;b=3";
   parts.escaped_parameter.length     = -1;

   url = [[[NSURL alloc] mulleInitWithEscapedURLPartsUTF8:&parts
                                   allowedURICharacterSet:nil] autorelease];
   print( url);

   /**/
   memset( &parts, 0, sizeof( parts));
   parts.escaped_parameter.characters = "a=1;b=1%202%203";
   parts.escaped_parameter.length     = -1;

   url = [[[NSURL alloc] mulleInitWithEscapedURLPartsUTF8:&parts
                                   allowedURICharacterSet:nil] autorelease];
   print( url);
   return 0;
}


