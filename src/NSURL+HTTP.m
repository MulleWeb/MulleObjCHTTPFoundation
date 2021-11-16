//
//  NSURL+HTTP.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
//  Copyright (c) 2020 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "import-private.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies
#include <string.h>



@implementation NSURL( HTTP)

static struct MulleURLSchemeHandler   MulleURLHTTPSchemeHandler =
{
   @selector( mulleInitHTTPURLWithArguments:),
   @selector( mulleGenericURLDescription),
   @selector( mulleGenericResourceSpecifierDescription)
};


MULLE_OBJC_DEPENDS_ON_LIBRARY( MulleObjCValueFoundation);

+ (void) load
{
   @autoreleasepool
   {
      [self mulleRegisterHandler:&MulleURLHTTPSchemeHandler
                       forScheme:@"http"];
      [self mulleRegisterHandler:&MulleURLHTTPSchemeHandler
                       forScheme:@"https"];
   }
}


- (instancetype) mulleInitHTTPURLWithHTTPParserURL:(struct http_parser_url *)  url
                                    UTF8Characters:(char *) utf
                                            length:(NSUInteger) length
{
   char                             *c_substring;
   size_t                            c_substring_len;
   unsigned int                      i;
   struct MulleEscapedURLPartsUTF8   parts;

   memset( &parts, 0, sizeof( parts));

   for( i = UF_SCHEMA; i < UF_MAX; i++)
   {
      if( ! (url->field_set & (1 << i)))
         continue;

      if( i == UF_PORT)
      {
         parts.port = url->port;
         continue;
      }

      c_substring      = &utf[ url->field_data[ i].off];
      c_substring_len  = url->field_data[ i].len;

      switch( i)
      {
      case UF_SCHEMA   : parts.scheme.characters = c_substring;
                         parts.scheme.length     = c_substring_len;
                         break;

      // need to parse this into user/password/host part  ?
      case UF_HOST     : parts.escaped_host.characters = c_substring;
                         parts.escaped_host.length     = c_substring_len;
                         break;

      case UF_USERINFO : parts.escaped_password.characters = (char *)
                            mulle_utf8_strnchr( (mulle_utf8_t *) c_substring, c_substring_len, ':');
                         if( parts.escaped_password.characters)
                         {
                            ++parts.escaped_password.characters;
                            parts.escaped_password.length  = c_substring_len - (parts.escaped_password.characters - c_substring);
                            c_substring_len               -= parts.escaped_password.length + 1;
                         }
                         parts.escaped_user.characters = c_substring;
                         parts.escaped_user.length     = c_substring_len;
                         break;

      // need to parse this into path/parameterString part
      case UF_PATH     : parts.escaped_parameter.characters = (char *)
                            mulle_utf8_strnchr( (mulle_utf8_t *) c_substring, c_substring_len, ';');
                         if( parts.escaped_parameter.characters)
                         {
                            ++parts.escaped_parameter.characters;
                            parts.escaped_parameter.length  = c_substring_len - (parts.escaped_parameter.characters - c_substring);
                            c_substring_len -= parts.escaped_parameter.length + 1;
                         }
                         parts.escaped_path.characters = c_substring;
                         parts.escaped_path.length     = c_substring_len;

                         // stupid parser mishandles query apparently
                         break;

      case UF_QUERY    : parts.escaped_query.characters = c_substring;
                         parts.escaped_query.length     = c_substring_len;
                         break;

      case UF_FRAGMENT : parts.escaped_fragment.characters = c_substring;
                         parts.escaped_fragment.length     = c_substring_len;
                         break;
      }
   }

   // assume the http URL parser did its job (?)
   parts.validated = YES;

   return( [self mulleInitWithEscapedURLPartsUTF8:&parts
                           allowedURICharacterSet:nil]);
}


//
// It would be nice to assume http parser is doing its job properly,
// so we don't need to secondguess or check
// (but it doesn't...)
//
- (instancetype) mulleInitHTTPURLWithArguments:(struct MulleURLSchemeInitArguments *) args
{
   struct http_parser_url   url;

   http_parser_url_init( &url);

   if( http_parser_parse_url( (char *) args->uri.characters, args->uri.length, 2, &url))
   {
#ifdef DEBUG
      fprintf( stderr, "http URL parse can't parse \"%.*s\"\n", (int) args->uri.length, args->uri.characters);
#endif
      [self release];
      return( nil);
   }

   return( [self mulleInitHTTPURLWithHTTPParserURL:&url
                                    UTF8Characters:args->uri.characters
                                            length:args->uri.length]);
}

@end


