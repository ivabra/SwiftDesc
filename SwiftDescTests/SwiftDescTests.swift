import XCTest
import Foundation
@testable import SwiftDesc

class SwiftObjectDescriberTests: XCTestCase {

  let describer = ObjectDescriber(options: .init(showTypes: false,
                                                 separator: ": ",
                                                 dictionarySeparator: ": ",
                                                 enumSeparator: ": ",
                                                 classSeparator: ": ",
                                                 turpleSeparator: ": "))
  func testSimpleStruct() {
    let aStruct = MyStruct(name: "Ivan",
                           age: 10,
                           vk: URL(string: "https://vk.com/id13123213")!)
    let description = describer.describe(aStruct)
    let expected = """
    MyStruct(
     name: "Ivan",
     age: 10,
     vk: URL(string: "https://vk.com/id13123213")
    )
    """
    XCTAssertEqual(description, expected)
  }

}

private struct MyStruct {
  var name: String
  var age: Int
  var vk: URL
}
