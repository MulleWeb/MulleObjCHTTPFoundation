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


static NSURL  *test( NSString *string)
{
   NSURL   *url;

   url = [NSURL URLWithString:string];
#ifdef __MULLE_OBJC__
   [url mulleDump];
#endif

   mulle_printf( "String: %@ -> <%@> %@\n", string, NSStringFromClass([url class]), url);
   if( url)
      print_url( url);
   mulle_printf( "\n");
   return( url);
}


int   main( int argc, const char * argv[])
{
   NSURL   *baseURL;

#ifdef __MULLE_OBJC__
   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_get_universe( __MULLE_OBJC_UNIVERSEID__);
   universe->debug.count_stackdepth = mulle_stacktrace_count_frames;
#endif
   @autoreleasepool {
      test( @"/");
      test( @"//");
      test( @"///");
      test( @"////");
      test( @"/////");

      test( @"a");

      test( @"a/");
      test( @"/a");
      test( @"/a/");

      test( @"//a");
      test( @"a//");
      test( @"//a//");

      test( @"a:");
      test( @":a");
      test( @":a:");

      test( @"a;");
      test( @";a");
      test( @";a;");

      test( @"a?");
      test( @"?a");
      test( @"?a?");


      test( @"a#");
      test( @"#a");
      test( @"#a#");

      test( @"//a/");
      test( @"/a//");
      test( @"///a");
      test( @"///a/");

      test( @"//./");
      test( @"/./../");
      test( @"/..//.");
   }
   return 0;
}


