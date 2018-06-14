extension String {

  func withNewLinePadding(size: Int) -> String {
    let padding = repeatElement(" ", count: size).joined()
    let result: String = self.map { character in
      character == "\n" ? String(character) + padding : String(character)
      }.joined()
    return result
  }

}
