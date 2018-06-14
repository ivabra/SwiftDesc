public protocol SwiftDescStringConvertable {
  func swiftdescDescription(options: ObjectDescriber.Options) -> String
}

public extension SwiftDescStringConvertable {

  func swiftdescDescription(options: ObjectDescriber.Options) -> String {
    return ObjectDescriber.default.describe(self, options: options)
  }

  var swiftdescDescription: String {
    return swiftdescDescription(options: ObjectDescriber.defaultOptions)
  }

}
