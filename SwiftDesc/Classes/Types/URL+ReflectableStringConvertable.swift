import struct Foundation.URL

extension URL: SwiftDescStringConvertable {

  public func swiftdescDescription(options: ObjectDescriber.Options) -> String {
    return "URL(string: \"\(self.absoluteString)\")"
  }

}
