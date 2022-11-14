//

import SwiftUI
import PhotosUI.PHPicker

struct PhotoPickerView: View {
  @State private var selectedItem: PhotosPickerItem?
  @Binding var image: Image?
  
  var body: some View {
    
    PhotosPicker(
      selection: $selectedItem,
      matching: .images,
      photoLibrary: .shared()) {
        Text("Update Image")
          .padding(8)
          .background(
            RoundedRectangle(cornerRadius: 12)
              .strokeBorder(style: StrokeStyle(lineWidth: 2))
          )
      }
      .onChange(of: selectedItem) { newItem in
        Task {
          if let data = try? await newItem?.loadTransferable(type: Data.self) {
            if case let selectedImageData = data,
               let uiImage = UIImage(data: selectedImageData) {
              withAnimation {
                image = Image(uiImage: uiImage)
              }
            }
          }
        }
      }
  }
}


