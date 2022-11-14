//

import SwiftUI
import PhotosUI.PHPicker

struct ReviewImageView: View {
  @ObservedObject var book: Book
  @Binding var image: Image?
  @State private var showingImagePicker = false
  @State private var showingDeleteImageDialog = false

  var body: some View {
    VStack {
      Divider().padding(.vertical)
      TextField("Micro Review", text: $book.microReview)
      Divider().padding(.vertical)
      
      Book.Image(title: book.title, image: image, cornerRadius: 18)
      
      HStack {
        if image != nil {
          Button("Delete Image") { showingDeleteImageDialog = true }
            .padding(8)
            .background(
              RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 2))
                .foregroundColor(.accentColor)
            )
        }
        PhotoPickerView(image: $image)
      }
      Spacer()
    }
    .confirmationDialog("Delete image for \(book.title)?", isPresented: $showingDeleteImageDialog) {
      Button("Delete", role: .destructive) { image = nil }
    } message: {
      Text("Delete image for \(book.title)?")
    }
  }
}

struct ReviewImage_Previews: PreviewProvider {
    static var previews: some View {
        ReviewImageView(book: Book(), image: .constant(nil))
        .previewDarkLight
    }
}
