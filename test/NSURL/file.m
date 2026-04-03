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
   mulle_printf( "RelativePath      : %@\n", [url relativePath]);
   mulle_printf( "RelativeString    : %@\n", [url relativeString]);
   mulle_printf( "Base              : %@\n", [[url baseURL] description]);
   mulle_printf( "Absolute          : %@\n", [url absoluteString]);
}


static NSURL  *test( NSURL *baseURL, NSString *string)
{
   NSURL   *url;

   url = [NSURL URLWithString:string
                relativeToURL:baseURL];
#ifdef __MULLE_OBJC__
   [url mulleDump];
#endif

   mulle_printf( "String: %@ baseURL: %@ -> <%@> %@\n", string, [baseURL description], NSStringFromClass([url class]), [url description]);
   if( url)
      print_url( url);
   mulle_printf( "\n");
   return( url);
}


int   main(int argc, const char * argv[])
{
   NSURL   *baseURL;

#ifdef __MULLE_OBJC__
   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_get_universe( __MULLE_OBJC_UNIVERSEID__);
   universe->debug.count_stackdepth = mulle_stacktrace_count_frames;
#endif
   @autoreleasepool {
       // insert code here...
      test( nil, @"foo.txt");
      test( nil, @";param");
      test( nil, @"file:///path/to/file;foo?bar");
      test( nil, @"file:foo.txt");
      test( nil, @"file:foo space.txt");  // invalid
      test( nil, @"file:///foo%20space.txt");
      test( nil, @"file://foo.com/foo%20space.txt");

      baseURL = [NSURL URLWithString:@"file:///basepath/basecomponent;whatevs#20"];

      test( baseURL, @"foo.txt#40");
      test( baseURL, @"///path/to/file;foo?bar");
      test( baseURL, @"file:foo.txt");
      test( baseURL, @"file:///foo.txt");
      test( baseURL, @"foo space.txt");  // invalid
      test( baseURL, @"/foo%20space.txt");
      test( baseURL, @";foo%20space.txt");
   }
   return 0;
}


