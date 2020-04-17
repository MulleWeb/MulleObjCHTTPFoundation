//
//  MulleObjCHTTPFoundation.h
//  MulleObjCHTTPFoundation
//
//  Created by Nat! on 04.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import "import.h"

#define MULLE_OBJC_HTTP_FOUNDATION_VERSION  ((0 << 20) | (17 << 8) | 1)

// html ? not necessarily the proper place here...
#import "NSDate+MulleHTTP.h"
#import "NSString+HTML.h"
#import "NSString+ListComponents.h"
#import "MulleHTTP.h"
#import "MulleHTTPHeaderParser.h"

#import "MulleObjCLoader+MulleObjCHTTPFoundation.h"

// export nothing with _MulleObjC
#if MULLE_OBJC_INET_FOUNDATION_VERSION < ((0 << 20) | (17 << 8) | 0)
# error "MulleObjCInetFoundation is too old"
#endif

