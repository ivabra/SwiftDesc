public final class ObjectDescriber {

  public struct Options {
    var showTypes: Bool
    var separator: String
    var dictionarySeparator: String
    var enumSeparator: String
    var classSeparator: String
    var turpleSeparator: String
  }

  public static var defaultOptions = Options(showTypes: false,
                                             separator: ": ",
                                             dictionarySeparator: ": ",
                                             enumSeparator: ": ",
                                             classSeparator: ": ",
                                             turpleSeparator: ": ")

  var options: Options

  init(options: Options = ObjectDescriber.defaultOptions) {
    self.options = options
  }

  public func describe<T>(_ object: T, options: Options? = nil) -> String {
    return extractDescription(for: object, isTopLevelObject: true, options: options ?? self.options)
  }

}

public extension ObjectDescriber {
  static var `default` = ObjectDescriber()
}

private typealias Options = ObjectDescriber.Options

private func extractDescription<T>(for object: T, isTopLevelObject: Bool = false, options: Options) -> String {
  if isTopLevelObject == false, let reflectable = object as? SwiftDescStringConvertable {
    return reflectable.swiftdescDescription(options: options)
  }
  let mirror = Mirror(reflecting: object)
  guard let displayStyle = mirror.displayStyle else {
    return extractValueDescription(from: object, options: options)
  }
  switch displayStyle {
  case .class, .struct:
    return extractClassOrStructRepresentation(from: mirror, options: options)
  case .collection, .set:
    return extractCollectionRepresentation(from: mirror, options: options)
  case .dictionary:
    return extractDictionaryRepresentation(from: mirror, options: options)
  case .enum:
    return extractEnumValue(from: object, options: options)
  case .tuple:
    return extractTurpleRepresentation(from: mirror, options: options)
  case .optional:
    return extractOptioalDescription(from: object, options: options)
  }
}

private func extractClassOrStructRepresentation(from mirror: Mirror, options: Options) -> String {
  let inside = mirror.children.enumerated().map { (offset, child) -> String in
    let label = child.label ?? "[\(offset)]"
    let value = extractDescription(for: child.value, options: options).withNewLinePadding(size: 1)
    if options.showTypes {
      return "\n\(label): \(Mirror(reflecting: child.value).subjectType)\(options.classSeparator)\(value)"
    } else {
      return "\n\(label)\(options.classSeparator)\(value)"
    }
    }.joined(separator: ",")
  return "\(mirror.subjectType)(\(inside.withNewLinePadding(size: 1))\n)"
}

private func extractTurpleRepresentation(from mirror: Mirror, options: Options) -> String {
  let inside = mirror.children.map { (label, value) -> String in
    let label = label ?? "nil"
    let stringValue = extractDescription(for: value, options: options).withNewLinePadding(size: 1)
    if options.showTypes {
      return "\n\(label): \(Mirror(reflecting: value).subjectType)\(options.turpleSeparator)\(stringValue)"
    } else {
      return "\n\(label)\(options.turpleSeparator)\(stringValue)"
    }
    }.joined(separator: ",")
  return "(\(inside.withNewLinePadding(size: 1))\n)"
}

private func extractCollectionRepresentation(from mirror: Mirror, options: Options) -> String {
  let inside = mirror.children
    .map { _, value in extractDescription(for: value, options: options) }
    .joined(separator: ",\n")
  return "[" + "\n\(inside)".withNewLinePadding(size: 1) + "\n]"
}

private func extractDictionaryRepresentation(from mirror: Mirror, options: Options) -> String {
  let inside = mirror.children
    .compactMap { _, value in extractDistionaryTurpleRepresentation(for: value, options: options) }
    .joined(separator: ",\n")
    .withNewLinePadding(size: 1)
  return "[\n\(inside)\n]"
}

private func extractDistionaryTurpleRepresentation<T>(for object: T, options: Options) -> String? {
  let mirror = Mirror(reflecting: object)
  var key: Any?
  var value: Any?
  mirror.children.forEach { label, _value in
    if label == "key" {
      key = _value
    } else if label == "value" {
      value = _value
    }
  }
  if let key = key, let value = value {
    return "\(extractDescription(for: key, options: options))\(options.dictionarySeparator)\(extractDescription(for: value, options: options))"
  } else {
    return nil
  }
}

private func extractValueDescription<T>(from object: T, options: Options) -> String {
  if object is String {
    return "\"\(object)\""
  } else {
    return String(describing: object)
  }
}

private func extractOptioalDescription<T>(from object: T, options: Options) -> String {
  let mirror = Mirror(reflecting: object)
  if let child = mirror.children.first {
    return extractDescription(for: child.value, options: options)
  } else {
    return "nil"
  }
}

private func extractEnumValue<T>(from object: T, options: Options) -> String {
  let mirror = Mirror(reflecting: object)
  if Mirror(reflecting: object).children.isEmpty {
    return String(describing: object)
  } else {
    let inside = mirror.children.map { (label, value) -> String in
      let label = label ?? "nil"
      return "\(label)\(extractDescription(for: value, options: options))"
      }.joined(separator: ",\n")
    return "\(mirror.subjectType).\(inside.withNewLinePadding(size: 1))"
  }
}
