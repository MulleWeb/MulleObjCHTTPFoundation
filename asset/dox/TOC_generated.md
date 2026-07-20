# MulleObjCHTTPFoundation Library Documentation for AI
<!-- Keywords: objc, http, html, url, string, date -->
## 1. Introduction & Purpose

- MulleObjCHTTPFoundation provides small Objective-C extensions and utilities for HTTP and HTML handling in mulle-objc projects.
- Main features: HTML escape/unescape for NSString, HTTP header constants and parsing helper, HTTP date formatting for NSDate, and enhanced NSURL parsing for HTTP-related URLs.
- Intended as a lightweight foundation used alongside MulleObjCInetFoundation and mulle-objc-list.

## 2. Key Concepts & Design Philosophy

- Minimal, focused categories and a tiny parser class.
- Favor small, single-purpose category methods on Foundation classes (NSString, NSDate, NSURL).
- Header parser collects headers into NSDictionary and optionally preserves order.
- API designed for C/Objective-C style resource management used in mulle-objc environments.

## 3. Core API & Data Structures

### 3.1. [MulleHTTP.h]
- Provides enum MulleHTTPRequestMethod: MulleHTTPGet, MulleHTTPPost, MulleHTTPPut, MulleHTTPDelete, MulleHTTPHead, MulleHTTPOther.
- Many #define NSString* constants for standard HTTP header keys (e.g., MulleHTTPContentTypeKey, MulleHTTPContentLengthKey) and transfer-encoding tokens (e.g., MulleHTTPTransferEncodingChunked).
- Purpose: centralize common HTTP string constants and method identifiers for use across code.

### 3.2. [MulleHTTPHeaderParser.h]
class: MulleHTTPHeaderParser : NSObject
- Purpose: simple line-oriented HTTP header parser. Splits lines into key/value pairs, trims whitespace, stores into an NSDictionary; can record order.
- Instance variables (private): NSMutableData *_data; NSMutableArray *_order; NSMutableDictionary *_headers; NSString *_response; NSInteger _state; NSUInteger _index;
- Property:
  - BOOL recordsOrder;  // if YES, preserves insertion order in -order
- Core methods:
  - - (BOOL) isIncomplete;      // true if header block incomplete
  - - (NSArray *) order;       // ordered list of header keys (or nil)
  - - (NSDictionary *) headers; // immutable header dictionary view
  - - (NSString *) response;   // stored status/response line if any
  - - (NSMutableArray *) extractOrder;       // destructive extract
  - - (NSMutableDictionary *) extractHeaders; // destructive extract of headers
  - - (void) parse;            // run parsing on collected data
- Usage pattern: feed raw header bytes into internal _data (implementation detail), call -parse, read headers or extract them.

### 3.3. [MulleObjCHTTPFoundation.h]
- Purpose: umbrella header and version macro: MULLE_OBJC_HTTP_FOUNDATION_VERSION
- Also imports exported symbols header and optional versioncheck.

### 3.4. [NSDate+MulleHTTP.h]
Category: NSDate (MulleHTTP)
- Method:
  - - (NSString *) mulleHTTPDescription; // returns RFC-style HTTP date: e.g. "Sun, 06 Nov 1994 08:49:37 GMT"
- Purpose: format dates for HTTP headers (Date, Last-Modified, Expires).

### 3.5. [NSString+HTML.h]
Category: NSString (MulleHTMLEscaping)
- Methods:
  - - (NSString *) mulleStringByEscapingHTML;         // escape minimal set of chars for unicode webpages
  - - (NSString *) mulleStringByEscapingHTMLForASCII; // escape to numeric &#xxx; for non-mapped characters
  - - (NSString *) mulleStringByUnescapingHTML;       // unescape &amp; &lt; &gt; and numeric entities
- Notes: returns autoreleased NSString; safe to use as typical NSString operations.

### 3.6. [NSString+ListComponents.h]
Category: NSString (ListComponents)
- Methods to manipulate comma-separated (or arbitrary separator) lists without duplicates:
  - - (NSRange) mulleRangeOfListComponent:(NSString *) component separator:(NSString *) separator;
  - - (NSString *) mulleStringByAddingListComponent:(NSString *) component separator:(NSString *) separator;
  - - (NSString *) mulleStringByRemovingListComponent:(NSString *) component separator:(NSString *) separator;
- Purpose: safely add/remove components in list-like strings (no duplicates).

### 3.7. NSURL modifications (implementation file: NSURL+HTTP.m)
- README and tests show NSURL is extended to expose components: scheme, user, password, host, port, path, parameterString, query, fragment, resourceSpecifier, etc.
- These extensions are used by tests in test/NSURL to validate parsing behavior.

## 4. Performance Characteristics

- NSString escaping/unescaping: O(n) in input length.
- Header parsing: linear scan O(n) over header bytes; dictionary lookups for keys average O(1).
- NSString list manipulations: O(n) due to scanning and string construction; small lists are intended.
- Memory vs speed: prioritizes clarity and correctness; not optimized for very large streaming workloads.
- Thread-safety: API is not thread-safe; callers must synchronize access to shared parser instances.

## 5. AI Usage Recommendations & Patterns

- Prefer using the provided category methods for common tasks (escaping/unescaping, date formatting, list manipulation).
- Treat header constants (MulleHTTP*Key) as canonical strings for header lookup.
- For mutable access to headers, use -extractHeaders which is destructive and returns a NSMutableDictionary that the caller owns.
- Do not rely on internal ivars; use the public methods only.
- Be aware these methods return autoreleased objects under typical mulle-objc memory model; do not free returned pointers.

## 6. Integration Examples

### Example 1: Escaping and Unescaping HTML

```objc
// Escape and unescape a string for HTML
NSString  *s;

s = @"A & B <C>";
NSLog( @"escaped: %@", [s mulleStringByEscapingHTML]);
NSLog( @"unescaped: %@", [[s mulleStringByEscapingHTML] mulleStringByUnescapingHTML]);
```

### Example 2: HTTP Date from NSDate

```objc
NSDate   *d;
NSString *dateString;

d = [NSDate date];
dateString = [d mulleHTTPDescription];
NSLog( @"HTTP-Date: %@", dateString);
```

### Example 3: Manipulating a separator list

```objc
NSString *list;

list = @"a,b";
list = [list mulleStringByAddingListComponent:@"c" separator:@","];
list = [list mulleStringByRemovingListComponent:@"b" separator:@","];
```

### Example 4: Inspecting URL components (from tests)

```objc
NSURL *url;

url = [NSURL URLWithString:@"file:///path/to/file;foo?bar#frag"];
// category methods exposed by NSURL+HTTP.m
NSLog( @"scheme: %@, path: %@, parameter: %@, query: %@, fragment: %@",
       [url scheme], [url path], [url parameterString], [url query], [url fragment]);
```

### Example 5: Using MulleHTTPHeaderParser (conceptual)

```objc
MulleHTTPHeaderParser *p;

p = [[MulleHTTPHeaderParser alloc] init];
// feed raw header block into parser (implementation detail: p->_data) or
// use methods provided by implementation to append data, then:
[p parse];
NSDictionary *headers = [p headers];
NSArray      *order   = [p order];
```

## 7. Dependencies

- MulleObjCInetFoundation  (for NSURL/inet-related helpers)
- mulle-objc-list           (runtime list utilities referenced in README)


## 8. Sources for Examples

- Public headers: src/*.h
- Tests demonstrating behavior: test/NSURL/* (URL parsing), other test directories contain stdout comparisons.
- README.md (project overview)


-- End of TOC --
