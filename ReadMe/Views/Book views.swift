//

import SwiftUI

extension Book {
  struct Image: View {
    let title: String
    var size: CGFloat?
    let image: SwiftUI.Image?
    let cornerRadius: CGFloat
    
    var body: some View {
        if let image = image {
          image
            .resizable()
//            .scaledToFit()
            .cornerRadius(cornerRadius)
            .frame(width: size, height: size)
        } else {
          let symbol = SwiftUI.Image(title: title) ??
            .init(systemName: "book")
          
          symbol
            .resizable()
            .font(.title.weight(.light))
            .foregroundColor(.secondary)
            .frame(width: size, height: size)
            .scaledToFit()
        }
      }
  }
}

extension Image {
  init?(title: String) {
    guard let char = title.first,
          case let symboName = "\(char.lowercased()).square",
          UIImage(systemName: symboName) != nil
    else { return nil }
    
    self.init(systemName: symboName)
  }
}

struct TitleAuthor: View {
  let book: Book
  let titleFont: Font
  let authorFornt: Font
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(book.title)
        .font(.title2)
      Text(book.author)
        .font(.title3)
        .foregroundColor(.secondary)
    }
  }
}

extension Book.Image {
  init(title: String) {
    self.init(title: title, image: nil, cornerRadius: .init())
  }
}

extension View {
  var previewDarkLight: some View {
    ForEach(ColorScheme.allCases, id: \.self, content: preferredColorScheme)
  }
}

struct Book_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      TitleAuthor(book: Book(), titleFont: .title, authorFornt: .title2)
      Book.Image(title: Book().title)
      Book.Image(title: "")
      Book.Image(title: "📖")
    }
    .previewDarkLight
    
  }
}
