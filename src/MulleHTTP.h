//
//  MulleHTTP.m
//  MulleCivetWeb
//
//  Created by Nat! on 13.02.20.
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK
//  All rights reserved.
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

enum MulleHTTPRequestMethod
{
   MulleHTTPOther = -1,

   MulleHTTPGet   = 0,
   MulleHTTPPost  = 1,
   MulleHTTPPut,
   MulleHTTPDelete,
   MulleHTTPHead

   // there are quite a few more defined in WEBDAV and others
   // (see MulleObjCInetFoundation/http_parser.h)
   // should move these there
};


// https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
// because of TPS strings, and most keys not being used actually, I think #defines are better

#define MulleHTTPAcceptKey              @"Accept"
#define MulleHTTPAcceptCharsetKey       @"Accept-Charset"
#define MulleHTTPAcceptEncodingKey      @"Accept-Encoding"
#define MulleHTTPAcceptLanguageKey      @"Accept-Language"
#define MulleHTTPAcceptRangesKey        @"Accept-Ranges"
#define MulleHTTPAgeKey                 @"Age"
#define MulleHTTPAllowKey               @"Allow"
#define MulleHTTPAuthorizationKey       @"Authorization"
#define MulleHTTPCacheControlKey        @"Cache-Control"
#define MulleHTTPConnectionKey          @"Connection"
#define MulleHTTPContentEncodingKey     @"Content-Encoding"
#define MulleHTTPContentLanguageKey     @"Content-Language"
#define MulleHTTPContentLengthKey       @"Content-Length"
#define MulleHTTPContentLocationKey     @"Content-Location"
#define MulleHTTPContentMD5Key          @"Content-MD5"
#define MulleHTTPContentRangeKey        @"Content-Range"
#define MulleHTTPContentTypeKey         @"Content-Type"
#define MulleHTTPDateKey                @"Date"
#define MulleHTTPETagKey                @"ETag"
#define MulleHTTPExpectKey              @"Expect"
#define MulleHTTPExpiresKey             @"Expires"
#define MulleHTTPFromKey                @"From"
#define MulleHTTPHostKey                @"Host"
#define MulleHTTPIfMatchKey             @"If-Match"
#define MulleHTTPIfModifiedSinceKey     @"If-Modified-Since"
#define MulleHTTPIfNoneMatchSinceKey    @"If-None-Match"
#define MulleHTTPIfRangeSinceKey        @"If-Range"
#define MulleHTTPIfUnmodifiedSinceKey   @"If-Unmodified-Since"
#define MulleHTTPLastModifiedKey        @"Last-Modified"
#define MulleHTTPLocationKey            @"Location"
#define MulleHTTPMaxForwardsKey         @"Max-Forwards"
#define MulleHTTPPragmaKey              @"Pragma"
#define MulleHTTPProxyAuthenticateKey   @"Proxy-Authenticate"
#define MulleHTTPProxyAuthorizationKey  @"Proxy-Authorization"
#define MulleHTTPRangeKey               @"Range"
#define MulleHTTPRefererKey             @"Referer"
#define MulleHTTPRetryAfterKey          @"Retry-After"
#define MulleHTTPServerKey              @"Server"
#define MulleHTTPTEKey                  @"TE"
#define MulleHTTPTrailerKey             @"Trailer"
#define MulleHTTPTransferEncodingKey    @"Transfer-Encoding"
#define MulleHTTPUpgradeKey             @"Upgrade"
#define MulleHTTPUserAgentKey           @"User-Agent"
#define MulleHTTPVaryKey                @"Vary"
#define MulleHTTPViaKey                 @"Via"
#define MulleHTTPWarningKey             @"Warning"
#define MulleHTTPWWWAuthenticateKey     @"WWW-Authenticate"


#define MulleHTTPTransferEncodingChunked      @"chunked"
#define MulleHTTPTransferEncodingCompressed   @"compress"
#define MulleHTTPTransferEncodingDeflate      @"deflate"
#define MulleHTTPTransferEncodingGzip         @"gzip"
#define MulleHTTPTransferEncodingIdentity     @"identity"
