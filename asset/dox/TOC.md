# MulleObjCHTTPFoundation Library Documentation for AI

## 1. Introduction & Purpose

**MulleObjCHTTPFoundation** provides HTTP and HTML parsing utilities for Objective-C Foundation classes. It extends NSString and NSURL with HTTP/HTML handling capabilities, enabling applications to work with web data formats.

Key features:
- HTML entity escaping/unescaping for NSString
- HTTP header parsing and utilities
- NSURL HTTP-specific methods
- HTTP date handling for NSDate
- Content-type and charset utilities

This library is typically used by web clients, servers, and any code processing HTTP data or HTML markup.

## 2. Key Concepts & Design Philosophy

### Category-Based Extension
MulleObjCHTTPFoundation extends existing Foundation classes via categories rather than creating new ones:
- **NSString** gains HTML/HTTP methods
- **NSURL** gains HTTP parsing capabilities
- **NSDate** gains HTTP date formatting

### Non-Intrusive
The library doesn't modify Foundation behavior; it only adds new methods. Existing code continues working unchanged.

### Stateless Utilities
Most methods are stateless conversions/parsings without maintaining state. No singleton managers or complex state machines.

## 3. Core API & Data Structures

### 3.1 NSString HTTP/HTML Extensions

#### HTML Entity Escaping

**Method:** `- (NSString *)mulleStringByEscapingHTML`
- **Purpose**: Escape special characters for HTML context
- **Escapes**: `&`, `<`, `>`, `"`, `'` into their HTML entity equivalents (`&amp;`, `&lt;`, `&gt;`, `&quot;`, `&#39;`)
- **Returns**: New NSString with escaped entities
- **Use**: Preparing user-provided text for safe HTML output

**Example:**
```objc
NSString *unsafe = @"<script>alert('XSS')</script>";
NSString *safe = [unsafe mulleStringByEscapingHTML];
// Returns: "&lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;"
```

#### HTML Entity Unescaping

**Method:** `- (NSString *)mulleStringByUnescapingHTML`
- **Purpose**: Unescape HTML entities back to characters
- **Unescapes**: `&amp;`, `&lt;`, `&gt;`, `&quot;`, `&#39;`, numeric entities (`&#123;`, `&#x7B;`)
- **Returns**: New NSString with unescaped text
- **Use**: Processing HTML content from web sources

**Example:**
```objc
NSString *encoded = @"&lt;p&gt;Hello&lt;/p&gt;";
NSString *decoded = [encoded mulleStringByUnescapingHTML];
// Returns: "<p>Hello</p>"
```

#### URL Component Methods

**Method:** `- (NSString *)mulleStringByAddingURLQueryParameter:(NSString *)key value:(NSString *)value`
- **Purpose**: URL-encode and append query parameter to string
- **Parameters**: key, value (both NSString)
- **Returns**: String with appended `?key=value` or `&key=value`

**Method:** `- (NSDictionary *)mulleURLQueryParametersDict`
- **Purpose**: Parse URL query string into dictionary
- **Returns**: NSDictionary with query parameters as key-value pairs
- **Use**: Extracting parameters from URLs or query strings

#### List Component Parsing

**Method:** `- (NSArray *)mulleStringByParsingListComponents`
- **Purpose**: Parse HTTP-style list headers (comma-separated with optional whitespace)
- **Example**: `"image/png, image/jpeg, image/gif"` → array with 3 NSString elements
- **Use**: Processing Accept-* headers or other comma-separated lists

### 3.2 NSURL HTTP Extensions

#### HTTP URL Parsing

**Methods:**
- `- (NSString *)mulleHTTPMethod` - Extract HTTP method if URL encodes it
- `- (NSString *)mulleHTTPURLQuery` - Get query string portion of URL
- `- (NSString *)mulleHTTPURLFragment` - Get fragment/anchor portion

#### Query Parameter Access

**Method:** `- (NSString *)mulleQueryParameterForKey:(NSString *)key`
- **Purpose**: Extract single query parameter value
- **Returns**: NSString value for key, or nil if not present

**Method:** `- (NSDictionary *)mulleQueryParametersDict`
- **Purpose**: Parse all query parameters as dictionary
- **Returns**: NSDictionary with key-value pairs

### 3.3 NSDate HTTP Formatting

#### HTTP Date Conversion

**Method:** `- (NSString *)mulleHTTPDescription`
- **Purpose**: Format NSDate as HTTP date string (RFC 1123 format)
- **Returns**: String like `"Wed, 08 Nov 2025 21:18:26 GMT"`
- **Use**: Setting Date/Last-Modified/Expires headers

**Method:** `+ (NSDate *)dateFromHTTPDateString:(NSString *)string`
- **Purpose**: Parse HTTP date string back to NSDate
- **Accepts**: RFC 1123 format dates
- **Returns**: NSDate or nil if parse fails

### 3.4 Content-Type Utilities

**Methods:**
- `- (NSString *)mulleCharsetFromContentType` - Extract charset from Content-Type header
- `- (NSString *)mulleBaseContentType` - Extract media type without parameters

---

## 4. Performance Characteristics

### Escaping/Unescaping
- **Time**: O(n) where n = string length
- **Space**: O(n) for result string (allocates new string)
- **Optimization**: Only allocates if escaping needed; returns original if no changes

### URL Parsing
- **Query parsing**: O(n) string scan
- **Parameter lookup**: O(k) where k = number of parameters (usually small)

### Caching
- No persistent caching of parsed results
- Each call reparsed; caller should cache if needed

---

## 5. AI Usage Recommendations & Patterns

### Best Practices

**HTML Escaping:**
- Always escape user input before embedding in HTML
- Use `mulleStringByEscapingHTML` for prevention of XSS attacks
- Escape both HTML content and attribute values

**URL Handling:**
- Use NSURL methods for reliable URL parsing
- Don't hand-parse query strings; use `mulleQueryParametersDict`
- Remember percent-encoding: `mulleQueryParametersDict` handles it

**HTTP Dates:**
- Use RFC 1123 format for all HTTP headers
- `mulleHTTPDescription` ensures compliance
- Test date parsing with multiple formats

### Common Pitfalls

**Incomplete HTML Escaping:**
- Don't assume entity escaping is sufficient for all contexts
- Attribute context requires different escaping than content
- Double-escaping is common mistake

**URL Parameter Encoding:**
- Query parameters must be percent-encoded
- NSURL methods handle this; don't do manual encoding
- Remember `+` vs space encoding differences

**Date Format Variations:**
- HTTP has multiple date formats (RFC 1123, RFC 850, ANSI C)
- Use library methods; don't hand-parse dates
- Always use UTC/GMT timezone for HTTP dates

### Idiomatic Patterns

**Pattern 1: Safe HTML Output**
```objc
NSString *userText = ...;  // Untrusted input
NSString *safe = [userText mulleStringByEscapingHTML];
NSString *html = [NSString stringWithFormat:@"<p>%@</p>", safe];
```

**Pattern 2: URL Query Parameter Handling**
```objc
NSURL *url = [NSURL URLWithString:@"http://example.com?key1=value1&key2=value2"];
NSDictionary *params = [url mulleQueryParametersDict];
NSString *key1Value = [url mulleQueryParameterForKey:@"key1"];
```

**Pattern 3: HTTP Header Formatting**
```objc
NSDate *now = [NSDate date];
NSString *dateHeader = [now mulleHTTPDescription];
// Use in HTTP response: @"Last-Modified: " + dateHeader
```

---

## 6. Integration Examples

### Example 1: Escaping User Input for HTML

```objc
#import <MulleFoundation/MulleFoundation.h>
#import <MulleWeb/MulleObjCHTTPFoundation.h>

int main(void) {
    @autoreleasepool {
        // User-provided data (potentially malicious)
        NSString *userComment = @"<script>alert('XSS')</script>";
        
        // Safely escape for HTML
        NSString *safe = [userComment mulleStringByEscapingHTML];
        NSLog(@"Safe: %@", safe);
        
        return 0;
    }
}
```

### Example 2: Parsing Query Parameters from URL

```objc
#import <MulleFoundation/MulleFoundation.h>
#import <MulleWeb/MulleObjCHTTPFoundation.h>

int main(void) {
    @autoreleasepool {
        NSURL *url = [NSURL URLWithString:@"http://example.com/page?search=test&sort=date"];
        
        // Get all parameters as dictionary
        NSDictionary *params = [url mulleQueryParametersDict];
        NSLog(@"Search: %@", [params objectForKey:@"search"]);
        NSLog(@"Sort: %@", [params objectForKey:@"sort"]);
        
        return 0;
    }
}
```

### Example 3: HTTP Date Handling

```objc
#import <MulleFoundation/MulleFoundation.h>
#import <MulleWeb/MulleObjCHTTPFoundation.h>

int main(void) {
    @autoreleasepool {
        NSDate *now = [NSDate date];
        
        // Format for HTTP headers
        NSString *httpDate = [now mulleHTTPDescription];
        NSLog(@"HTTP Date: %@", httpDate);
        
        // Parse HTTP date string
        NSString *dateString = @"Wed, 08 Nov 2025 21:18:26 GMT";
        NSDate *parsed = [NSDate dateFromHTTPDateString:dateString];
        NSLog(@"Parsed: %@", parsed);
        
        return 0;
    }
}
```

### Example 4: HTML Entity Unescaping

```objc
#import <MulleFoundation/MulleFoundation.h>
#import <MulleWeb/MulleObjCHTTPFoundation.h>

int main(void) {
    @autoreleasepool {
        // HTML from web source
        NSString *encoded = @"&lt;p&gt;Hello &amp; Welcome&lt;/p&gt;";
        
        // Unescape to get readable text
        NSString *decoded = [encoded mulleStringByUnescapingHTML];
        NSLog(@"Decoded: %@", decoded);
        // Output: <p>Hello & Welcome</p>
        
        return 0;
    }
}
```

---

## 7. Dependencies

Direct dependencies:
- **MulleFoundation** - NSString, NSURL, NSDate, NSArray, NSDictionary
- **MulleObjCStandardFoundation** - Core Foundation classes

MulleObjCHTTPFoundation adds HTTP/HTML methods to these classes via categories. All functionality is built on standard Foundation.
