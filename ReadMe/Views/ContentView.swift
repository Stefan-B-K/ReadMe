//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var library: Library
  @State private var showingAddBook = false
  
  var body: some View {
    
    NavigationView {
      List {
        Button {
          showingAddBook = true
        } label: {
          Spacer()
          VStack(spacing: 6.0) {
            Image(systemName: "book.circle")
              .font(.system(size: 60))
            Text("Add New Book")
              .font(.title2)
          }
          Spacer()
        }
        .buttonStyle(.borderless)
        .padding(.vertical, 8)
        
        ForEach(Section.allCases, id: \.self, content: {
          SectionView(section: $0)
        })
        
        .listRowSeparator(.visible)
      }
      .navigationTitle("My Library")
      .listStyle(.grouped)
      .toolbar(content: EditButton.init)
      .sheet(isPresented: $showingAddBook, content: AddBookView.init)
    }
  }
}

private struct BookRowView: View {
  @ObservedObject var book: Book
  @EnvironmentObject var library: Library
  
  var body: some View {
    NavigationLink (destination: DetailView(book: book)) {
      HStack {
        Book.Image(title: book.title, size: 80, image: library.images[book], cornerRadius: 12)
          .scaledToFill()
        VStack(alignment: .leading) {
          TitleAuthor(book: book, titleFont: .title2, authorFornt: .title3)
          if !book.microReview.isEmpty {
            Spacer()
            Text(book.microReview)
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
        }
        .lineLimit(1)
        .frame(height: 80)
      }
      .padding(.vertical)
    }
  }
}

private struct SectionView: View {
  let section: Section
  @EnvironmentObject var library: Library
  
  var title: String {
    switch section {
    case .readMe: return "Read Me!"
    case .finished: return "Done with..."
    }
  }
  
  var body: some View {
    if let books = library.sortedBooks[section] {
      SwiftUI.Section {
        ForEach(books) { book in
          BookRowView(book: book)
            .swipeActions(edge: .leading) {
              Button {
                withAnimation {
                  book.toRead.toggle()
                  library.sortBooks()
                }
              } label: {
                Label(book.toRead ? "Done with..." : "Read Me!",
                      systemImage: book.toRead ? "bookmark.slash" : "bookmark"
                )
              }
              .tint(book.toRead ? .secondary : .accentColor)
            }
            .swipeActions(edge: .trailing) {
              Button(role: .destructive) {
                guard let index = books.firstIndex(where: { $0.id == book.id })
                else { return }
                
                withAnimation {
                  library.deleteBooks(atOffsets: .init(integer: index), section: section)
                }
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }
        }
        .onDelete { indexSet in
          library.deleteBooks(atOffsets: indexSet, section: section)
        }
        .onMove { indexSet, newOffset in
          library.moveBooks(oldOffsets: indexSet, newOffset: newOffset, section: section)
        }
        .labelStyle(.iconOnly)
        
      } header: {
        ZStack {
          Image("BookTexture")
            .resizable()
            .scaledToFit()
          Text(title)
            .font(.custom("American Typewriter", size: 24))
            .foregroundColor(.primary)
        }
        .listRowInsets(.init())
      }
      
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(Library())
  }
}



