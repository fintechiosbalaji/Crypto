//
//  File.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24.
//

import SwiftUI

struct ProfileHeaderView: View {
    @State private var showImagePicker = false
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var localFMViewModel = LocalFMViewModel()
    
    var body: some View {
        HStack {
            (localFMViewModel.image.map { Image(uiImage: $0) } ?? Image("profile"))
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .foregroundColor(.gray)
                .onTapGesture {
                    showImagePicker.toggle()
                }
            Text("Balaji")
                .font(.body)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            ZStack {
                Image(systemName: "bell.fill")
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? .orange : .blue)
                Circle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                    .offset(x: 10, y: -10)
                    .overlay(
                        Text("3")
                            .foregroundColor(.white)
                            .font(.caption)
                    )
            }
        }
        .popover(isPresented: $showImagePicker) {
            ImagePickerView(viewModel: localFMViewModel)
                .frame(minWidth: 300, maxHeight: 400)
                .presentationCompactAdaptation(.popover)
                .padding()
        }
        .onAppear {
            localFMViewModel.imageName = "profile.png" // Set the image name
            localFMViewModel.getImageFromeFileManager()
        }
        .padding(.all, 20)
        .primaryBackground()
        .modifier(DarkModeViewModifier())
    }
}

struct ImagePickerView: View {
    
    @ObservedObject var viewModel: LocalFMViewModel
    @Environment(\.dismiss) var dismiss  // Dismiss the sheet after selecting the image
    
    var body: some View {
        VStack {
            // picker
            ImagePicker(isPresented: .constant(true), selectedImage: $viewModel.image)
            
            if let selectedImage = viewModel.image {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .padding()
                // Update profile image with the selected image
                Button("Set Profile Image") {
                    viewModel.saveImage()
                    dismiss()
                }
            }
        }
        .padding(10)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
