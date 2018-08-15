//
//  MultisetTest.swift
//  MultisetTest
//
//  Created by Adahus on 26/07/2018.
//

import XCTest

//////////////////////////////////////////////////////////////////
/// Initialisers

class TestMultiset_A1_init: XCTestCase {
  
  //init()
  func test_init() {
    let multi = Multiset<Int>()
    XCTAssertTrue(multi.isEmpty)
    XCTAssertEqual(multi.count, 0)
    XCTAssertEqual(multi.distinctCount, 0)
  }
  
  //init<Source: Sequence>(_ sequence: Source) where Source.Element == Element
  func test_init_sequence() {
    let validIndices = Multiset([7,8,7,1,2])
    let check: Multiset = [7:2, 8:1, 1:1, 2:1]
    XCTAssertEqual(validIndices, check)
    
    XCTAssertEqual(Multiset(1...5), Multiset([1:1,2:1,3:1,4:1,5:1]))
    
    XCTAssertEqual(Multiset("HELLO"), Multiset(["H":1, "E":1, "L":2, "O":1]))
  }
  
  //init<Source: Sequence>(_ sequence: Source) where Source.Element == (Element, Int)
  func test_init_sequence_tuples() {
    let multi = Multiset([("A",8),("B",3)])
    let check: Multiset = ["A":8, "B":3]
    XCTAssertEqual(multi, check)
    
    XCTAssertEqual( Multiset([("AA",0), ("BB",3), ("AA",0), ("BB",1)]), Multiset(["BB":4]))
  }
  
  func test_init_variadic() {
    let truth = Multiset(true, false, true, true)
    XCTAssertEqual( truth, Multiset([false:1, true:3]) )
    
    XCTAssertEqual( Multiset("Apple", "Orange", "Apple") ,  ["Apple":2, "Orange":1] )
  }
  
  func test() {
    func arithmeticMean(_ numbers: Double...) -> Double {
      var total: Double = 0
      for number in numbers {
        total += number
      }
      return total / Double(numbers.count)
    }
    print(arithmeticMean(1, 2, 3, 4, 5))
    print(arithmeticMean())
    
    print( Set([1,2,3]) )
    print( Multiset(1,2,3,3) )
  }
  
  //init(_ dictionary: Dictionary<Element, Int>)
  func test_init_dictionary() {
    do {
      let multi = Multiset(["AA", "BB", "BB", "CC", "CC", "CC"])
      let dict: Dictionary = ["AA":1, "BB":2, "CC":3]
      let multiFromDict = Multiset(dict)
      XCTAssertEqual(multi, multiFromDict)
    }
    do {
      let multi = Multiset(["AA":2])
      let dict: Dictionary = ["AA":2, "BB":0]
      let multiFromDict = Multiset(dict)
      XCTAssertEqual(multi, multiFromDict)
    }
  }
  
  //init(minimumCapacity: Int)
  func test_init_minimumcapacity() {
    let multi = Multiset<Int>(minimumCapacity: 100)
    XCTAssertGreaterThanOrEqual(multi.capacity, 100)
  }
  
  //var capacity: Int
  func test_capacity() {
    let multi = Multiset<Int>(minimumCapacity: 200)
    XCTAssertGreaterThanOrEqual(multi.capacity, 200)
  }
  
  //mutating func reserveCapacity(_ minimumCapacity: Int)
  func test_reserveCapacity() {
    var multi = Multiset<Int>()
    multi.reserveCapacity(300)
    XCTAssertGreaterThanOrEqual(multi.capacity, 300)
  }
  
  //init(arrayLiteral elements: Element...)
  func test_init_arrayLiteral() {
    let drink: Multiset = ["coffee", "milk", "sugar", "sugar"]
    let check = Multiset(["coffee":1, "milk":1, "sugar":2])
    XCTAssertEqual(drink, check)
  }
  
  //init(dictionaryLiteral elements: (Element, Int)...)
  func test_dictionaryLiteral() {
    let drink: Multiset = ["coffee":1, "milk":1, "sugar":2, "sweetener":0]
    let check = Multiset(["coffee":1, "milk":1, "sugar":2])
    XCTAssertEqual(drink, check)
  }
  
  func test_init_fromSet() {
    let set = Set([1,2,3])
    let multi = Multiset(set)
    let check: Multiset = [1:1, 2:1, 3:1]
    XCTAssertEqual(multi, check)
  }
  
}

//////////////////////////////////////////////////////////////////
/// Counting

class TestMultiset_B1_count: XCTestCase {
  
  //var count: Int
  func test_count() {
    let multi: Multiset = ["A":2, "B":4]
    XCTAssertEqual(multi.count, 6)
  }
  
  //var distinctCount: Int
  func test_distinctCount() {
    let empty = Multiset<String>()
    XCTAssertEqual(empty.distinctCount, 0)
    XCTAssertEqual(Multiset(["A":2]).distinctCount, 1)
    XCTAssertEqual(Multiset(["A":2, "B":4]).distinctCount, 2)
    XCTAssertEqual(Multiset(["A":2, "B":0]).distinctCount, 1)
  }
  
  //func count(of element: Element) -> Int
  func test_countOf() {
    let multi: Multiset = ["A":2, "B":4]
    XCTAssertEqual(multi.count(of: "A"), 2)
    XCTAssertEqual(multi.count(of: "B"), 4)
    XCTAssertEqual(multi.count(of: "C"), 0)
  }
  
  //var isEmpty: Bool
  func test_isEmpty() {
    XCTAssertFalse(Multiset(["Orange":2]).isEmpty)
    XCTAssertTrue(Multiset<String>().isEmpty)
    
    var bag: Multiset = ["A":4, "B":3]
    XCTAssertFalse(bag.isEmpty)
    bag.removeAll("B")
    XCTAssertFalse(bag.isEmpty)
    bag.removeAll("A")
    XCTAssertTrue(bag.isEmpty)
  }
  
}

//////////////////////////////////////////////////////////////////
/// Insert and update

class TestMultiset_D1_insert_and_update: XCTestCase {
  
  //mutating func insert(_ newElement: Element, count: Int = 1)
  func test_insert_element() {
    var multi = Multiset<String>()
    multi.insert("Big", count: 6)
    XCTAssertEqual(multi, Multiset(["Big":6]))
    multi.insert("Small")
    XCTAssertEqual(multi, Multiset(["Big":6, "Small":1]))
    
    do {
      // Insert one
      var m = Multiset<String>()
      XCTAssertEqual(m.count, 0)
      XCTAssertEqual(m.distinctCount, 0)
      
      m.insert("Banana")
      XCTAssertEqual(m.count, 1)
      XCTAssertEqual(m.distinctCount, 1)
      
      m.insert("Orange")
      XCTAssertEqual(m.count, 2)
      XCTAssertEqual(m.distinctCount, 2)
      
      m.insert("Banana")
      XCTAssertEqual(m.count, 3)
      XCTAssertEqual(m.distinctCount, 2)
      
      m.insert("Apple")
      XCTAssertEqual(m.count, 4)
      XCTAssertEqual(m.distinctCount, 3)
    }
    do {
      // Insert multiple
      var m = Multiset<String>()
      XCTAssertEqual(m.count, 0)
      XCTAssertEqual(m.distinctCount, 0)
      
      m.insert("Banana",count: 2)
      XCTAssertEqual(m.count, 2)
      XCTAssertEqual(m.distinctCount, 1)
      
      m.insert("Orange", count: 3)
      XCTAssertEqual(m.count, 5)
      XCTAssertEqual(m.distinctCount, 2)
      
      m.insert("Banana", count: 5)
      XCTAssertEqual(m.count, 10)
      XCTAssertEqual(m.distinctCount, 2)
      
      m.insert("Apple", count: 10)
      XCTAssertEqual(m.count, 20)
      XCTAssertEqual(m.distinctCount, 3)
    }
  }
  
  //mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element)
  func test_insert() {
    var fruit: Multiset = ["Orange":2, "Lemon":1]
    let (inserted, memberAfterInsert) = fruit.insert("Orange")
    XCTAssertEqual(inserted, true)
    XCTAssertEqual(memberAfterInsert, "Orange")
    XCTAssertEqual(fruit, Multiset(["Orange":3, "Lemon":1]) )
  }
  
  //mutating func update(count: Int, for element: Element)
  func test_update_count() {
    var fruit: Multiset = ["Orange":2, "Lemon":1]
    fruit.update(count: 3, for: "Lemon")
    XCTAssertEqual(fruit, Multiset(["Orange":2, "Lemon":3]) )
    fruit.update(count: 0, for: "Lemon")
    XCTAssertEqual(fruit, Multiset(["Orange":2]) )
  }
  
  //mutating func update(with newMember: Element) -> Element?
  func test_update() {
    var fruit: Multiset = ["Orange":2, "Lemon":1]
    fruit.update(with: "Lemon")
    XCTAssertEqual(fruit, Multiset(["Orange":2, "Lemon":1]) )
  }
  
}

//////////////////////////////////////////////////////////////////
/// Remove

class TestMultiset_D2_remove: XCTestCase {
  
  //mutating func remove(_ element: Element, count: Int = 1) -> Bool
  func test_remove_element() {
    var multi = Multiset(["Big":6, "Small":3])
    XCTAssertTrue(multi.remove("Big", count:2))
    XCTAssertEqual(multi, Multiset(["Big":4, "Small":3]))
    XCTAssertTrue(multi.remove("Small"))
    XCTAssertEqual(multi, Multiset(["Big":4, "Small":2]))
    XCTAssertFalse(multi.remove("Medium"))
    XCTAssertEqual(multi, Multiset(["Big":4, "Small":2]))
    XCTAssertFalse(multi.remove("Small", count:3))
    XCTAssertEqual(multi, Multiset(["Big":4, "Small":2]))
  }
  
  //mutating func remove(ifPossible element: Element, count: Int = 1) -> Int
  func test_removeIfPossible() {
    var multi = Multiset(["Big":6, "Small":3])
    XCTAssertEqual(multi.remove(ifPossible: "Big", count:2), 2)
    XCTAssertEqual(multi, Multiset(["Big":4, "Small":3]))
    XCTAssertEqual(multi.remove(ifPossible: "Small"), 1)
    XCTAssertEqual(multi, Multiset(["Big":4, "Small":2]))
    XCTAssertEqual(multi.remove(ifPossible: "Medium"), 0)
    XCTAssertEqual(multi, Multiset(["Big":4, "Small":2]))
    XCTAssertEqual(multi.remove(ifPossible: "Small", count:3), 2)
    XCTAssertEqual(multi, Multiset(["Big":4]))
  }
  
  //mutating func removeAll(_ element: Element) -> Int
  func test_removeAll_element() {
    var multi = Multiset(["Big":6, "Small":3])
    XCTAssertEqual(multi.removeAll("Small"), 3)
    XCTAssertEqual(multi, Multiset(["Big":6]))
  }
  
  //mutating func removeAll<Source: Sequence>(_ sequence: Source) -> Int where Source.Element == Element
  func test_removeAll_sequence() {
    var multi = Multiset(["Big":6, "Medium":2, "Small":3])
    XCTAssertEqual(multi.removeAll(["Huge"]), 0)
    XCTAssertEqual(multi, Multiset(["Big":6, "Medium":2, "Small":3]))
    XCTAssertEqual(multi.removeAll(["Small","Medium"]), 5)
    XCTAssertEqual(multi, Multiset(["Big":6]))
  }
  
  //mutating func removeAll(keepingCapacity keepCapacity: Bool = false)
  func test_removeAll_keepingCapacity() {
    var multi = Multiset<Int>()
    for i in 1...100 {
      multi.insert(i)
    }
    XCTAssertGreaterThanOrEqual(multi.capacity, 100)
    multi.removeAll()
    XCTAssertLessThan(multi.capacity, 100)
    for i in 1...100 {
      multi.insert(i)
    }
    multi.removeAll(keepingCapacity: true)
    XCTAssertGreaterThanOrEqual(multi.capacity, 100)
  }
  
  func test_remove_one_element() {
    var m: Multiset = ["A":3, "B":4, "C":5]
    XCTAssertEqual(m.count, 12)
    XCTAssertEqual(m.distinctCount, 3)
    
    let remove1 = m.remove("A")
    XCTAssertEqual(remove1, "A")
    XCTAssertEqual(m.count, 11)
    XCTAssertEqual(m.distinctCount, 3)
    
    let remove2 = m.remove("A")
    XCTAssertEqual(remove2, "A")
    XCTAssertEqual(m.count, 10)
    XCTAssertEqual(m.distinctCount, 3)
    
    let remove3 = m.remove("A")
    XCTAssertEqual(remove3, "A")
    XCTAssertEqual(m.count, 9)
    XCTAssertEqual(m.distinctCount, 2)
    
    let remove4 = m.remove("A")
    XCTAssertEqual(remove4, nil)
    XCTAssertEqual(m.count, 9)
    XCTAssertEqual(m.distinctCount, 2)
  }
  
  func test_remove_multipleingroup() {
    var m: Multiset = ["A":3, "B":4, "C":5]
    XCTAssertEqual(m.count, 12)
    XCTAssertEqual(m.distinctCount, 3)
    XCTAssertEqual(m.count(of: "A"),3)
    XCTAssertEqual(m.count(of: "B"),4)
    XCTAssertEqual(m.count(of: "C"),5)
    
    let remove1 = m.remove("A", count: 2)
    XCTAssertEqual(remove1, true)
    XCTAssertEqual(m.count(of: "A"),1)
    XCTAssertEqual(m.count, 10)
    XCTAssertEqual(m.distinctCount, 3)
    
    // Try to remove 2 but only one available
    let remove2 = m.remove("A", count: 2)
    XCTAssertEqual(remove2, false)
    XCTAssertEqual(m.count(of: "A"),1)
    XCTAssertEqual(m.count, 10)
    XCTAssertEqual(m.distinctCount, 3)
    
    let remove3 = m.remove("A", count: 1)
    XCTAssertEqual(remove3, true)
    XCTAssertEqual(m.count(of: "A"),0)
    XCTAssertEqual(m.count, 9)
    XCTAssertEqual(m.distinctCount, 2)
    
    // Try to remove 1 but none available
    let remove4 = m.remove("A", count: 1)
    XCTAssertEqual(remove4, false)
    XCTAssertEqual(m.count(of: "A"),0)
    XCTAssertEqual(m.count, 9)
    XCTAssertEqual(m.distinctCount, 2)
  }
  
  func test_remove_all() {
    var m: Multiset = ["A":3, "B":4, "C":5]
    XCTAssertEqual(m.count, 12)
    XCTAssertEqual(m.distinctCount, 3)
    XCTAssertEqual(m.count(of: "A"),3)
    XCTAssertEqual(m.count(of: "B"),4)
    XCTAssertEqual(m.count(of: "C"),5)
    
    let remove1 = m.removeAll("A")
    XCTAssertEqual(remove1, 3)
    XCTAssertEqual(m.count(of: "A"),0)
    XCTAssertEqual(m.count, 9)
    XCTAssertEqual(m.distinctCount, 2)
    
    let remove2 = m.removeAll("A")
    XCTAssertEqual(remove2, 0)
    XCTAssertEqual(m.count(of: "A"),0)
    XCTAssertEqual(m.count, 9)
    XCTAssertEqual(m.distinctCount, 2)
    
    let remove3 = m.removeAll("C")
    XCTAssertEqual(remove3, 5)
    XCTAssertEqual(m.count(of: "C"),0)
    XCTAssertEqual(m.count, 4)
    XCTAssertEqual(m.distinctCount, 1)
    
    let remove4 = m.removeAll("B")
    XCTAssertEqual(remove4, 4)
    XCTAssertEqual(m.count(of: "B"),0)
    XCTAssertEqual(m.count, 0)
    XCTAssertEqual(m.distinctCount, 0)
  }
  
  func test_remove_index() {
    var m: Multiset = ["AA":3, "BB":4, "CC":5]
    let index1 = m.firstIndex(of: "BB")
    XCTAssertEqual(m.remove(at: index1!), "BB")
    let index2 = m.firstIndex(of: "DD")
    XCTAssertNil(index2)
  }
  
  //mutating func remove(at position: Index) -> Element
  func test_remove_at() {
    var fruit: Multiset = ["Orange":2, "Lemon":2]
    let start = fruit.startIndex
    fruit.remove(at: start)
    XCTAssertTrue( (fruit == Multiset(["Orange":1, "Lemon":2])) || (fruit == Multiset(["Orange":2, "Lemon":1])) )
  }
  
  //mutating func remove(_ member: Element) -> Element?
  func test_remove() {
    var fruit: Multiset = ["Orange":3, "Lemon":1]
    fruit.remove("Orange")
    XCTAssertEqual(fruit, Multiset(["Orange":2, "Lemon":1]) )
    fruit.remove("Lemon")
    XCTAssertEqual(fruit, Multiset(["Orange":2]) )
  }
  
  func test_removeAllSequence() {
    var bag: Multiset = ["A":4, "B":3, "C":2]
    let count = bag.removeAll(["B", "A"])
    XCTAssertEqual(count, 7)
    XCTAssertEqual(bag, ["C":2] )
    
    var bag2: Multiset = ["A":4, "B":3, "C":2]
    let count2 = bag2.removeAll(Set(["B", "C", "A"]))
    XCTAssertEqual(count2, 9)
    XCTAssertEqual(bag2, [] )
  }
  
}

//////////////////////////////////////////////////////////////////
/// Filter & Sort

class TestMultiset_C2_filter_sort: XCTestCase {
  //func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> Multiset
  func test_filter() {
    let cast: Multiset = ["Vivien", "Marlon", "Kim", "Karl"]
    let shortNames = cast.filter { $0.count < 5 }
    XCTAssertTrue(shortNames.isSubset(of: cast))
    XCTAssertFalse(shortNames.contains("Vivien"))
  }
  
  // test filter extra 2
  func test_filter2() {
    let cast: Multiset = ["Vivien", "Marlon", "Kim", "Karl"]
    let shortNames = cast.filter { $0.count < 5 }
    
    XCTAssertTrue(shortNames.isSubset(of: cast))
    XCTAssertFalse(shortNames.contains("Vivien"))
    XCTAssertEqual(shortNames, Multiset(["Kim", "Karl"]))
  }
  
  func test_filtering() {
    let shopping: Multiset = ["Banana":1, "Egg":6, "Bread":1, "Milk":2, "Mushroom":10]
    
    let moreThanOne = shopping.grouped().filter { $0.count > 1 }
    XCTAssertEqual(Multiset<String>(moreThanOne), Multiset(["Egg":6, "Milk":2, "Mushroom":10]))
    
    let nameLongerThanFour = shopping.grouped().filter { $0.element.count > 4 }
    XCTAssertEqual(Multiset<String>(nameLongerThanFour), Multiset(["Banana":1, "Bread":1, "Mushroom":10]))
  }
  
  func test_sorting() {
    // This is really testing sort rather than anything in Multiset but it's good to use Multiset in other contexts
    let shopping: Multiset = ["Banana":1, "Egg":6, "Milk":2, "Mushroom":10]
    
    // Sort with the most numerous first (output is an Array of (element, count) tuples because Multiset's are not ordered)
    let sorted = shopping.grouped().sorted { $0.count > $1.count }
    print(sorted)
    XCTAssertEqual(sorted[0].element, "Mushroom")
    XCTAssertEqual(sorted[0].count, 10)
    XCTAssertEqual(sorted[1].element, "Egg")
    XCTAssertEqual(sorted[1].count, 6)
    XCTAssertEqual(sorted[2].element, "Milk")
    XCTAssertEqual(sorted[2].count, 2)
    XCTAssertEqual(sorted[3].element, "Banana")
    XCTAssertEqual(sorted[3].count, 1)
    
    // Sort the elements into alphanumeric order and return as an array of just the elements
    let sorted2 = shopping.distinct().sorted { $0 < $1 }
    XCTAssertEqual(sorted2, ["Banana","Egg","Milk","Mushroom"])
    print(sorted2)
  }
  
}

//////////////////////////////////////////////////////////////////
/// Iteration & Sequence

class TestMultiset_C1_iteration: XCTestCase {
  
  //struct MultisetIterator<Element: Hashable>: IteratorProtocol
  func test_iterator() {
    let original = Multiset(["Big":6, "Medium":2, "Small":3])
    var gather = Multiset<String>()
    for element in original {
      gather.insert(element)
    }
    XCTAssertEqual(original, gather)
  }
  
  //func grouped() -> AnyIterator<(element: Element, count: Int)>
  func test_group() {
    do {
      let original = Multiset(["Big":6, "Medium":2, "Small":3])
      var gather = Multiset<String>()
      for tuple in original.grouped() {
        gather.insert(tuple.element, count: tuple.count)
      }
      XCTAssertEqual(original, gather)
    }
    
    do {
      let original = Multiset(["Big":6, "Medium":2, "Small":3])
      var gather = Multiset<String>()
      for (element, count) in original.grouped() {
        gather.insert(element, count: count)
      }
      XCTAssertEqual(original, gather)
    }
  }
  
  //func distinct() -> AnyIterator<Element>
  func test_distinct() {
    let original = Multiset(["Big":6, "Medium":2, "Small":3])
    var gather = Multiset<String>()
    for element in original.distinct() {
      gather.insert(element, count: 1)
    }
    XCTAssertEqual(gather, Multiset(["Big":1, "Medium":1, "Small":1]) )
  }
  
  //func root() -> Set<Element>
  func test_root() {
    let fruit: Multiset = ["Orange":3, "Lemon":5]
    XCTAssertEqual(fruit.root(), Set(["Orange", "Lemon"]) )
  }
  
  func test_rootagain() {
    var street: Multiset = ["House":2, "Shop":10, "Church":1]
    XCTAssertEqual(street.root(), Set(["House", "Shop", "Church"]))
    street.remove("Church")
    XCTAssertEqual(street.root(), Set(["House", "Shop"]))
    street.removeAll("Shop")
    XCTAssertEqual(street.root(), Set(["House"]))
    street.removeAll("House")
    XCTAssertEqual(street.root(), Set<String>([]))
  }
  
}

//////////////////////////////////////////////////////////////////
/// Indexing & Collection

class TestMultiset_F1_indexing: XCTestCase {
  //var startIndex: Index
  //var endIndex: Index
  //subscript(index: Index) -> Element
  //func index(after index: MultisetIndex<Element>) -> MultisetIndex<Element>
  func test_indexing() {
    let fruit: Multiset = ["Orange":1, "Lemon":1]
    let start = fruit.startIndex
    let end = fruit.endIndex
    let oneFruit = fruit[start]
    let next = fruit.index(after: start)
    let otherFruit = fruit[next]
    let shouldBeEnd = fruit.index(after: next)
    XCTAssertEqual(shouldBeEnd, end)
    XCTAssertTrue( ((oneFruit == "Orange") && (otherFruit == "Lemon")) || ((oneFruit == "Lemon") && (otherFruit == "Orange")) )
  }
  
  //func firstIndex(of member: Element) -> Index?
  func test_firstIndexVarious() {
    func checkFirstIndexMultiple(number: Int) {
      // This is a bit convoluted - it's carefully checking some of the logic of index(after):
      
      // Set up a Multiset with a number of two types of element
      let multi = Multiset(["A": number, "B": number])
      
      // Get the indices of an element AND the index of the index "after" the end of those elements.
      // Depending on the order in which the two elements have ended up in the underlying dictionary (which is not predictable),
      // the "after" index may be the endIndex of the Multiset OR the start of the other element type.
      func getIndices(of element: String) -> (indices: [MultisetIndex<String>], after: MultisetIndex<String>) {
        var indices = [MultisetIndex<String>]()
        var index: MultisetIndex<String> = multi.firstIndex(of: element)!
        for _ in 1...number {
          indices.append(index)
          index = multi.index(after: index)
        }
        let after = index
        return (indices, after)
      }
      
      // Check the indices of A all return "A" when using subscript
      let (AIndices, AAfter) = getIndices(of: "A")
      for index in AIndices {
        XCTAssertEqual(multi[index], "A")
      }
      
      // Check the indices of B all return "B" when using subscript
      let (BIndices, BAfter) = getIndices(of: "B")
      for index in BIndices {
        XCTAssertEqual(multi[index], "B")
      }
      
      // Now determine which order the elements are in (A then B) or (B then A)
      // And set up variables for further testing
      var otherFirst: MultisetIndex<String>
      var shouldFollow: String
      if AAfter < multi.endIndex {
        otherFirst = AAfter
        shouldFollow = "B"
      } else {
        otherFirst = BAfter
        shouldFollow = "A"
      }

      // Now check that there's the right number of the second element type
      var index = otherFirst
      for _ in 1...number {
        XCTAssertEqual(multi[index], shouldFollow)
        index = multi.index(after: index)
      }
      // And that after that the multiset ends
      XCTAssertEqual(index, multi.endIndex)
    }
    
    // Run the checking function for 1 to 10 elements of each type:
    for number in 1...10 {
      checkFirstIndexMultiple(number: number)
    }
  }
  
  func testFirstElement() {
    let fruit: Multiset = ["Orange":2]
    XCTAssertEqual(fruit.first!,"Orange")
  }
  
  func test_dropFirst() {
    //dropFirst is a default implementation for a collection
    let bag: Multiset = ["A":4, "B":3, "C":1]
    let withoutFirst = bag.dropFirst()
    
    // Check that the overall count reduced by 1
    XCTAssertEqual(bag.count, 8)
    XCTAssertEqual(withoutFirst.count, 7)
    
    // Work out what should be left
    let droppedElement = bag.subtracting(withoutFirst).first!
    let remaining = Multiset(withoutFirst) //Otherwise it's a slice
    
    // Check what's left is correct
    switch droppedElement {
    case "A": XCTAssertEqual(remaining, Multiset(["A":3, "B":3, "C":1]))
    case "B": XCTAssertEqual(remaining, Multiset(["A":4, "B":2, "C":1]))
    case "C": XCTAssertEqual(remaining, Multiset(["A":4, "B":3]))
    default: fatalError()
    }
  }
  
  func test_startAndEndSubscript() {
    do {
      let numberOfAs = 3
      let numberOfBs = 7
      let multi = Multiset(["A":numberOfAs, "B":numberOfBs])
      var start = multi.startIndex
      let end = multi.endIndex
      var count = 0
      while start != end {
        start = multi.index(after: start)
        count += 1
      }
      XCTAssertEqual( count, numberOfAs + numberOfBs )
    }
    
    do {
      let multi = Multiset<String>()
      XCTAssertEqual(multi.startIndex, multi.endIndex)
    }
  }
  
  func test_subscriptAndIndexAfter() {
    func indexAndGather<Element>(_ multiset: Multiset<Element>) {
      var index = multiset.startIndex
      var loop = 1
      var gather = Multiset<Element>()
      while index < multiset.endIndex {
        let element = multiset[index]
        gather.insert(element)
        index = multiset.index(after: index)
        loop += 1
      }
      XCTAssertEqual(multiset,gather)
    }
    
    indexAndGather(Multiset(["A":2]))
    indexAndGather(Multiset([5:2]))
    indexAndGather(Multiset(["A":1, "B":1, "C":1]))
    indexAndGather(Multiset(["A":2, "B":1, "C":3]))
    indexAndGather(Multiset(["A":5, "B":5, "C":5]))
    indexAndGather(Multiset<String>())
  }
  
  //var first: Element?
  func test_first() {
    var fruit: Multiset = ["Orange":3, "Lemon":2]
    let first = fruit.first
    XCTAssertTrue( (first == "Orange") || (first == "Lemon") )
    fruit.removeAll()
    XCTAssertNil(fruit.first)
  }
}

//////////////////////////////////////////////////////////////////
/// Protocols

class TestMultiset_E1_protocols: XCTestCase {
  
  //var description: String
  func test_description() {
    let multi = Multiset(["A":4, "B":3])
    print(multi.description)
    XCTAssertTrue( (multi.description == "[\"A\": 4, \"B\": 3]") || (multi.description == "[\"B\": 3, \"A\": 4]") )
    
    let m: Multiset = ["Big":5]
    XCTAssertEqual(m.description, "[\"Big\": 5]")
  }
  
  //var debugDescription: String
  func test_debugDescription() {
    let m: Multiset = ["Small":3]
    XCTAssertEqual(m.debugDescription, "Multiset([\"Small\": 3])")
  }
  
  //func hash(into hasher: inout Hasher)
  func test_hash() {
    let multiset = Multiset(["A":3, "B":3, "C":1])
    var other = Multiset<String>()
    XCTAssertNotEqual(multiset.hashValue, other.hashValue)
    XCTAssertTrue(multiset != other)
    other = Multiset(["A":3, "B":1])
    other.insert("B", count: 2)
    other.insert("C", count: 1)
    XCTAssertEqual(multiset.hashValue, other.hashValue)
    XCTAssertTrue(multiset == other)
  }
  
  //func contains(_ member: Element) -> Bool
  func test_contains() {
    let fruit: Multiset = ["Orange":2, "Lemon":5]
    XCTAssertTrue(fruit.contains("Orange"))
    XCTAssertFalse(fruit.contains("Apple"))
  }
}

//////////////////////////////////////////////////////////////////
/// Algebra Inclusion

class TestMultiset_I1_algebra_inclusion: XCTestCase {
  
  // test helper function for algebra inclusion
  func test_compareMultisets() {
    
    func check(_ lhs: String, _ rhs: String, isSubset: Bool , isEqual: Bool) {
      let (subset, equal) = _compareMultisets(Multiset(Array(lhs)), Multiset(Array(rhs)) )
      XCTAssertEqual(isSubset, subset)
      XCTAssertEqual(isEqual, equal)
    }
    
    check(""  ,""  , isSubset: true , isEqual: true )
    check(""  ,"A" , isSubset: true , isEqual: false)
    check(""  ,"B" , isSubset: true , isEqual: false)
    check(""  ,"AB", isSubset: true , isEqual: false)
    check("A" ,""  , isSubset: false, isEqual: false)
    check("A" ,"A" , isSubset: true , isEqual: true )
    check("A" ,"B" , isSubset: false, isEqual: false)
    check("A" ,"AB", isSubset: true , isEqual: false)
    check("B" ,""  , isSubset: false, isEqual: false)
    check("B" ,"A" , isSubset: false, isEqual: false)
    check("B" ,"B" , isSubset: true , isEqual: true )
    check("B" ,"AB", isSubset: true , isEqual: false)
    check("AB",""  , isSubset: false, isEqual: false)
    check("AB","A" , isSubset: false, isEqual: false)
    check("AB","B" , isSubset: false, isEqual: false)
    check("AB","AB", isSubset: true , isEqual: true )
  }
  
  //func isSubset(of other: Multiset<Element>) -> Bool
  func test_isSubset() {
    do {
      let stock: Multiset = ["Red":5, "Blue":3, "Yellow":1]
      let shopping: Multiset = ["Red":5, "Blue":1]
      XCTAssertTrue(shopping.isSubset(of: stock))
    }
    do {
      let word = Multiset("SINS")
      let scrabbleHand: [Character] = Array("MISSING")
      print(word.isSubset(of: scrabbleHand) )
    }
  }
  
  //func isStrictSubset(of other: Multiset<Element>) -> Bool
  func test_isStrictSubset() {
    let stock: Multiset = ["Red":5, "Blue":3, "Yellow":1]
    let shopping: Multiset = ["Red":5, "Blue":1]
    XCTAssertTrue(shopping.isStrictSubset(of: stock))
    XCTAssertFalse(shopping.isStrictSubset(of: shopping))
  }
  
  //func isDisjoint(with other: Multiset<Element>) -> Bool
  func test_isDisjoint() {
    let stock: Multiset = ["Red":5, "Blue":3, "Yellow":1]
    let shopping: Multiset = ["Red":1, "Orange":10]
    XCTAssertFalse(shopping.isDisjoint(with: stock))
  }
  
  //func isSuperset(of other: Multiset<Element>) -> Bool
  func test_isSuperset() {
    let stock: Multiset = ["Red":5, "Blue":3, "Yellow":1]
    let shopping: Multiset = ["Red":5, "Blue":1]
    XCTAssertTrue(stock.isSuperset(of: shopping))
  }
  
  //func isStrictSuperset(of other: Multiset<Element>) -> Bool
  func test_isStrictSuperset() {
    let stock: Multiset = ["Red":5, "Blue":3, "Yellow":1]
    let shopping: Multiset = ["Red":5, "Blue":1]
    XCTAssertTrue(stock.isStrictSuperset(of: shopping))
    XCTAssertFalse(stock.isStrictSuperset(of: stock))
  }
  
  // test algebra inclusion more thoroughly
  func test_setalgebra_inclusion() {
    typealias MS = Multiset<String>
    
    func test<T,Result>(_ left: [Multiset<T>], _ function: (Multiset<T>) -> (Multiset<T>) -> Result, _ right: Multiset<T>) -> [Result] {
      return left.map { function($0)(right) }
    }
    
    let empty: Multiset<String> = []
    let a: Multiset = ["A"]
    let b: Multiset = ["B"]
    let ab: Multiset = ["A", "B"]
    
    do {
      // isSubset
      XCTAssertEqual(test([empty,a,b,ab], MS.isSubset        , empty), [true, false,false,false])
      XCTAssertEqual(test([empty,a,b,ab], MS.isSubset        , a    ), [true, true, false,false])
      XCTAssertEqual(test([empty,a,b,ab], MS.isSubset        , b    ), [true, false,true, false])
      XCTAssertEqual(test([empty,a,b,ab], MS.isSubset        , ab   ), [true, true, true, true ])
      
      // isStrictSubset
      XCTAssertEqual(test([empty,a,b,ab], MS.isStrictSubset  , empty), [false,false,false,false])
      XCTAssertEqual(test([empty,a,b,ab], MS.isStrictSubset  , a    ), [true, false,false,false])
      XCTAssertEqual(test([empty,a,b,ab], MS.isStrictSubset  , b    ), [true, false,false,false])
      XCTAssertEqual(test([empty,a,b,ab], MS.isStrictSubset  , ab   ), [true, true, true, false])
      
      // isSuperset
      XCTAssertEqual(test([empty,a,b,ab], MS.isSuperset      , empty), [true, true, true, true ])
      XCTAssertEqual(test([empty,a,b,ab], MS.isSuperset      , a    ), [false,true, false,true ])
      XCTAssertEqual(test([empty,a,b,ab], MS.isSuperset      , b    ), [false,false,true, true ])
      XCTAssertEqual(test([empty,a,b,ab], MS.isSuperset      , ab   ), [false,false,false,true ])
      
      // isStrictSuperset
      XCTAssertEqual(test([empty,a,b,ab], MS.isStrictSuperset, empty), [false,true, true, true ])
      XCTAssertEqual(test([empty,a,b,ab], MS.isStrictSuperset, a    ), [false,false,false,true ])
      XCTAssertEqual(test([empty,a,b,ab], MS.isStrictSuperset, b    ), [false,false,false,true ])
      XCTAssertEqual(test([empty,a,b,ab], MS.isStrictSuperset, ab   ), [false,false,false,false])
      
      // isDisjoint
      XCTAssertEqual(test([empty,a,b,ab], MS.isDisjoint      , empty), [true, true, true, true ])
      XCTAssertEqual(test([empty,a,b,ab], MS.isDisjoint      , a    ), [true, false,true, false])
      XCTAssertEqual(test([empty,a,b,ab], MS.isDisjoint      , b    ), [true, true, false,false])
      XCTAssertEqual(test([empty,a,b,ab], MS.isDisjoint      , ab   ), [true, false,false,false])
    }
    do {
      let aa:  Multiset = ["A":2]
      let aab: Multiset = ["A":2, "B":1]
      let abb: Multiset = ["A":1, "B":2]
      let bb:  Multiset = ["B":2]
      
      // isSubset
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isSubset        , aa   ), [true, false,false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isSubset        , aab  ), [true, true, false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isSubset        , abb  ), [false,false,true, true ])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isSubset        , bb   ), [false,false,false,true ])
      
      // isStrictSubset
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isStrictSubset  , aa   ), [false,false,false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isStrictSubset  , aab  ), [true, false,false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isStrictSubset  , abb  ), [false,false,false,true ])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isStrictSubset  , bb   ), [false,false,false,false])
      
      // isSuperset
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isSuperset      , aa   ), [true, true, false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isSuperset      , aab  ), [false,true, false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isSuperset      , abb  ), [false,false,true, false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isSuperset      , bb   ), [false,false,true, true ])
      
      // isStrictSuperset
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isStrictSuperset, aa   ), [false,true, false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isStrictSuperset, aab  ), [false,false,false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isStrictSuperset, abb  ), [false,false,false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isStrictSuperset, bb   ), [false,false,true ,false])
      
      // isDisjoint
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isDisjoint      , aa   ), [false,false,false,true ])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isDisjoint      , aab  ), [false,false,false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isDisjoint      , abb  ), [false,false,false,false])
      XCTAssertEqual(test([aa,aab,abb,bb], MS.isDisjoint      , bb   ), [true, false,false,false])
    }
  }
  
}

//////////////////////////////////////////////////////////////////
/// Algebra Inclusion Sequence

class TestMultiset_I2_algebra_inclusion_sequence: XCTestCase {
  
  //func isSubset<S: Sequence>(of possibleSuperset: S) -> Bool where S.Element == Element
  func test_isSubset_sequence() {
    let lunch: Multiset = ["Spam":2, "Egg":1]
    XCTAssertTrue( lunch.isSubset(of: ["Spam", "Spam", "Spam", "Spam", "Egg"]) )
  }
  
  //func isStrictSubset<S: Sequence>(of possibleStrictSuperset: S) -> Bool where S.Element == Element
  func test_isStrictSubset_sequence() {
    let lunch: Multiset = ["Sandwich":1, "Apple":2]
    XCTAssertTrue( lunch.isSubset(of: ["Sandwich", "Apple", "Apple"]) )
  }
  
  //func isSuperset<S: Sequence>(of possibleSubset: S) -> Bool where S.Element == Element
  func test_isSuperset_sequence() {
    let menu: Multiset = ["Sandwich":3, "Apple":2]
    XCTAssertTrue( menu.isSuperset(of: ["Sandwich", "Apple", "Apple"]) )
  }
  
  //func isStrictSuperset<S: Sequence>(of possibleStrictSubset: S) -> Bool where S.Element == Element
  func test_isStrictSuperset_sequence() {
    let menu: Multiset = ["Sandwich":3, "Apple":2]
    XCTAssertTrue( menu.isStrictSuperset(of: ["Sandwich", "Apple", "Apple"]) )
  }
  
  //func isDisjoint<S: Sequence>(with other: S) -> Bool where S.Element == Element
  func test_isDisjoint_sequence() {
    let birds: Multiset = ["Duck":2]
    XCTAssertTrue( birds.isDisjoint(with: ["Not a duck", "Horse"]) )
  }
  
}

//////////////////////////////////////////////////////////////////
/// Algebra Algebra Nonmutating

class TestMultiset_H1_algebra_nonmutating: XCTestCase {
  
  //func union(_ other: Multiset<Element>) -> Multiset<Element>
  func test_union() {
    let juicy: Multiset = ["Orange":2, "Lemon":5]
    let yellow: Multiset = ["Lemon":3, "Melon":1]
    let juicyOrYellow = juicy.union(yellow)
    XCTAssertEqual(juicyOrYellow, Multiset(["Orange":2, "Lemon":5, "Melon":1]) )
  }
  
  //func intersection(_ other: Multiset<Element>) -> Multiset<Element>
  func test_intersection() {
    let juicy: Multiset = ["Orange":2, "Lemon":5]
    let yellow: Multiset = ["Lemon":3, "Melon":1]
    let juicyAndYellow = juicy.intersection(yellow)
    XCTAssertEqual(juicyAndYellow, Multiset(["Lemon":3]) )
  }
  
  //func symmetricDifference(_ other: Multiset<Element>) -> Multiset<Element>
  func test_symmetricDifference() {
    let juicy: Multiset = ["Orange":2, "Lemon":5]
    let yellow: Multiset = ["Lemon":3, "Melon":1]
    let juicyExclusiveOrYellow = juicy.symmetricDifference(yellow)
    XCTAssertEqual(juicyExclusiveOrYellow, Multiset(["Orange":2, "Lemon":2, "Melon":1]) )
  }
  
  //func subtracting(_ other: Multiset<Element>) -> Multiset<Element>
  func test_subtracting() {
    let juicy: Multiset = ["Orange":2, "Lemon":5]
    let yellow: Multiset = ["Lemon":3, "Melon":1]
    let juicyButNotYellow = juicy.subtracting(yellow)
    XCTAssertEqual(juicyButNotYellow, Multiset(["Orange":2, "Lemon":2]) )
  }
  
  func test_setalgebra_multiple() {
    let empty: Multiset<String> = []
    let a1: Multiset = ["A":1]
    let a2: Multiset = ["A":2]
    let a3: Multiset = ["A":3]
    let range = [empty,a1,a2,a3]
    
    // union
    XCTAssertEqual(range.map { $0.union(empty) } , [empty,a1,a2,a3])
    XCTAssertEqual(range.map { $0.union(a1) } , [a1,a1,a2,a3])
    XCTAssertEqual(range.map { $0.union(a2) } , [a2,a2,a2,a3])
    XCTAssertEqual(range.map { $0.union(a3) } , [a3,a3,a3,a3])
    
    // intersection
    XCTAssertEqual(range.map { $0.intersection(empty) } , [empty,empty,empty,empty])
    XCTAssertEqual(range.map { $0.intersection(a1) } , [empty,a1,a1,a1])
    XCTAssertEqual(range.map { $0.intersection(a2) } , [empty,a1,a2,a2])
    XCTAssertEqual(range.map { $0.intersection(a3) } , [empty,a1,a2,a3])
    
    // symmetricDifference
    XCTAssertEqual(range.map { $0.symmetricDifference(empty) } , [empty,a1,a2,a3])
    XCTAssertEqual(range.map { $0.symmetricDifference(a1) } , [a1,empty,a1,a2])
    XCTAssertEqual(range.map { $0.symmetricDifference(a2) } , [a2,a1,empty,a1])
    XCTAssertEqual(range.map { $0.symmetricDifference(a3) } , [a3,a2,a1,empty])
    
    // subtracting
    XCTAssertEqual(range.map { $0.subtracting(empty) } , [empty,a1,a2,a3])
    XCTAssertEqual(range.map { $0.subtracting(a1) } , [empty,empty,a1,a2])
    XCTAssertEqual(range.map { $0.subtracting(a2) } , [empty,empty,empty,a1])
    XCTAssertEqual(range.map { $0.subtracting(a3) } , [empty,empty,empty,empty])
  }
  
  func test_setalgebra_mixed() {
    let empty: Multiset<String> = []
    let a1b2: Multiset = ["A":1, "B":2]
    let a2b1: Multiset = ["A":2, "B":1]
    let a2b2: Multiset = ["A":2, "B":2]
    let range = [empty,a1b2,a2b1,a2b2]
    
    // union
    XCTAssertEqual(range.map { $0.union(empty) } , [empty,a1b2,a2b1,a2b2])
    XCTAssertEqual(range.map { $0.union(a1b2) } , [a1b2,a1b2,a2b2,a2b2])
    XCTAssertEqual(range.map { $0.union(a2b1) } , [a2b1,a2b2,a2b1,a2b2])
    XCTAssertEqual(range.map { $0.union(a2b2) } , [a2b2,a2b2,a2b2,a2b2])
    
    // intersection
    let a1b1: Multiset = ["A":1, "B":1]
    XCTAssertEqual(range.map { $0.intersection(empty) } , [empty,empty,empty,empty])
    XCTAssertEqual(range.map { $0.intersection(a1b2) } , [empty,a1b2,a1b1,a1b2])
    XCTAssertEqual(range.map { $0.intersection(a2b1) } , [empty,a1b1,a2b1,a2b1])
    XCTAssertEqual(range.map { $0.intersection(a2b2) } , [empty,a1b2,a2b1,a2b2])
    
    // subtracting
    let a1: Multiset = ["A":1]
    let b1: Multiset = ["B":1]
    XCTAssertEqual(range.map { $0.subtracting(empty) } , [empty,a1b2,a2b1,a2b2])
    XCTAssertEqual(range.map { $0.subtracting(a1b2) } , [empty,empty,a1,a1])
    XCTAssertEqual(range.map { $0.subtracting(a2b1) } , [empty,b1,empty,b1])
    XCTAssertEqual(range.map { $0.subtracting(a2b2) } , [empty,empty,empty,empty])
  }
  
  // test algebra more thoroughly
  func test_algebra_nonmutating() {
    let empty: Multiset<String> = []
    let a: Multiset = ["A"]
    let b: Multiset = ["B"]
    let ab: Multiset = ["A", "B"]
    let range = [empty,a,b,ab]
    
    func test<T,Result>(_ left: [Multiset<T>], _ function: (Multiset<T>) -> (Multiset<T>) -> Result, _ right: Multiset<T>) -> [Result] {
      return left.map { function($0)(right) }
    }
    
    typealias MS = Multiset<String>
    
    //- - - - - - - - - - - - - - - -
    // Combining
    
    // union
    XCTAssertEqual(test([empty,a,b,ab], MS.union               , empty), [empty, a,     b,     ab   ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.union               , a    ), [a,     a,     ab,    ab   ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.union               , b    ), [b,     ab,    b,     ab   ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.union               , ab   ), [ab,    ab,    ab,    ab   ] )
    
    // intersection
    XCTAssertEqual(test([empty,a,b,ab], MS.intersection        , empty), [empty, empty, empty, empty] )
    XCTAssertEqual(test([empty,a,b,ab], MS.intersection        , a    ), [empty, a,     empty, a    ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.intersection        , b    ), [empty, empty, b,     b    ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.intersection        , ab   ), [empty, a,     b,     ab   ] )
    
    // symmetricDifference
    XCTAssertEqual(test([empty,a,b,ab], MS.symmetricDifference , empty), [empty, a,     b,     ab   ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.symmetricDifference , a    ), [a,     empty, ab,    b    ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.symmetricDifference , b    ), [b,     ab,    empty, a    ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.symmetricDifference , ab   ), [ab,    b,     a,     empty] )
    
    // subtracting
    XCTAssertEqual(test([empty,a,b,ab], MS.subtracting         , empty), [empty, a,     b,     ab   ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.subtracting         , a    ), [empty, empty, b,     b    ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.subtracting         , b    ), [empty, a    , empty, a    ] )
    XCTAssertEqual(test([empty,a,b,ab], MS.subtracting         , ab   ), [empty, empty, empty, empty] )
  }
}

//////////////////////////////////////////////////////////////////
/// Algebra Algebra Nonmutating Sequence

class TestMultiset_H2_algebra_nonmutating_sequence : XCTestCase {
  
  //func union<S: Sequence>(_ other: S) -> Multiset<Element> where S.Element == Element
  func test_union_sequence() {
    let multi = Multiset(["A":1, "B":2])
    XCTAssertEqual(multi.union(["A", "A", "B", "C"]), Multiset(["A":2, "B":2, "C":1]))
  }
  
  //func intersection<S: Sequence>(_ other: S) -> Multiset<Element> where S.Element == Element
  func test_intersection_sequence() {
    let multi = Multiset(["A":1, "B":2])
    XCTAssertEqual(multi.intersection(["A", "A", "B", "C"]), Multiset(["A":1, "B":1]))
  }
  
  //func symmetricDifference<S: Sequence>(_ other: S) -> Multiset<Element> where S.Element == Element
  func test_symmetricDifference_sequence() {
    let multi = Multiset(["A":1, "B":2])
    XCTAssertEqual(multi.symmetricDifference(["A", "A", "B", "C"]), Multiset(["A":1, "B":1, "C":1]))
  }
  
  //func subtracting<S: Sequence>(_ other: S) -> Multiset<Element> where S.Element == Element
  func test_subtracting_sequence() {
    let multi = Multiset(["A":1, "B":2])
    XCTAssertEqual(multi.subtracting(["A", "A", "B", "C"]), Multiset(["B":1]))
  }
  
}

//////////////////////////////////////////////////////////////////
/// Algebra Algebra Mutating

class TestMultiset_G1_algebra_mutating: XCTestCase {
  
  func test_form() {
    let empty: Multiset<String> = []
    let a: Multiset = ["A"]
    let b: Multiset = ["B"]
    let ab: Multiset = ["A", "B"]
    let range = [empty,a,b,ab]
    
    //......................................................................
    //Wrap these mutating functions so we can test them in a onmutating way:
    func tryFormUnion(_ base: Multiset<String>, _ other: Multiset<String>) -> Multiset<String> {
      var form = base
      form.formUnion(other)
      return form
    }
    
    func tryFormIntersection(_ base: Multiset<String>, _ other: Multiset<String>) -> Multiset<String> {
      var form = base
      form.formIntersection(other)
      return form
    }
    
    func tryFormSymmetricDifference(_ base: Multiset<String>, _ other: Multiset<String>) -> Multiset<String> {
      var form = base
      form.formSymmetricDifference(other)
      return form
    }
    
    func trySubtract(_ base: Multiset<String>, _ other: Multiset<String>) -> Multiset<String> {
      var form = base
      form.subtract(other)
      return form
    }
    //......................................................................
    
    // formUnion
    XCTAssertEqual(range.map { tryFormUnion($0, empty) } , [empty,a,b,ab])
    XCTAssertEqual(range.map { tryFormUnion($0, a) } , [a,a,ab,ab])
    XCTAssertEqual(range.map { tryFormUnion($0, b) } , [b,ab,b,ab])
    XCTAssertEqual(range.map { tryFormUnion($0, ab) } , [ab,ab,ab,ab])
    
    // formIntersection
    XCTAssertEqual(range.map { tryFormIntersection($0, empty) } , [empty,empty,empty,empty])
    XCTAssertEqual(range.map { tryFormIntersection($0, a) } , [empty,a,empty,a])
    XCTAssertEqual(range.map { tryFormIntersection($0, b) } , [empty,empty,b,b])
    XCTAssertEqual(range.map { tryFormIntersection($0, ab) } , [empty,a,b,ab])
    
    // formSymmetricDifference
    XCTAssertEqual(range.map { tryFormSymmetricDifference($0, empty) } , [empty,a,b,ab])
    XCTAssertEqual(range.map { tryFormSymmetricDifference($0, a) } , [a,empty,ab,b])
    XCTAssertEqual(range.map { tryFormSymmetricDifference($0, b) } , [b,ab,empty,a])
    XCTAssertEqual(range.map { tryFormSymmetricDifference($0, ab) } , [ab,b,a,empty])
    
    // formSubtracting
    XCTAssertEqual(range.map { trySubtract($0, empty) } , [empty,a,b,ab])
    XCTAssertEqual(range.map { trySubtract($0, a) } , [empty,empty,b,b])
    XCTAssertEqual(range.map { trySubtract($0, b) } , [empty,a,empty,a])
    XCTAssertEqual(range.map { trySubtract($0, ab) } , [empty,empty,empty,empty])
  }
  
  //mutating func formUnion(_ other: Multiset<Element>)
  func test_formUnion() {
    var abcd: Multiset = ["A":1, "B":2, "C":3, "D":4]
    let bcde: Multiset = [       "B":1, "C":3, "D":5, "E":7]
    abcd.formUnion(bcde)
    XCTAssertEqual(abcd, Multiset(["A":1, "B":2, "C":3, "D":5, "E":7]))
  }
  
  //mutating func formIntersection(_ other: Multiset<Element>)
  func test_formIntersection() {
    var abcd: Multiset = ["A":1, "B":2, "C":3, "D":4]
    let bcde: Multiset = [       "B":1, "C":3, "D":5, "E":7]
    abcd.formIntersection(bcde)
    XCTAssertEqual(abcd, Multiset(["B":1, "C":3, "D":4]))
  }
  
  //mutating func formSymmetricDifference(_ other: Multiset<Element>)
  func test_formSymmetricDifference() {
    var abcd: Multiset = ["A":1, "B":2, "C":3, "D":4]
    let bcde: Multiset = [       "B":1, "C":3, "D":5, "E":7]
    abcd.formSymmetricDifference(bcde)
    XCTAssertEqual(abcd, Multiset(["A":1, "B":1, "D":1, "E":7]))
  }
  
  //mutating func subtract(_ other: Multiset<Element>)
  func test_subtract() {
    var abcd: Multiset = ["A":1, "B":2, "C":3, "D":4]
    let bcde: Multiset = [       "B":1, "C":3, "D":5, "E":7]
    abcd.subtract(bcde)
    XCTAssertEqual(abcd, Multiset(["A":1, "B":1]))
  }
  
}

//////////////////////////////////////////////////////////////////
/// Algebra Algebra Mutating Sequence

class TestMultiset_G2_algebra_mutating_sequence: XCTestCase {
  
  //mutating func formUnion<S: Sequence>(_ other: S) where S.Element == Element
  func test_formUnion_sequence() {
    var multi = Multiset(["A":1, "B":2])
    multi.formUnion(["A", "A", "B", "C"])
    XCTAssertEqual(multi, Multiset(["A":2, "B":2, "C":1]))
  }
  
  //mutating func formIntersection<S: Sequence>(_ other: S) where S.Element == Element
  func test_formIntersection_sequence() {
    var multi = Multiset(["A":1, "B":2])
    multi.formIntersection(["A", "A", "B", "C"])
    XCTAssertEqual(multi, Multiset(["A":1, "B":1]))
  }
  
  //mutating func formSymmetricDifference<S: Sequence>(_ other: S) where S.Element == Element
  func test_formSymmetricDifference_sequence() {
    var multi = Multiset(["A":1, "B":2])
    multi.formSymmetricDifference(["A", "A", "B", "C"])
    XCTAssertEqual(multi, Multiset(["A":1, "B":1, "C":1]))
  }
  
  //mutating func subtract<S: Sequence>(_ other: S) where S.Element == Element
  func test_subtract_sequence() {
    var multi = Multiset(["A":1, "B":2])
    multi.subtract(["A", "A", "B", "C"])
    XCTAssertEqual(multi, Multiset(["B":1]))
  }
  
}
