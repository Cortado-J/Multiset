# Multiset

This is a fairly thorough implementation of a Multiset collection.
Similar to the struct Set in the standard library but can contain more than one of the same element.
This type is sometimes called a bag.

My development approach was to take a copy of Set.swift from the standard library, replace the underying data structure with a Dictionary of type (Element, Int).

This means it is a fairly thorough implementation in that it has at least the methods of Set.
It is not as efficient as it could be.
In particular I haven't checked the complexity of the methods. Many of the methods piggyback onto Dictionary methods so may be acceptable but some may not meet the usual requirements of collection complexity.


Full documentation for Multiset [https://adahus.github.io/Multiset/Structs/Multiset.html]

