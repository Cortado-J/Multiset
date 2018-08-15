//
//  Multiset.swift
//  Multiset
//
//  Created by Justin Roughley on 26/07/2018.
//
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

/// A "Multiset" is an unordered collection of hashable elements.
///
/// The Multiset collection has similarities with Set and Dictionary,
/// two collections in the swift standard library
/// The key difference from a set is that a Multiset can have repeated Elements.
/// It does this by storing a dictionary (called 'content') of type [Element, Int].
///
/// Initialisation
/// --------------
///
/// A Multiset can be created by an array literal of type [Element] as in:
///
///     let ingredients: Multiset = ["coffee", "milk", "sugar", "sugar"]
///
/// or using variadic initialiser for two or more elements:
///
///     let fruit = Multiset("Apple", "Orange", "Apple")   // ["Apple":2, "Orange":1]
///     // But can't do Multiset("Apple") because "Apple" is seen as an array of Characters!)
///
/// or using a dictionary literal of type [Element:Int] as in:
///
///     let truth: Multiset = [true:3, false:2]
///
/// or from a sequence (which may include repeated elements):
///
///     let numbers: Multiset = [1000, 2000, 3000, 1000]  // [1000:2, 2000:1, 3000:1]
///
/// for an empty multiset you must specify the Generic Parameter:
///
///     let words:  Multiset<String> = []
///     let numbers = Multiset<Int>()
///
/// Inserting and Removing Elements
/// ----------------------------
///
/// To insert elements:
///
///     var multi = Multiset<String>()    // []
///     multi.insert("Small")             // ["Small":1]
///     multi.insert("Small")             // ["Small":2]
///     multi.insert("Big", count: 6)     // ["Small":2, "Big"]
///
/// To remove elements:
///
///     var multi: Multiset = [1000:1, 2000:1, 3000:10]
///     multi.remove(1000)                // [2000:1, 3000:10]
///     multi.remove(3000, count: 3)      // [2000:1, 3000:7]
///     multi.remove(3000, count: 3)      // [2000:1, 3000:7]
///
/// If there aren't enough elements then remove will not remove any of
/// them and this is indicated by the function returning false:
///
///     var multi: Multiset = [2000:1, 3000:7]
///     let resulta = multi.remove(7777)      // resulta is false
///     let resultb = multi.remove(3000, count: 10)  // resultb is false
///
/// Or to remove as many as are available then use the isPossible override:
///
///     var multi: Multiset = [2000:1, 3000:7]
///     let resulta = multi.remove(ifPossible: 3000, count: 100)  // resulta is 7 and multi is [2000:1]
///     let resultb = multi.remove(ifPossible: 3000:100)  // resultb is false
///
/// To remove all of certain elements:
///
///     var multi: Multiset = ["AAA":3, "BBB":4, "CCC":4]
///     multi.removeAll("AAA")   // ["BBB":4, "CCC":4]
///     multi.removeAll()        // []
///
/// To just set the number of a certain type of element:
///
///     var truth: Multiset = [true:3, false:4]
///     truth.update(count: 5, for: true)    // [true:5, false:4]
///     truth.update(count: 0, for: false)   // [true:5]
///     truth.update(count: 7, for: false)   // [true:5, false:7]
///
/// Iterating
/// ---------
///
/// There are 3 ways to iterate through a multiset:
///
/// 1) To iterate through all the elements of a multiset:
///
///     for size in Multiset(["Big":3, "Small":2]) {
///         print(size)
///     }
///     Note that elements of the same type will come grouped together
///     but the order of different groups is not defined so:
///     either prints "Big"   "Big"   "Big" "Small" "Small"
///     or     prints "Small" "Small" "Big" "Big"   "Big"
///
/// 2) To iterate through groups of different types of elements use `grouped()`
///
///     for (element, count) in Multiset(["Big":3, "Small":2]).grouped() {
///         print(element, count)
///     }
///     Note that the order of the elements is not defined so:
///     either prints ("Big",3)    and then  ("Small":2)
///     or     prints ("Small":2)  and then  ("Big",3)
///
/// 3) To iterate through just the distinct elements of a multiset use `distinct()`:
///
///     for size in Multiset(["Big":3, "Small":2]).distinct() {
///         print(size)
///     }
///     Note that the order of the elements is not defined so:
///     either prints "Big"    and then  "Small"
///     or     prints "Small"  and then  "Big"
///
/// Sequence and Collection Operations
/// ----------------------------------
///
/// In addition to the `Multiset` type's multiset operations, you can use any
/// nonmutating sequence or collection methods with a multiset.
///
///     let factorsOf12: Multiset = [2:2, 3:1]
///     if factorsOf12.isEmpty {
///         print("No factors")
///     } else {
///         print("Twelve has \(factorsOf12.count) factors.")
///         print("Twelve has \(factorsOf12.distinctCount) distinct factors.")
///     }
///     // Prints "Twelve has 3 factors."
///     // Prints "Twelve has 2 distinct factors."
///
///     let factorsProduct = factors.reduce(1, *)
///     // 'factorsProduct' == 12
///
///     let factorsStrings = factors.sorted().map(String.init)
///     // 'primeStrings' == ["2", "2", "3"]
///
/// And as a collection you can use index operations:
///
///     var multi: Multiset = ["AA":3, "BB":3]
///     if let index = multi.firstIndex(of: "BB") {
///         multi.remove(at: index)     // ["AA":3, "BB":2]
///      }
///
/// Set Algebra Operations
/// ----------------------
///
/// Multiset provides the Set Algebra operations which are the same as the
/// ones used by Set.  You can test a multiset for membership of an element
/// or check its intersection with other multisets:
///
/// - `contains(_:)` tests whether a multiset contains a specific element.
/// - "equal to" operator (`==`) tests whether two multisets contain the same
///   elements and the sanem number of those elements.
/// - `isSubset(of:)` tests whether another multiset contains at least as many of
///    each of the current multisets elements.
/// - `isSuperset(of:)` tests whether a multiset contains at least as many of
///    each of another multisets elements.
/// - `isStrictSubset(of:)` and `isStrictSuperset(of:)` test whether a multiset
///   is a subset or superset of, but not equal to, another multiset.
/// - `isDisjoint(with:)` tests whether a multiset has any elements
///   in common with another multiset.
///
/// - Note that when multisets have more than one of the same element some of
///   these operations may not be as obvious as with sets.
///   For example even though:
///   AAB = Multiset(["A":2, "B":1]) and ABB = Multiset(["A":2, "B":1])
///   both contains "A" and "B" and no other elements, neither contains the other.
///
/// You can also combine, exclude, or subtract the elements of two multisets:
///
/// - `union(_:)` creates a new multiset with the elements of a multiset and
///    another multiset or sequence.
/// - `intersection(_:)` creates a new multiset with only the elements common to
///    a multiset and another multiset or sequence.
/// - `symmetricDifference(_:)` creates a new multiset with the elements that are
///   in either a multiset or another multiset or sequence, but not in both.
/// - `subtracting(_:)` creates a new multiset with the elements of a multiset
///   that are not also in another multiset or sequence.
///
/// - Note that when multisets have more than one of the same element some of
///   these operations may not be as obvious as with sets.  For example if:
///   AAB = Multiset(["A":2, "B":1]) and ABC = Multiset(["A":1, "B":1, "C":1])
///   then AAB.symmetricDifference(ABC) is Multiset(["A":1, "C":1])
///
/// You can modify a multiset in place by using these mutating
/// methods: `formUnion(_:)`, `formIntersection(_:)`,
/// `formSymmetricDifference(_:)`, and `subtract(_:)`.
///
/// Multiset operations are not limited to use with other multisets. You can perform
/// many operations with sets, arrays or any sequence with the same Element type:
///
///     let word = Multiset(Array("SINS"))
///     word is now ["S":2, "I":1, "N":1] although Multisets are not ordered so may
///     be a different order.
///
///     let scrabbleHand: [Character] = ["MISSING"]
///
///     // Tests whether the characters of the word SINS can be found in the
///      // array of characters MISSING:
///     print(word.isSubset(of: scrabbleHand) )
///     // Prints "true"
///
///     // Performs an intersection with an Array<Int>
///     let primes: Multiset = [2, 3, 5, 7, 11, 13, 17, 19, 23]
///     let favoriteNumbers = [5, 7, 15, 21]
///     print(primes.intersection(favoriteNumbers))
///     // Prints "[5, 7]"
///
/// Other reading
/// -------------
/// Because Multiset has some similarity with both Set and Dictionary, reading
/// the documentation or source for those may also be useful:
///
/// https://github.com/apple/swift/blob/master/stdlib/public/core/Set.swift
/// https://github.com/apple/swift/blob/master/stdlib/public/core/Dictionary.swift
///
public struct Multiset<Element: Hashable> {
  internal var content: Dictionary<Element, Int>
}

/// Initialisers:
/// -------------

extension Multiset {
  /// Creates an empty multiset:
  ///
  ///     let empty = Multiset<Int>()
  ///     print(empty.isEmpty)   // Prints "true"
  public init() {
    content = [:]
  }

  /// Create a Multiset from another dictionary:
  ///
  ///     let multi = Multiset(["A":2, "B":1, "C":5])
  ///     let multi2 = Multiset(multi)
  ///     print(multi2)    //Prints ["A":2, "B":1, "C":5])
  public init(_ dictionary: Dictionary<Element, Int>) {
    self.init()
    for (element, count) in dictionary {
      if count > 0 {
        self.content[element, default: 0] += count
      }
    }
  }

  /// Create a new multiset from a finite sequence of items:
  ///
  ///     let validIndices = Multiset([7,8,7,1,2])
  ///     print(validIndices)    //Prints "[7:2, 8:1, 1:1, 2:1]"    (order of elements may vary)
  @inlinable
  public init<Source: Sequence>(_ sequence: Source)
    where Source.Element == Element {
      self.init()
      for element in sequence {
        insert(element)
      }
  }
  
  /// Create a new multiset from a variadic sequence of 2 or more items:
  ///
  ///     let truth = Multiset(true, false, true, true)
  ///     print(truth)    //Prints "[true:3, false:1]"    (order of elements may vary)
  @inlinable
  public init(_ firstElement: Element, _ secondElement: Element, _ remainingElements: Element...) {
    self.init()
    insert(firstElement)
    insert(secondElement)
    for element in remainingElements {
      insert(element)
    }
  }
  
}

extension Multiset {
  /// Create an empty Multiset with preallocated capacity.
  ///
  /// Note that the capacity is the number of unique elements.
  /// Multiple copies of the same element don't require more space because
  /// only one copy of each distinct element is stored along with a count of
  /// the number of that element.
  ///
  ///     var multi = Multiset<Int>(minimumCapacity: 100)
  public init(minimumCapacity: Int) {
    content = [:]
    content.reserveCapacity(minimumCapacity)
  }
  
  /// Get capacity of the underlying dictionary
  ///
  ///     var multi = Multiset<Int>(minimumCapacity: 100)
  ///     print(multi.capacity)
  ///     // Prints 100
  public var capacity: Int {
    return content.capacity
  }
  
  /// Set capacity of the underlying dictionary
  ///
  ///     var multi = Multiset<Int>()
  ///     multi.reserveCapacity(100)
  ///     print(multi.capacity)
  ///     // Prints 100
  public mutating func reserveCapacity(_ minimumCapacity: Int) {
    content.reserveCapacity(minimumCapacity)
  }
}

extension Multiset: ExpressibleByArrayLiteral {
  /// Create a multiset containing the elements of the given array literal.
  ///
  /// Note that [unlike Set], if the array has repeated items they will be included.
  /// Note that the same element can be repeated.
  /// A multiset is unordered so the order may not be preserved.
  /// (Do not call this initializer directly. It is used by the compiler when
  ///  you use an array literal.)
  ///
  ///     let drink: Multiset = ["coffee", "milk", "sugar", "sugar"]
  ///     print(drink)    // Prints ["sugar":2, "milk":1, "coffee":1]
  @inlinable
  public init(arrayLiteral elements: Element...) {
    self.init(elements)
  }
}

extension Multiset: ExpressibleByDictionaryLiteral {
  /// Creates a multiset containing the elements of the given dictionary literal.
  ///
  /// The "values" of the Dictionary must be integers representing the number of
  /// each element.
  /// If a count of zero is used then the element will not be added to the multiset.
  /// A multiset is unordered so the order may not be preserved.
  /// (Do not call this initializer directly. It is used by the compiler when
  ///  you use a dictionary literal.)
  ///
  ///     let drink: Multiset = ["coffee":1, "milk":1, "sugar":2, "sweetener":0]
  ///     print(drink)    // Prints ["sugar":2, "milk":1, "coffee":1]
  @inlinable
  public init(dictionaryLiteral elements: (Element, Int)...) {
    // The map converts elements to the "named" tuple the initializer expects.
    self.init(elements.map { (key: $0.0, value: $0.1) })
  }
  
}

/// Counting:
/// -------------------------------------------

extension Multiset {
  /// The number of elements in the multiset
  ///
  /// Note that if an element is repeated twice then that counts 2.
  ///
  ///     let multi: Multiset = ["A":2, "B":4]
  ///     print(multi.count)    // Prints 6
  public var count: Int {
    return content.reduce(0) {$0 + $1.value}
  }
  
  /// The number of distinct elements in the multiset.
  ///
  ///     let multi: Multiset = ["A":2, "B":4]
  ///     print(multi.distinctCount)    // Prints 2
  public var distinctCount: Int {
    return content.count
  }
  
  /// The number of elements of a particular type in the multiset.
  ///
  /// [In mathematics know as multiplicity]
  ///
  ///     let multi: Multiset = ["A":2, "B":4]
  ///     print(multi.count(of: "B"))    // Prints 4
  public func count(of element: Element) -> Int {
    return content[element] ?? 0
  }
}

/// MARK: Basic methods:
/// -------------------------------------------

extension Multiset {
  /// Insert a number of equal elements (or one if no count specified)
  ///
  ///     var multi = Multiset<String>()  // []
  ///     multi.insert("Big", count: 6)   // ["Big":6]
  ///     multi.insert("Small")           // ["Big":6, "Small":1]
  ///
  /// Note that insert is overloaded slightly oddly to satisfy SetAlgebra.
  public mutating func insert(_ newElement: Element, count: Int = 1) {
    if count > 0 {
      content[newElement, default: 0] += count
    }
  }

  /// Remove a number of equal elements (or one if no count specified)
  ///
  /// If all are not availble to remove then don't remove any and return false
  ///
  ///     var multi = Multiset(["Big":6, "Small":3])    // ["Big":6, "Small":3]
  ///     multi.remove("Big", count:2)                  // ["Big":4, "Small":3]
  ///     multi.remove("Small")                         // ["Big":4, "Small":2]
  ///     print(multi.remove("Small",count:10))         // Prints false
  @discardableResult
  public mutating func remove(_ element: Element, count: Int = 1) -> Bool {
    guard
      count > 0,
      let currentCount = content[element],
      currentCount >= count
      else { return false }
    
    if count < currentCount {
      // More than enough so just remove the ones requested
      content[element] = currentCount - count
    } else {
      // Exactly the right number there so remove the key
      content.removeValue(forKey: element)
    }
    return true
  }
  
  /// Remove a number of equal elements as possible (try for just one if no count specified)
  ///
  /// If all are not available to remove then just remove as many as possible
  /// Return the number removed
  ///
  ///     var multi = Multiset(["Big":6, "Small":3])           //                  multi is now ["Big":6, "Small":3]
  ///     print(multi.remove(ifPossible: "Big", count:2))      // Prints 2         multi is now ["Big":4, "Small":3]
  ///     print(multi.remove(ifPossible: "Big"))               // Prints 1         multi is now ["Big":3, "Small":3]
  ///     print(multi.remove(ifPossible: "Small", count: 5))   // Prints 3         multi is now ["Big":3]
  ///     print(multi.remove(ifPossible: "Medium"))            // Prints 0         multi is now ["Big":3]
  @discardableResult
  public mutating func remove(ifPossible element: Element, count: Int = 1) -> Int {
    guard
      count > 0,
      let currentCount = content[element]
      else { return 0 }
    
    if count < currentCount {
      // More than enough so just remove the ones requested
      content[element] = currentCount - count
      return count
    }
    // Remove them all
    content.removeValue(forKey: element)
    return currentCount
  }
  
  /// Remove all of a particular element
  ///
  /// Returns the count of the number of elements removed
  ///
  ///     var multi = Multiset(["Big":6, "Small":3])    //               multi is now ["Big":6, "Small":3]
  ///     print(multi.removeAll("Small"))               // Prints 3      multi is now ("Big", 6)
  @discardableResult
  public mutating func removeAll(_ element: Element) -> Int {
    if let currentCount = content[element] {
      content.removeValue(forKey: element)
      return currentCount
    }
    return 0
  }
  
  /// Remove all occurrences of a sequence of elements
  ///
  /// Returns the count of the number of elements removed
  ///
  ///     var multi = Multiset(["Big":6, "Medium":2, "Small":3])    //               multi is now ["Big":6, "Medium":2, "Small":3]
  ///     print(multi.removeAll(["Small","Medium"]))                // Prints 5      multi is now ("Big", 6)
  @discardableResult
  public mutating func removeAll<Source: Sequence>(_ sequence: Source) -> Int where Source.Element == Element {
    var removedCount = 0
    for element in sequence {
      removedCount += removeAll(element)
    }
    return removedCount
  }
  
  /// Removes all elements from the multiset
  ///
  /// If keepingCapacity = `true`, the multiset's buffer capacity is preserved
  public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
    content.removeAll(keepingCapacity: keepCapacity)
  }
  
  /// Returns a new multiset containing the elements of the multiset that satisfy
  /// the given predicate.
  ///
  ///     let cast: Multiset = ["Vivien", "Marlon", "Kim", "Karl"]
  ///     let shortNames = cast.filter { $0.count < 5 }
  ///     print(shortNames.isSubset(of: cast))    // Prints true
  ///     shortNames.contains("Vivien")    // Prints false
  ///
  /// isIncluded ia a closure that takes an element as its argument and returns
  /// a Bool value indicating whether the element should be included.
  @inlinable
  public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> Multiset {
    var result = Multiset()
    for element in self {
      if try isIncluded(element) {
        result.insert(element)
      }
    }
    return result
  }
  
}

// Check for both subset and equality relationship between two multisets.
//
// (isSubset: lhs ⊂ rhs, isEqual: lhs == rhs)
internal func _compareMultisets<Element>(_ lhs: Multiset<Element>, _ rhs: Multiset<Element>)
  -> (isSubset: Bool, isEqual: Bool) {
    // First check there are no elements in left which are not in right
    // We can do this on just the distinct elements - we're not concerned about counts
    let leftNotInRight = Set(lhs.distinct()).subtracting(Set(rhs.distinct()))
    // If there are then left is not a subset of right and left is not equal to right
    guard leftNotInRight.isEmpty else { return (false, false) }
    
    // We now know that lefts elements are all in rights elements
    // so we can iterate through right comparing counts
    var equal = true
    for (element, rightCount) in rhs.grouped() {
      let leftCount = lhs.count(of: element)
      if leftCount > rightCount {
        // This means left is not a subset of right and left is not equal to right
        return (false, false)
      }
      if leftCount < rightCount {
        equal = false
        // Note that even though we now know they are not equal, we don't yet know
        // whether left is a subset of right as a "not-yet-checked" element may have
        // a greater count on the left
      }
    }
    return (true, equal)
}

/// MARK: Sequence & Iterators
/// -------------------------------------------

extension Multiset: Sequence {
  /// This iterator works through each element in the dictionary
  ///
  /// Multiset is not ordered so the order is not predictable but the same elements will always come together.
  ///
  ///     for element in Multiset(["Red":2, "Yellow":1]) { print(element) }
  ///     // Prints either:        "Yellow" then "Yellow" then "Red"
  ///     // or:                   "Red"    then "Yellow" then "Yellow"
  ///     // but would never get:  "Yellow" then "Red"    then "Yellow"
  public struct MultisetIterator<Element: Hashable>: IteratorProtocol {
    var dictionaryIterator: DictionaryIterator<Element, Int>
    var currentElement: Element? = nil
    var countOfCurrentElementToGo: Int = 0
    
    init(_ dictionary: Dictionary<Element, Int>) {
      dictionaryIterator = dictionary.makeIterator()
      nextElementAndCount()
    }
    
    mutating func nextElementAndCount() {
      if let (element, count) = dictionaryIterator.next() {
        currentElement = element
        countOfCurrentElementToGo = count
      } else {
        currentElement = nil
        countOfCurrentElementToGo = 0
      }
    }
    
    mutating public func next() -> Element? {
      while countOfCurrentElementToGo == 0 {
        if currentElement == nil { return nil }
        nextElementAndCount()
      }
      // We've found some elements to go...
      countOfCurrentElementToGo -= 1
      guard let element = currentElement else { return nil }
      return element
    }
  }
  
  // Returns an iterator over the element of the multiset.
  public func makeIterator() -> MultisetIterator<Element> {
    return MultisetIterator(content)
  }
}

/// MARK: Extra Iterators:
/// -------------------------------------------

extension Multiset {
  
  /// Return an Iterator which provides tuples: (element: Element, count:Int)
  ///
  ///     for tuple in Multiset(["Red":2, "Yellow":1]).grouped() {
  ///       print(tuple)
  ///     }
  ///     // Prints:  ("Yellow":2) then ("Red":1)
  ///
  /// (Note that Multiset is not ordered so the order is unpredicatable)
  /// or better:
  ///
  ///     for (element, count) in Multiset(["Red":2, "Yellow":1]).grouped() {...
  func grouped() -> AnyIterator<(element: Element, count: Int)> {
    var iterator = content.makeIterator()
    return AnyIterator {
      return iterator.next()
    }
  }
  
  /// Return an Iterator which provides one of each distinct element
  ///
  ///     for element in Multiset(["Red":2, "Yellow":1]).distinct() {
  ///       print(element)
  ///     }
  ///     // Prints:  "Yellow" then "Red"
  ///
  /// (Note that Multiset is not ordered so the order is unpredicatable)
  func distinct() -> AnyIterator<Element> {
    var iterator = content.makeIterator()
    return AnyIterator {
      guard let (element, _) = iterator.next() else { return nil }
      return element
    }
  }
  
  /// The "RootSet" or "Root" is the Set of elements in the multiset.
  ///
  /// (The term root comes from the mathematical term used in relation to a multiset)
  ///
  ///     let fruit: Multiset = ["Orange":3, "Lemon":5]
  ///     print( fruit.root() )    // Prints ["Orange, "Lemon"]    (Order may vary)
  func root() -> Set<Element> {
    return Set(content.keys)
  }
  
}

/// MARK: Collection and Indexing
/// -------------------------------------------

/// Collection conformance
extension Multiset: Collection {
  public typealias Index = MultisetIndex<Element>
  
  /// The starting position for iterating members of the multiset.
  ///
  /// If the multiset is empty, `startIndex` is equal to `endIndex`.
  public var startIndex: Index {
    return MultisetIndex(contentIndex: content.startIndex, offset: 0, maximum: count)
  }
  
  /// The "past the end" position for the multiset---that is, the position one
  /// greater than the last valid subscript argument.
  ///
  /// If the multiset is empty, `endIndex` is equal to `startIndex`.
  public var endIndex: Index {
    return MultisetIndex(contentIndex: content.endIndex, offset: 0, maximum: count)
  }
  
  /// Accesses the member at the given position.
  public subscript(index: Index) -> Element {
    let (element, count) = content[index.contentIndex]
    if index.offset + 1 <= count {
      return element
    } else {
      let from = content.index(after: index.contentIndex)
      let offset = index.offset - count
      let max = self.count
      let msi = MultisetIndex(contentIndex: from, offset: offset, maximum: max)
      return self[msi]
    }
  }
  
  /// Finds the index which immediately follows the given index
  public func index(after index: MultisetIndex<Element>) -> MultisetIndex<Element> {
    let count = content[index.contentIndex].value
    if index.offset < count-1 {
      // We're within the same element
      return index.nextIndex()
    }
    // We've run out of the same element so need to progress to the next one
    precondition(index.contentIndex < content.endIndex, "Can't move past the end of dictionary's index!")
    let nextDictionaryIndex = content.index(after: index.contentIndex)
    return MultisetIndex(contentIndex: nextDictionaryIndex, offset: 0, maximum: self.count)
  }
  
}

/// MARK: Some extra indexing
extension Multiset {
  /// Returns the index of the first given element in the set, or `nil` if the
  /// element is not a member of the set.
  public func firstIndex(of element: Element) -> Index? {
    guard let index = content.index(forKey: element) else { return nil }
    return MultisetIndex(contentIndex: index, offset: 0, maximum: self.count)
  }
  
  /// The first element of the multiset.
  ///
  /// The first element of the set is not necessarily the first element added
  /// to the set. Don't expect any particular ordering of set elements.
  /// If the set is empty, the value of this property is `nil`.
  public var first: Element? {
    return count > 0 ? self[startIndex] : nil
  }
  
  /// Removes the element at the given index of the multiset.
  @discardableResult
  public mutating func remove(at position: Index) -> Element {
    let element = self[position]
    remove(element)
    return element
  }
  
}

/// Other Multiset Protocols
/// -------------------------------------------

extension Multiset: CustomStringConvertible {
  /// A string that represents the contents of the multiset.
  ///
  ///     let multi = Multiset(["A":2, "B":1, "C":5])
  ///     print(multi)    //Prints ["A":2, "B":1, "C":5])
  public var description: String {
    return String(describing: content)
  }
}

extension Multiset: CustomDebugStringConvertible {
  /// A string that represents the contents of the set, suitable for debugging.
  ///
  ///     let multi = Multiset(["A":2, "B":1, "C":5])
  ///     print(multi)    //Prints Multiset["A":2, "B":1, "C":5])
  public var debugDescription: String {
    return "Multiset(\(String(describing: content)))"
  }
}

extension Multiset: Equatable {
  /// Returns a Boolean value indicating whether two multisets are equal
  public static func == (lhs: Multiset<Element>, rhs: Multiset<Element>) -> Bool {
    return lhs.content == rhs.content
  }
}

extension Multiset: Hashable {
  /// Hashes the essential components of this value by feeding them into the
  /// given hasher.
  public func hash(into hasher: inout Hasher) {
    var commutativeHash = 0
    for (k, v) in grouped() {
      // Note that we use a copy of our own hasher here. This makes hash values
      // dependent on its state, eliminating static collision patterns.
      var elementHasher = hasher
      elementHasher.combine(k)
      elementHasher.combine(v)
      commutativeHash ^= elementHasher.finalize()
    }
    hasher.combine(commutativeHash)
  }
}

/// Protocol conformance for SETALGEBRA
/// -------------------------------------------

extension Multiset: SetAlgebra {
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Guide to functions required for SetAlgebra
  // * means SetAlgebra provides a default implementation
  //   in all cases this is overridden to ensure maximum efficiency
  //
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //  Required conformances:
  //
  //  initialisers:
  //     init()
  //  *  init<S : Sequence>(_ sequence: S) where S.Element == Element
  //
  //     func contains(_ member: Element) -> Bool
  //     func union(_ other: Self) -> Self
  //     func intersection(_ other: Self) -> Self
  //     func symmetricDifference(_ other: Self) -> Self
  //  *  func subtracting(_ other: Self) -> Self
  //  *  func isSubset(of other: Self) -> Bool
  //  *  func isDisjoint(with other: Self) -> Bool
  //  *  func isSuperset(of other: Self) -> Bool
  //  *  var isEmpty: Bool { get }
  //
  //     mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element)
  //     mutating func update(with newMember: Element) -> Element?
  //     mutating func remove(_ member: Element) -> Element?
  //     mutating func formUnion(_ other: Self)
  //     mutating func formIntersection(_ other: Self)
  //     mutating func formSymmetricDifference(_ other: Self)
  //  *  mutating func subtract(_ other: Self)
  //
  //  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //  Not required but added implemented as protocol extensions:
  //
  //  *  func isStrictSuperset(of other: Self) -> Bool {
  //  *  func isStrictSubset(of other: Self) -> Bool {
  //  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //  nonmutating:
  //
  /// Returns a Boolean value that indicates whether the given element exists
  /// in the multiset.
  ///
  ///     let fruit: Multiset = ["Orange":2, "Lemon":5]
  ///     if fruit.contains("Orange") {
  ///       print("Found it")    // Prints "Found it"
  ///     }
  public func contains(_ member: Element) -> Bool {
    return content[member] != nil
  }
  
  /// Returns a new multiset with elements from this multiset and the given multiset.
  ///
  /// If both multisets have some of the same element then the new multiset will have
  /// the more numerous of the two.
  ///
  ///     let juicy: Multiset = ["Orange":2, "Lemon":5]
  ///     let yellow: Multiset = ["Lemon":3, "Melon":1]
  ///     let juicyOrYellow = juicy.union(yellow)    // ["Orange":2, "Lemon":5, "Melon":1]  (Order may vary)
  @inlinable
  public func union(_ other: Multiset<Element>) -> Multiset<Element> {
    var newMultiset = self
    newMultiset.formUnion(other)
    return newMultiset
  }
  
  /// Returns a new multiset with elements that are common to both this multiset
  /// and the given multiset.
  ///
  /// If both multisets have some of the same element then the new multiset will have
  /// the least numerous of the two.
  ///
  ///     let juicy: Multiset = ["Orange":2, "Lemon":5]
  ///     let yellow: Multiset = ["Lemon":3, "Melon":1]
  ///     let juicyAndYellow = juicy.intersection(yellow)    // ["Lemon":3]
  @inlinable
  public func intersection(_ other: Multiset<Element>) -> Multiset<Element> {
    var newMultiset = self
    newMultiset.formIntersection(other)
    return newMultiset
  }
  
  /// Returns a new multiset with elements that are in either this multiset or
  /// the given multiset, but not both.
  ///
  /// If both sets have some of the same element then the new multiset will have
  /// the difference between the two.
  ///
  ///     let juicy: Multiset = ["Orange":2, "Lemon":5]
  ///     let yellow: Multiset = ["Lemon":3, "Melon":1]
  ///     let juicyExclusiveOrYellow = juicy.symmetricDifference(yellow)    // ["Orange":2, "Lemon":2, "Melon":1]  (Order may vary)
  @inlinable
  public func symmetricDifference(_ other: Multiset<Element>) -> Multiset<Element> {
    var newMultiset = self
    newMultiset.formSymmetricDifference(other)
    return newMultiset
  }
  
  /// Returns a new multiset with elements that are in this multiset but NOT in
  /// the given multiset.
  ///
  /// If both sets have some of the same element then the new multiset will have
  /// the difference between the two.
  ///
  ///     let juicy: Multiset = ["Orange":2, "Lemon":5]
  ///     let yellow: Multiset = ["Lemon":3, "Melon":1]
  ///     let juicyButNotYellow = juicy.subtracting(yellow)    // ["Orange":2, "Lemon":2]  (Order may vary)
  @inlinable
  public func subtracting(_ other: Multiset<Element>) -> Multiset<Element> {
    var newMultiset = self
    newMultiset.subtract(other)
    return newMultiset
  }
  
  /// Returns a Boolean value that indicates whether this multiset is a subset of
  /// the given multiset.
  ///
  /// If both multisets have some of the same element then this multiset must have
  /// less than or the same number of elements as the given multiset.
  ///
  ///     let stock: Multiset = ["Red":5, "Blue":3, "Yellow":1]
  ///     let shopping: Multiset = ["Red":5, "Blue":1]
  ///     print(shopping.isSubset(of: stock))    // Prints "true"
  public func isSubset(of other: Multiset<Element>) -> Bool {
    let (isSubset, isEqual) = _compareMultisets(self, other)
    return isSubset || isEqual
  }
  
  /// Returns a Boolean value that indicates whether this multiset is disjoint from
  /// the given multiset.
  ///
  /// If both multisets contain the same element then the sets will not be disjoint
  ///
  ///     let stock: Multiset = ["Red":5, "Blue":3, "Yellow":1]
  ///     let shopping: Multiset = ["Red":1, "Orange":10]
  ///     print(shopping.isDisjoint(with: stock))    // Prints "false"
  @inlinable
  public func isDisjoint(with other: Multiset<Element>) -> Bool {
    for element in self {
      if other.contains(element) {
        return false
      }
    }
    return true
  }
  
  /// Returns a Boolean value that indicates whether this multiset is a superset of
  /// the given multiset.
  ///
  /// If both multisets have some of the same element then this multiset must have
  /// more than or the same number of elements as the given multiset.
  ///
  ///     let stock: Multiset = ["Red":5, "Blue":3, "Yellow":1]
  ///     let shopping: Multiset = ["Red":5, "Blue":1]
  ///     print(stock.isSuperset(of: shopping))    // Prints "true"
  @inlinable
  public func isSuperset(of other: Multiset<Element>) -> Bool {
    return other.isSubset(of: self)
  }
  
  /// A Boolean value that indicates whether the multiset is empty.
  public var isEmpty: Bool {
    return content.count == 0  // More efficient than checking if count == 0
  }
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //  mutating:
  //
  /// MARK: Basic functions
  //
  
  /// Inserts the given element in the multiset.
  /// Note that if the element is already in the multiset then it increases the count of that element.
  ///
  ///     var fruit: Multiset = ["Orange":2, "Lemon":1]
  ///     fruit.insert("Orange")    // ["Orange":3, "Lemon":1]
  ///
  /// Note that insert is overloaded slightly oddly to satisfy SetAlgebra.
  @inlinable
  @discardableResult
  public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
    insert(newMember, count: 1)
    return (true, newMember)
  }
  
  /// Updates the count of a specified element in the multiset.
  ///
  /// If the count is set to zero then the element is dropped from the multiset
  ///
  ///   var fruit: Multiset = ["Orange":2, "Lemon":1]
  ///   fruit.update(count: 3, for: "Lemon")    // ["Orange":2, "Lemon":3]  (Order may vary)
  ///   fruit.update(count: 0, for: "Lemon")    // ["Orange":2]
  mutating func update(count: Int, for element: Element) {
    if count == 0 {
      content.removeValue(forKey: element)
    } else {
      content.updateValue(count, forKey: element)
    }
  }
  
  /// Updates the element in the multiset.
  ///
  /// Note that this is not meaningful for a multiset because the value is always just an Integer
  /// but this function needs to be included to conform to Setalgebra.  Recommend to not use this.
  @inlinable
  @discardableResult
  public mutating func update(with newMember: Element) -> Element? {
    return newMember
  }
  
  /// Removes one of the given element from the multiset.
  ///
  /// Return the element or nil if no element to remove.
  /// If there are two or more of the given element then decrease the count of that
  /// element by one.
  ///
  ///     var fruit: Multiset = ["Orange":3, "Lemon":1]
  ///     fruit.remove("Orange")    // ["Orange":2, "Lemon":1]  (Order may vary)
  ///     fruit.remove("Lemon")     // ["Orange":2]
  @discardableResult
  public mutating func remove(_ member: Element) -> Element? {
    if remove(member, count: 1) {
      // Element removed
      return member
    } else {
      // Element not removed so return nil
      return nil
    }
  }
  
  /// MARK: Mutating set functions: union, intersection, symmetricDifference, subtract
  
  /// Mutating version of union
  public mutating func formUnion(_ other: Multiset<Element>) {
    for (element, rightCount) in other.grouped() {
      let leftCount = count(of: element)
      if rightCount > leftCount {
        update(count: rightCount, for: element)
      }
    }
  }
  
  /// Mutating version of intersection
  public mutating func formIntersection(_ other: Multiset<Element>) {
    for (element, leftCount) in grouped() {
      let rightCount = other.count(of: element)
      if rightCount < leftCount {
        update(count: rightCount, for: element)
      }
    }
  }
  
  /// Mutating version of symmetricDifference
  public mutating func formSymmetricDifference(_ other: Multiset<Element>) {
    for (element, rightCount) in other.grouped() {
      let leftCount = count(of: element)
      let difference = Swift.abs(leftCount - rightCount)
      update(count: difference, for: element)
    }
  }
  
  /// Mutating version of subtracting
  public mutating func subtract(_ other: Multiset<Element>) {
    for (member, otherCount) in other.grouped() {
      let selfCount = count(of: member)
      let newCount = Swift.max(0,selfCount-otherCount)
      update(count: newCount, for: member)
    }
  }
  
  /// As for isSubset but if the two multisets are equal then return false
  public func isStrictSubset(of other: Multiset<Element>) -> Bool {
    let (isSubset, isEqual) = _compareMultisets(self, other)
    return isSubset && !isEqual
  }
  
  /// As for isSuperset but if the two multisets are equal then return false
  @inlinable
  public func isStrictSuperset(of other: Multiset<Element>) -> Bool {
    return other.isStrictSubset(of: self)
  }
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // End of Protocol conformance for SETALGEBRA
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

/// MARK: Sequence versions of set Algebra methods:
/// -------------------------------------------

extension Multiset {
  ///  MARK: Initialisers:
  
  /// Create a new multiset from a finite sequence of (element, count) tuples:
  ///     let multi = Multiset([("A",8),("B",3)])
  ///     print(multi)    //Prints "["A":8, "B":3]    (order of elements may vary)
  @inlinable
  public init<Source: Sequence>(_ sequence: Source)
    where Source.Element == (Element, Int) {
      self.init()
      for (element, count) in sequence {
        insert(element, count:count)
      }
  }
  
  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //  nonmutating:
  
  /// SEQUENCE VERSION OF: func isSubset(of other: Self) -> Bool
  ///
  /// As for isSubset but using a sequence of Elements rather than another multiset.
  ///
  ///     let lunch: Multiset = ["Spam":2, "Egg":1]
  ///     print(lunch.isSubset(of: ["Spam", "Spam", "Spam", "Spam", "Egg"]))    // Prints "true"    X)
  public func isSubset<S: Sequence>(of possibleSuperset: S) -> Bool
    where S.Element == Element {
      return isSubset(of: Multiset(possibleSuperset))
  }
  
  /// SEQUENCE VERSION OF: func isStrictSubset(of other: Self) -> Bool {
  ///
  /// As for isStrictSubset but using a sequence of Elements rather than another multiset.
  ///
  ///     let lunch: Multiset = ["Sandwich":1, "Apple":2]
  ///     print(lunch.isSubset(of: ["Sandwich", "Apple", "Apple"]))    // Prints "false"
  @inlinable
  public func isStrictSubset<S: Sequence>(of possibleStrictSuperset: S) -> Bool
    where S.Element == Element {
      return isStrictSubset(of: Multiset(possibleStrictSuperset))
  }
  
  /// SEQUENCE VERSION OF: func isSuperset(of other: Self) -> Bool
  ///
  /// As for isSuperset but using a sequence of Elements rather than another multiset.
  ///
  ///     let menu: Multiset = ["Sandwich":3, "Apple":2]
  ///     print(menu.isSuperset(of: ["Sandwich", "Apple", "Apple"]))    // Prints "true"
  @inlinable
  public func isSuperset<S: Sequence>(of possibleSubset: S) -> Bool
    where S.Element == Element {
      return isSuperset(of: Multiset(possibleSubset))
  }
  
  /// SEQUENCE VERSION OF: func isStrictSuperset(of other: Self) -> Bool {
  ///
  /// As for isStrictSuperset but using a sequence of Elements rather than another multiset.
  ///
  ///    let menu: Multiset = ["Sandwich":3, "Apple":2]
  ///     print(menu.isStrictSuperset(of: ["Sandwich", "Apple", "Apple"]))    // Prints "true"
  @inlinable
  public func isStrictSuperset<S: Sequence>(of possibleStrictSubset: S) -> Bool
    where S.Element == Element {
      return isStrictSuperset(of: Multiset(possibleStrictSubset))
  }
  
  /// SEQUENCE VERSION OF: func isDisjoint(with other: Self) -> Bool
  ///
  /// As for isDisjoint but using a sequence of Elements rather than another multiset.
  ///
  ///     let birds: Multiset = ["Duck":2]
  ///     print(birds.isDisjoint(with: ["Not a duck", "Horse"]))    // Prints "true"
  @inlinable
  public func isDisjoint<S: Sequence>(with other: S) -> Bool
    where S.Element == Element {
      return isDisjoint(with: Multiset(other))
  }
  
  /// SEQUENCE VERSION OF: func union(_ other: Self) -> Self
  ///
  /// As for union but using a sequence of Elements rather than another multiset.
  @inlinable
  public func union<S: Sequence>(_ other: S) -> Multiset<Element>
    where S.Element == Element {
      return union(Multiset(other))
  }
  
  /// SEQUENCE VERSION OF: func intersection(_ other: Self) -> Self
  ///
  /// As for intersection but using a sequence of Elements rather than another multiset.
  public func intersection<S: Sequence>(_ other: S) -> Multiset<Element>
    where S.Element == Element {
      return intersection(Multiset(other))
  }
  
  /// SEQUENCE VERSION OF: func symmetricDifference(_ other: Self) -> Self
  ///
  /// As for symmetricDifference but using a sequence of Elements rather than another multiset.
  @inlinable
  public func symmetricDifference<S: Sequence>(_ other: S) -> Multiset<Element>
    where S.Element == Element {
      return symmetricDifference(Multiset(other))
  }
  
  /// SEQUENCE VERSION OF: func subtracting(_ other: Self) -> Self
  ///
  /// As for subtracting but using a sequence of Elements rather than another multiset.
  @inlinable
  public func subtracting<S: Sequence>(_ other: S) -> Multiset<Element>
    where S.Element == Element {
      return subtracting(Multiset(other))
  }
  
  //  mutating:
  
  /// SEQUENCE VERSION OF: mutating func formUnion(_ other: Self)
  ///
  /// As for formUnion but using a sequence of Elements rather than another multiset.
  @inlinable
  public mutating func formUnion<S: Sequence>(_ other: S)
    where S.Element == Element {
      self = self.union(other)
  }
  
  // SEQUENCE VERSION OF: mutating func formIntersection(_ other: Self)
  ///
  /// As for formIntersection but using a sequence of Elements rather than another multiset.
  @inlinable
  public mutating func formIntersection<S: Sequence>(_ other: S)
    where S.Element == Element {
      self = self.intersection(other)
  }
  
  // SEQUENCE VERSION OF: mutating func formSymmetricDifference(_ other: Self)
  ///
  /// As for formSymmetricDifference but using a sequence of Elements rather than another multiset.
  @inlinable
  public mutating func formSymmetricDifference<S: Sequence>(_ other: S)
    where S.Element == Element {
      self = self.symmetricDifference(other)
  }
  
  // SEQUENCE VERSION OF: mutating func subtract(_ other: Self)
  ///
  /// As for subtract but using a sequence of Elements rather than another multiset.
  @inlinable
  public mutating func subtract<S: Sequence>(_ other: S)
    where S.Element == Element {
      self = self.subtracting(other)
  }
  
}

/// MultisetIndex
/// -------------------------------------------

/// Defines an index into a Multiset
public struct MultisetIndex<Element: Hashable> {
  // Note: do not change to public as it doesn't work beyond the end of an element type
  // Use index(after: ) instead
  fileprivate func nextIndex() -> MultisetIndex {
    return MultisetIndex(contentIndex: contentIndex, offset: offset + 1, maximum: maximum)
  }
  
  internal let contentIndex: DictionaryIndex<Element, Int>
  internal let offset: Int
  internal let maximum: Int
}

extension MultisetIndex: Equatable {
  /// MultisetIndex is Equatable
  // Can't use automatic synthesis because of [*]
  static public func == <Element: Hashable> (left: MultisetIndex<Element>, right: MultisetIndex<Element>) -> Bool {
    if left.contentIndex == right.contentIndex {
      return left.offset == right.offset && left.maximum == right.maximum
    } else {
      // [*] Even if dictionary indices are different the multiset indices can be referring to the same point:
      return left.maximum == right.maximum && abs(left.offset - right.offset) == left.maximum
    }
  }
}

extension MultisetIndex: Comparable {
  /// MultisetIndex is Comparable
  static public func < <Element: Hashable> (left: MultisetIndex<Element>, right: MultisetIndex<Element>) -> Bool {
    if left.contentIndex == right.contentIndex {
      return left.offset < right.offset
    }
    if left.contentIndex < right.contentIndex {
      return (left.offset - right.offset) < left.maximum
    }
    return false
  }
}

extension MultisetIndex: CustomStringConvertible {
  public var description: String {
    return "MultisetIndex(from: \(contentIndex), offset: \(offset), max: \(maximum))"
  }
}
