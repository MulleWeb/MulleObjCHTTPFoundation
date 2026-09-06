# MulleObjCHTTPFoundation Library Documentation for AI
<!-- Keywords: HTTP, HTML, parsing, escaping, NSString, NSDate, NSURL -->

## 1. Introduction & Purpose

**MulleObjCHTTPFoundation** is a mulle-objc Objective-C library that adds
HTTP and HTML utility capabilities to existing Foundation classes via
categories and a small dedicated class.

It provides:
- HTML entity escaping and unescaping for `NSString`
- HTTP header-name constants and an HTTP request-method enum
- A streaming HTTP header parser for responses/headers
- HTTP date formatting (RFC 1123 / RFC 2616) for `NSDate`
- List-string manipulation (add/remove/find components) for `NSString`
- HTTP (and HTTPS) URL parsing support for `NSURL`

It is a companion to `MulleObjCInetFoundation`, which supplies the underlying
`NSURL` machinery. This library makes `NSURL` understand `http:`/`https:`
URLs and adds the web-oriented string/date helpers on top. It is typically
used by web clients and servers built on mulle-objc.

## 2. Key Concepts & Design Philosophy

- **Category-based extension:** The library does not subclass anything.
  It extends `NSString`, `NSDate` and `NSURL` by categories and registers
  itself with the ObjC runtime for the reflection/linking dependency system
  via the `MulleObjCDeps( MulleObjCHTTPFoundation)` category.
- **Non-intrusive:** Adding the library to a project does not change
  behaviour of existing code; it only adds new selectors.
- **Stateless conversions:** The `NSString` and `NSDate` helpers are pure
  conversion functions. `MulleHTTPHeaderParser` is the only stateful
  component, and it exposes this state explicitly.
- **URL handling is delegated:** `NSURL` HTTP support is implemented as a URL
  scheme handler registered in `+load`, so it composes with the generic
  `MulleURLSchemeHandler` architecture provided by the Foundation.

## 3. Core API & Data Structures

All signatures below are verbatim from the public headers.

### 3.1. `MulleHTTP.h`

Constants and an enum for HTTP headers and request methods. No structs.

#### `enum MulleHTTPRequestMethod`

- **Purpose:** Names the most common HTTP request methods.
- **Values** (verbatim):
  ```
  MulleHTTPOther = -1,
  MulleHTTPGet   = 0,
  MulleHTTPPost  = 1,
  MulleHTTPPut,
  MulleHTTPDelete,
  MulleHTTPHead
  ```
- **Note:** The comment in the header notes that WEBDAV and other methods
  are not included yet.

#### Header name macros

`#define` constants for standard RFC 2616 header field names, e.g.
`MulleHTTPAcceptKey` (`@"Accept"`), `MulleHTTPContentTypeKey`
(`@"Content-Type"`), `MulleHTTPContentLengthKey`, `MulleHTTPHostKey`,
`MulleHTTPUserAgentKey`, `MulleHTTPDateKey`, `MulleHTTPLastModifiedKey`,
`MulleHTTPAuthorizationKey`, `MulleHTTPConnectionKey`,
`MulleHTTPTransferEncodingKey`, and many more (one per standard header).

#### Transfer encoding macros

`#define` constants for `Transfer-Encoding` values:
`MulleHTTPTransferEncodingChunked` (`@"chunked"`),
`MulleHTTPTransferEncodingCompressed` (`@"compress"`),
`MulleHTTPTransferEncodingDeflate` (`@"deflate"`),
`MulleHTTPTransferEncodingGzip` (`@"gzip"`),
`MulleHTTPTransferEncodingIdentity` (`@"identity"`).

### 3.2. `MulleHTTPHeaderParser.h`

#### `@interface MulleHTTPHeaderParser : NSObject`

- **Purpose:** A simple, streaming parser that splits a response line and
  header lines into key/value pairs stored in an `NSDictionary`. Leading and
  trailing whitespace on header values is removed. It is not yet a complete
  RFC parser (multiline headers are not supported).
- **Key Fields:** The ivars are private: `_data` (`NSMutableData`),
  `_order` (`NSMutableArray`), `_headers` (`NSMutableDictionary`),
  `_response` (`NSString`), `_state` (`NSInteger`), `_index` (`NSUInteger`).
- **Properties:**
  - `@property BOOL recordsOrder;` — When `YES`, the order in which header
    keys appear is recorded and available via `order`/`extractOrder`.
- **Querying Methods (all declared in the header):**
  - `- (BOOL) isIncomplete;` — `YES` if there is unparsed data remaining.
  - `- (NSArray *) order;` — Non-destructive copy of the recorded key order
    (only valid if `recordsOrder` was set).
  - `- (NSDictionary *) headers;` — Non-destructive copy of the parsed
    header dictionary.
  - `- (NSString *) response;` — The parsed first (response) line.
- **Destructive Extraction:**
  - `- (NSMutableArray *) extractOrder;` — Returns and takes ownership of the
    internal order array (destructive).
  - `- (NSMutableDictionary *) extractHeaders;` — Returns and takes ownership
    of the internal headers dictionary (destructive).
- **Parsing:**
  - `- (void) parse;` — Parse as much of the accumulated data as possible
    and remember the parse position for the next call.
- **Note:** `- (void) reset`, `- (BOOL) expectsResponse`,
  `- (void) setExpectsResponse:`, `- (instancetype) init` and `- (void)
  dealloc` exist in the implementation but are **not** declared in the public
  header.

### 3.3. `NSDate+MulleHTTP.h`

#### `@interface NSDate( MulleHTTP)`

- **Purpose:** Format an `NSDate` as an HTTP `Date:` header string.
- **Method:**
  - `- (NSString *) mulleHTTPDescription;`
- **Behaviour:** Produces the RFC 1123 style used by HTTP
  (format `"%a, %d %b %Y %H:%M:%S GMT"`, e.g.
  `Sun, 06 Nov 1994 08:49:37 GMT`). Uses a cached `NSDateFormatter` with
  `en_US` locale and the GMT timezone. There is no reverse (string-to-date)
  parser in this library.

### 3.4. `NSString+HTML.h`

#### `@interface NSString( MulleHTMLEscaping)`

- **Purpose:** HTML escaping/unescaping of strings.
- **Methods:**
  - `- (NSString *) mulleStringByEscapingHTML;`
    Escape characters that need escaping for HTML using the Unicode
    HTML escape map (covers `"`, `&`, `'`, `<`, `>` plus selected Latin and
    special/entity characters). Non-ASCII characters without a named mapping
    are left as-is.
  - `- (NSString *) mulleStringByEscapingHTMLForASCII;`
    Like the above but uses the full ASCII escape map and encodes all
    characters above `127` as `&#xxx;` decimal entities.
  - `- (NSString *) mulleStringByUnescapingHTML;`
    Convert named entities (`&amp;`, `&lt;`, ...), decimal (`&#123;`) and hex
    (`&#x7B;`) numeric entities back to characters. Optimized: returns `self`
    unchanged if the string contains no `&`.
- **Semantics:** These are the Google GTM `NSString+HTML` algorithms, renamed
  with the `mulle` prefix and adapted for the mulle Foundation. Note the
  header comment: these escaping calls are "only safe once" (i.e. do not
  re-escape an already-escaped string).

### 3.5. `NSString+ListComponents.h`

#### `@interface NSString( ListComponents)`

- **Purpose:** Manipulate a delimited list of components, e.g. `@"a,b,c"`.
  A list may not contain duplicate components, and the separator must be
  non-empty and non-nil.
- **Methods (verbatim):**
  - `- (NSRange) mulleRangeOfListComponent:(NSString *) component
                                separator:(NSString *) separator;`
    Return the range of `component` in the receiver if it exists as a list
    member, otherwise `NSMakeRange(NSNotFound, 0)`.
  - `- (NSString *) mulleStringByAddingListComponent:(NSString *) component
                                          separator:(NSString *) separator;`
    Return the receiver with `component` appended (result may be unchanged
    if the component already exists; returns `component` alone if the
    receiver is empty).
  - `- (NSString *) mulleStringByRemovingListComponent:(NSString *) component
                                            separator:(NSString *) separator;`
    Return the receiver with `component` (and its separator) removed;
    `@""` if it was the only component.

### 3.6. `MulleObjCDeps+MulleObjCHTTPFoundation.h`

#### `@interface MulleObjCDeps( MulleObjCHTTPFoundation)`

- **Purpose:** Registers the class/category dependencies of this library for
  the mulle-objc loader/reflection system (empty category interface; the
  dependencies are emitted into `objc-deps.inc`).

### 3.7. `NSURL` HTTP support (implementation only, no public header)

The file `NSURL+HTTP.m` provides `@implementation NSURL( HTTP)`:

- In `+ (void) load` it registers a `struct MulleURLSchemeHandler` for the
  schemes `@"http"` and `@"https"` via
  `mulleRegisterHandler:forScheme:`. This is what makes
  `[NSURL URLWithString:@"http://..."]` and `relativeToURL:` correctly parse
  HTTP/HTTPS URLs (scheme, user/password, host, port, path, parameter,
  query, fragment).
- It implements `mulleInitHTTPURLWithArguments:` and
  `mulleInitHTTPURLWithHTTPParserURL:UTF8Characters:length:` which are the
  handler entry points, and delegates to
  `mulleInitWithEscapedURLPartsUTF8:allowedURICharacterSet:` from
  `MulleObjCInetFoundation`.

## 4. Performance Characteristics

- **HTML escaping/unescaping:** Linear in string length. Escaping uses a
  binary search (`bsearch`) over a sorted entity table. `unescapingHTML`
  short-circuits when no `&` is present (returns `self`). Both allocate new
  strings.
- **List components:** Each operation performs a linear scan
  (`rangeOfString:options:NSLiteralSearch`). Adding is O(n); removing is
  O(n) with a single `stringByReplacingCharactersInRange:`. No duplicates
  are allowed, so membership is checked first.
- **HTTP date formatting:** O(1) amortized; the `NSDateFormatter` is created
  once and cached in a static atomic pointer.
- **Header parsing:** One pass over the buffered data, and the parser
  remembers its position (`_index`) so incremental `parse` calls do not
  rescan already-consumed bytes.
- **Thread-safety:** The date formatter cache uses atomic pointer reads and
  a compare-and-swap, so it is safe across threads. `NSString`/`NSURL`
  helpers are stateless. `MulleHTTPHeaderParser` is not thread-safe; guard it
  externally.

## 5. AI Usage Recommendations & Patterns

- **Best Practices**
  - Use the header-name `#define` constants (`MulleHTTPContentTypeKey`,
    etc.) instead of literal strings to avoid typos.
  - Escape user-provided text before inserting it into HTML with
    `mulleStringByEscapingHTML`. Use `mulleStringByEscapingHTMLForASCII` only
    when the target page is ASCII-only.
  - Do not escape the same string twice; per the source documentation these
    calls are only safe once.
  - For HTTP dates, use `mulleHTTPDescription` for header values; it already
    produces the RFC 1123 `GMT` form required by RFC 2616.
  - Prefer `mulleStringByAddingListComponent:`/`mulleStringByRemovingListComponent:`
    for maintaining Accept-* style header values; they handle the
    duplicates and separators for you.
  - Use the `extractOrder`/`extractHeaders` destructors when you want to
    avoid the copy performed by `order`/`headers`.
- **Common Pitfalls**
  - Do not assume `NSDate` can be parsed back from an HTTP date string in
    this library; there is no `dateFromHTTPDateString:` — only the
    output formatter `mulleHTTPDescription`.
  - `mulleRangeOfListComponent:separator:` requires a non-empty separator;
    with an empty separator it returns `NSMakeRange(NSNotFound, 0)`.
  - List members are compared literally
    (`NSLiteralSearch`), so do not rely on case-insensitive matching.
  - `recordsOrder` must be set before parsing to get order information, and
    `order` returns a copy.
  - The header parser does not support multiline/folded headers yet.
- **Idiomatic Membership:** Add the library with `mulle-sde add
  github:MulleWeb/MulleObjCHTTPFoundation` and import the umbrella header.

## 6. Integration Examples

Coding style: 3-space indent, Allman braces, aligned declarations, one
variable per line, no dot-syntax, no `alloc`/`init`/`retain`/`release`
outside of `-init`/`-dealloc`.

### Example 1: HTML Escaping and Unescaping

```objc
#import <Foundation/Foundation.h>
#import <MulleObjCHTTPFoundation/MulleObjCHTTPFoundation.h>

int   main( void)
{
   @autoreleasepool
   {
      NSString   *input;
      NSString   *escaped;
      NSString   *unescaped;

      input    = @"<b>Tom & Jerry</b>";
      escaped  = [input mulleStringByEscapingHTML];
      printf( "%s\n", [escaped UTF8String]);
      // <b&gt;Tom &amp; Jerry&lt;/b&gt;   (the map escapes <, >, &, ", ')

      unescaped = [escaped mulleStringByUnescapingHTML];
      printf( "%s\n", [unescaped UTF8String]);
      // <b>Tom & Jerry</b>
   }
   return( 0);
}
```

### Example 2: HTTP Date Formatting

```objc
#import <Foundation/Foundation.h>
#import <MulleObjCHTTPFoundation/MulleObjCHTTPFoundation.h>

int   main( void)
{
   @autoreleasepool
   {
      NSDate      *now;
      NSString    *date;

      now  = [NSDate date];
      date = [now mulleHTTPDescription];
      printf( "Date: %s\n", [date UTF8String]);
      // Date: Sun, 06 Nov 1994 08:49:37 GMT
   }
   return( 0);
}
```

### Example 3: List Component Manipulation

```objc
#import <Foundation/Foundation.h>
#import <MulleObjCHTTPFoundation/MulleObjCHTTPFoundation.h>

int   main( void)
{
   @autoreleasepool
   {
      NSString   *list;
      NSRange    range;

      list = @"image/png, image/jpeg, image/gif";
      list = [list mulleStringByAddingListComponent:@"image/webp"
                                          separator:@", "];
      printf( "%s\n", [list UTF8String]);
      // image/png, image/jpeg, image/gif, image/webp

      range = [list mulleRangeOfListComponent:@"image/png"
                                    separator:@", "];
      printf( "found\n");   // range.length != 0

      list = [list mulleStringByRemovingListComponent:@"image/jpeg"
                                            separator:@", "];
      printf( "%s\n", [list UTF8String]);
   }
   return( 0);
}
```

### Example 4: Parsing HTTP Headers with MulleHTTPHeaderParser

```objc
#import <Foundation/Foundation.h>
#import <MulleObjCHTTPFoundation/MulleObjCHTTPFoundation.h>

int   main( void)
{
   @autoreleasepool
   {
      MulleHTTPHeaderParser   *parser;
      NSDictionary            *headers;

      parser  = [[MulleHTTPHeaderParser new] autorelease];
      [parser setExpectsResponse:NO];

      // Feed bytes and call [parser parse] repeatedly; the parser
      // remembers its position between calls.

      headers = [parser headers];
      NSLog( @"%@", headers);

      headers = [parser extractHeaders];   // destructive, no copy
   }
   return( 0);
}
```

## 7. Dependencies

Direct `mulle-sde` dependencies (from `.mulle/etc/sourcetree/config`):

- `MulleObjCInetFoundation` — provides `NSURL`, the URL scheme handler
  architecture (`mulleInitWithEscapedURLPartsUTF8:allowedURICharacterSet:`,
  `mulleRegisterHandler:forScheme:`) and related Foundation classes used by
  this library.
- `mulle-objc-list` — tool dependency used at build/reflection time.

## 8. Shortcut

The previous `index.md` was committed on 2026-09-05. Only a CI environment
file has changed in the working tree since; the public API is unchanged.
The document was rewritten because the previous version documented
non-existent APIs and omitted real public headers.