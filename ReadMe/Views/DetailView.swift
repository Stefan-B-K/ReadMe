//

import SwiftUI

struct DetailView: View {
  @ObservedObject var book: Book
  @EnvironmentObject var library: Library
  
  var body: some View {
    VStack(alignment: .leading) {
      
      HStack (spacing: 16) {
        Button {
          book.toRead.toggle()
        } label: {
          Image(systemName: book.toRead ? "bookmark.fill" : "bookmark")
            .font(.system(size: 48, weight: .light))
        }

        TitleAuthor(book: book, titleFont: .title, authorFornt: .title2)
      }
      
      ReviewImageView(book: book, image: $library.images[book])
      
      Spacer()
    }
    .padding()
    .onDisappear {
      withAnimation {
        library.sortBooks()
      }
    }
    

  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(book: Book())
      .previewDarkLight
  }
}

