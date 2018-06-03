//
//  MulleObjCLoader+InetFoundation.m
//  MulleObjCInetFoundation
//
//  Created by Nat! on 11.05.17.
//
//

#import "MulleObjCLoader+MulleObjCInetFoundation.h"


@implementation MulleObjCLoader( MulleObjCInetFoundation)

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
