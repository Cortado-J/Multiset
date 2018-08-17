# Multiset

This is a fairly thorough implementation of a Multiset collection.
Similar to the struct Set in the standard library but can contain more than one of the same element.
This type is sometimes called a bag.
fSwift Collections Library

Buckets is a complete, tested and documented collections library for swift.

## Requirements
Swift 4.2

## Documentation
Full documentation for Multiset at: [https://adahus.github.io/Multiset/Structs/Multiset.html]

## Installation
Installaion is merely a matter of adding the file Multiset.swift to your project.
I haven't shown any further installation notes. 

## Testing
A test file is included using Xcode's XCT test routines which tests all methods.

## License
Code is under the MIT License.

## Efficiency and complexity
It is not as efficient as it could be.
In particular I haven't checked the complexity of the methods.
Having said that, many of the methods piggyback on methods from Dictionary.swift so in many cases performance will probably be fine and this may be acceptable but some may not meet the usual requirements of collection complexity.

## Development approach
My development approach was to take a copy of Set.swift from the standard library, replace the underying data structure with a Dictionary of type (Element, Int) and then adjusting existing methods or adding new ones as necessary.

This means it is a fairly thorough implementation in that it has at least the methods of Set.

I also looked at some other implementations of Multiset.
In particular, thankyou Rob Rix for approach to Multiset index.


