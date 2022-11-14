//

import SwiftUI

struct AddBookView: View {
  @ObservedObject var book = Book(title: "", author: "")
  @State private var image: Image? = nil
  @EnvironmentObject var library: Library
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationView {
      VStack(spacing: 24) {
        TextField("Title", text: $book.title)
        TextField("Author", text: $book.author)
        
        ReviewImageView(book: book, image: $image)
      }
      .padding()
      .navigationTitle("Add New Book")
      .toolbar {
        ToolbarItem(placement: .status) {
          Button("Add to library") {
            library.addNewBook(book, image: image)
            dismiss()
          }
          .disabled([book.title, book.author].contains(where: \.isEmpty))
        }
      }
    }
    
  }
}

struct AddBookView_Previews: PreviewProvider {
  static var previews: some View {
    AddBookView().environmentObject(Library())
  }
}
