
import SwiftUI

enum Section: CaseIterable {
  case readMe, finished
}

class Library: ObservableObject {
  
  var sortedBooks: [Section: [Book]] {
    get {
      let groupedBooks = Dictionary(grouping: booksCache, by: \.toRead)
      return Dictionary(uniqueKeysWithValues: groupedBooks.map {
        ($0.key ? .readMe : .finished, $0.value)
      })
    }
    set {
      booksCache = newValue.flatMap { $0.value }
    }
  }
  
  func sortBooks() {
    booksCache = sortedBooks
      .sorted { $1.key == .finished }
      .flatMap { $0.value }
    objectWillChange.send()
  }
  
  func addNewBook(_ book: Book, image: Image?) {
    booksCache.append(book)
    images[book] = image
  }
  
  func deleteBooks(atOffsets offset: IndexSet, section: Section) {
    let booksBeforeDelete = booksCache
    
    sortedBooks[section]?.remove(atOffsets: offset)
    
    for change in booksCache.difference(from: booksBeforeDelete) {
      if case .remove(_, let deletedBook, _) = change {
        images[deletedBook] = nil
      }
    }
  }
  
  func moveBooks(oldOffsets: IndexSet, newOffset: Int, section: Section) {
    sortedBooks[section]?.move(fromOffsets: oldOffsets, toOffset: newOffset)
  }
 
  
  @Published private var booksCache = [
    Book(title: "Ein Neues Land", author: "Shaun Tan"),
    Book(title: "Bosch", author: "Laurinda Dixon"),
    Book(title: "Dare to Lead", author: "Brené Brown"),
    Book(title: "Blasting for Optimum Health Recipe Book", author: "NutriBullet"),
    Book(title: "Drinking with the Saints", author: "Michael P. Foley"),
    Book(title: "A Guide to Tea", author: "Adagio Teas"),
    Book(title: "The Life and Complete Work of Francisco Goya", author: "P. Gassier & J Wilson"),
    Book(title: "Lady Cottington's Pressed Fairy Book", author: "Lady Cottington"),
    Book(title: "How to Draw Cats", author: "Janet Rancan"),
    Book(title: "Drawing People", author: "Barbara Bradley"),
    Book(title: "What to Say When You Talk to Yourself", author: "Shad Helmstetter")
  ]
  
  @Published var images: [Book: Image] = [:]
  
}
