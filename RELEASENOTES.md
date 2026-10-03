## 0.20.0



feature: add date parsing and fix HTML entity unescaping

* NSDate gains `+mulleDateWithHTTPDateString:`, `+mulleDateWithISO8601String:` and `+mulleDateWithString:` for RFC 1123, RFC 822, RFC 3339 and ISO 8601 feed dates
* the combined `+mulleDateWithString:` tries both dialects, as syndication feeds use them interchangeably
* HTML numeric entities above the BMP (e.g. `&#x1F600;`) now decode to a single UTF-32 code point instead of a rejected surrogate pair
* surrogate and out-of-range code points are left untouched rather than producing invalid characters


### 0.19.2

Various small improvements

### 0.19.1

Various small improvements
