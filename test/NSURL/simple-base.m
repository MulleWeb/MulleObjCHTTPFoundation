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


static NSURL  *test( NSURL *baseURL, NSString *string)
{
   NSURL   *url;
   char    *s;

   url = [NSURL URLWithString:string
                relativeToURL:baseURL];
#ifdef __MULLE_OBJC__
   [url mulleDump];
#endif

   printf( "String: %s baseURL: %s -> <%s> %s\n", (s = [string UTF8String]) ? s : "*nil*",
                                                  (s = [baseURL UTF8String]) ? s : "*nil*",
                                                  (s = [NSStringFromClass([ url class]) UTF8String]) ? s : "*nil*",
                                                  (s = [url UTF8String]) ? s : "*nil*");
   if( url)
      print_url( url);
   printf( "\n");
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
      baseURL = [NSURL URLWithString:@"a"];
      test( baseURL, @"b");
   }
   return 0;
}


