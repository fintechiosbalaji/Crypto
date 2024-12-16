//
//  File.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24.
//

import SwiftUI


struct ProfileHeaderView: View {
    
    @State private var profileImage: Image? = Image("profile")  // Default profile image
    @State private var showImagePicker = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            profileImage?
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .foregroundColor(.gray)
                .onTapGesture {
                    showImagePicker.toggle()  // Trigger image picker
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
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(profileImage: $profileImage)
                .frame(maxWidth: .infinity, maxHeight: 400)// Image picker view
        }
        .padding(.all, 20)
        .primaryBackground()
        .modifier(DarkModeViewModifier())
    }
}

struct ImagePickerView: View {
    @Binding var profileImage: Image?  // Bind the profileImage state to update the selected image
    
    @Environment(\.dismiss) var dismiss  // Dismiss the sheet after selecting the image
    
    @State private var selectedUIImage: UIImage?
    
    var body: some View {
        VStack {
            ImagePicker(isPresented: .constant(true), selectedImage: $selectedUIImage)
            
            if let selectedUIImage = selectedUIImage {
                Image(uiImage: selectedUIImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .padding()
                
                // Update profile image with the selected image
                Button("Use this image") {
                    profileImage = Image(uiImage: selectedUIImage)
                    dismiss()
                }
                .padding()
            }
        }
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

// tabbar contentView
struct TabViewItemView: View {
    let title: String
    
    var body: some View {
        Form {
            //
        }
        .listStyle(.insetGrouped)
        .primaryBackground()
        .scrollContentBackground(.hidden)
    }
}
