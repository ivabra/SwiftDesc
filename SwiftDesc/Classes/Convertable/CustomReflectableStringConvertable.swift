public protocol SwiftDescCustomStringConvertable: CustomStringConvertible, SwiftDescStringConvertable {}

public extension SwiftDescCustomStringConvertable {

  public var description: String {
    return swiftdescDescription
  }

}
