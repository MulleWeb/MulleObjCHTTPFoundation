//
//  MulleObjCLoader+InetFoundation.m
//  MulleObjCHTTPFoundation
//
//  Created by Nat! on 11.05.17.
//
//

#import "MulleObjCLoader+MulleObjCHTTPFoundation.h"


@implementation MulleObjCLoader( MulleObjCHTTPFoundation)

+ (struct _mulle_objc_dependency *) dependencies
{

   static struct _mulle_objc_dependency   dependencies[] =
   {

#include "objc-loader.inc"

      { MULLE_OBJC_NO_CLASSID, MULLE_OBJC_NO_CATEGORYID }
   };

   return( dependencies);
}

@end
