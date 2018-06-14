public extension CustomStringConvertible {

  func description(padding: Int) -> String {
    return description.withNewLinePadding(size: padding)
  }

}
