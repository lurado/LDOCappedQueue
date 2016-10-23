# LDOCappedQueue

A queue that only holds a maximum number of items and discards the least recently added ones, if new ones are added and the capacity is reached.  

It's a relatively thin wrapper around `NSMutableArray`, which is implemented as a circular buffer [according to this blog post by Bartosz Ciechanowski](http://ciechanowski.me/blog/2014/03/05/exposing-nsmutablearray/)). Therefore enqueueing and dequeueing are O(1) operations.

The implementation is not thread safe.

## Installation

LDOCappedQueue is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LDOCappedQueue"
```

## Author

Julian Raschke und Sebastian Ludwig GbR, https://www.lurado.com

## License

LDOCappedQueue is available under the MIT license. See the LICENSE file for more info.
