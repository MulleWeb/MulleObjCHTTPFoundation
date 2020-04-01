//
//  MulleHTTPHeaderParser.m
//  MulleCurl
//
//  Copyright (C) 2019 Nat!, Mulle kybernetiK.
//  Copyright (c) 2019 Codeon GmbH.
//  All rights reserved.
//
//  Coded by Nat!
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
#import "MulleHTTPHeaderParser.h"

#import "import-private.h"

#include <ctype.h>


enum MulleHTTPHeaderParserState
{
   MulleHTTPHeaderParserGarbageError = -2,
   MulleHTTPHeaderParserUTF8Error = -1,
   MulleHTTPHeaderParserExpectResponse = 0,
   MulleHTTPHeaderParserExpectHeader,
   MulleHTTPHeaderParserSeenCRLF
};



@implementation MulleHTTPHeaderParser : NSObject

- (instancetype) init
{
   _data    = [NSMutableData new];
   _headers = [NSMutableDictionary new];
   _state   = MulleHTTPHeaderParserExpectResponse;

   return( self);
}


- (void) dealloc
{
   [_data release];
   [_order release];
   [_headers release];
   [_response release];

   [super dealloc];
}


- (void) reset
{
   _index = 0;
   _state = 0;

   if( _data)
      [_data setLength:0];
   else
      _data = [NSMutableData new];

   [_order removeAllObjects];
   [_headers removeAllObjects];
}


- (BOOL) expectsResponse
{
   return( _state == MulleHTTPHeaderParserExpectResponse);
}


- (void) setExpectsResponse:(BOOL) flag
{
   NSParameterAssert( _state == MulleHTTPHeaderParserExpectResponse ||
                      _state == MulleHTTPHeaderParserExpectHeader);

   _state = flag ? MulleHTTPHeaderParserExpectResponse
                 : MulleHTTPHeaderParserExpectHeader;
}


- (void) setRecordsOrder:(BOOL) flag
{
   _recordsOrder = flag;

   if( flag)
      _order = [NSMutableArray new];
   else
   {
      [_order autorelease];
      _order = nil;
   }
}


- (void) didFailToParse
{
   // throw data away, to signal error
   [_data autorelease];
   _data = nil;
}


- (BOOL) isIncomplete
{
   return( [_data length] != 0);
}


- (NSString *) response
{
   return( _response);
}

- (mulle_utf8_t *) parseResponse:(mulle_utf8_t *) s
                        sentinel:(mulle_utf8_t *) sentinel
{
   mulle_utf8_t   *value_start;
   mulle_utf8_t   *value_end;
   int            c;

   value_start = s;
   while( s < sentinel)
   {
      c = *s++;

      if( c == '\r' && *s == '\n')
      {
         value_end = s - 1;
         ++s;  // dial past \n

         if( value_end == value_start)
         {
            _state = MulleHTTPHeaderParserGarbageError;
            break;
         }

         _response = [[NSString alloc] mulleInitOrNilWithUTF8Characters:value_start
                                                                 length:value_end - value_start];
         _state    = _response ? MulleHTTPHeaderParserExpectHeader
                               : MulleHTTPHeaderParserUTF8Error;
         break;
      }
   }
   return( s);
}


- (mulle_utf8_t *) parseHeaderLines:(mulle_utf8_t *) s
                           sentinel:(mulle_utf8_t *) sentinel
{
   mulle_utf8_t   *start;
   mulle_utf8_t   *key_start;
   mulle_utf8_t   *key_end;
   mulle_utf8_t   *value_start;
   mulle_utf8_t   *value_end;
   mulle_utf8_t   *last;
   NSString       *key;
   NSString       *value;
   int            c;

   last = s;
   for(;;)
   {
      // get key which must be delimited by a ':'
      key_start = s;
      while( s < sentinel)
      {
         c = *s++;
         if( c == ':')
            break;

         if( isspace( c))
         {
            // our termination point
            if( c == '\r' && *s == '\n')
            {
               _state = MulleHTTPHeaderParserSeenCRLF;
               return( sentinel);
            }

            // if( _allowsMultiline)
            _state = MulleHTTPHeaderParserGarbageError;
            [self didFailToParse];
            return( sentinel);
         }
      }
      key_end = s - 1;

      // have ':' in c, skip whitespace which is ' ' '\t' and not 0xA0
      while( s < sentinel)
      {
         c = *s++;
         if( c != ' ' && c != '\t')
            break;
      }

      // grab string until cr/lf
      // c contains first char alreadyy
      value_start = s - 1;
      while( s < sentinel)
      {
         if( ! (c == '\r' && *s == '\n'))
         {
            c = *s++;
            continue;
         }

         value_end = s - 1;
         ++s;

         // trim trailing whitespace
         while( value_end > value_start)
         {
            c = value_end[ -1];
            if( c != ' ' && c != '\t')
               break;
            --value_end;
         }

         // construct strings

         key  = [[[NSString alloc] mulleInitOrNilWithUTF8Characters:key_start
                                                             length:key_end - key_start] autorelease];
         value = [[[NSString alloc] mulleInitOrNilWithUTF8Characters:value_start
                                                              length:value_end - value_start] autorelease];
         if( ! key || ! value)
         {
            // faulty UTF8, which we don't allow
            _state = MulleHTTPHeaderParserUTF8Error;
            [self didFailToParse];
            return( sentinel);
         }

         [_order addObject:key];
         [_headers setObject:value
                      forKey:key];

         last = s;
         break;
      }

      if( s >= sentinel)
         return( last);
   }
}


- (void) parse
{
   mulle_utf8_t   *s;
   mulle_utf8_t   *start;
   mulle_utf8_t   *key_start;
   mulle_utf8_t   *key_end;
   mulle_utf8_t   *value_start;
   mulle_utf8_t   *value_end;
   mulle_utf8_t   *last;
   mulle_utf8_t   *sentinel;
   NSString       *key;
   NSString       *value;
   int            c;

   //
   // get what is in data, parse as much as we can
   // then remove all we have parses so far
   //
   start    = [_data bytes];
   sentinel = start + [_data length];

   // this is where we start parsing
   s        = &start[ _index];

   if( _state == MulleHTTPHeaderParserExpectResponse)  // first line will be the response
      s = [self parseResponse:s
                     sentinel:sentinel];

   if( _state == MulleHTTPHeaderParserExpectHeader)  // first line will be the response
      s = [self parseHeaderLines:s
                        sentinel:sentinel];

   // remember where we were last (not a pointer, since NSData can change)
   _index = s - start;
}


// get destructively the internal state
- (NSMutableArray *) extractOrder
{
   NSMutableArray   *order;

   order = [_order autorelease];
   _order = nil;
   return( order);
}


- (NSMutableDictionary *) extractHeaders
{
   NSMutableDictionary   *headers;

   headers = [_headers autorelease];
   _headers = nil;
   return( headers);
}


- (NSArray *) order
{
   return( [[_order copy] autorelease]);
}


- (NSDictionary *) headers;
{
   return( [[_headers copy] autorelease]);
}

@end

