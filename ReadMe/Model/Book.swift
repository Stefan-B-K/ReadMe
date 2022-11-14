
import Combine

class Book: ObservableObject {
  @Published var title: String
  @Published var author: String
  @Published var microReview: String
  @Published var toRead: Bool
  
  init(title: String = "Title",
       author: String = "Author",
       microReview: String = "",
       toRead: Bool = true) {
    self.title = title
    self.author = author
    self.microReview = microReview
    self.toRead = toRead
  }
}

extension Book: Equatable {
  static func == (lhs: Book, rhs: Book) -> Bool {
    lhs === rhs
  }
}

extension Book: Hashable, Identifiable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
