//
//  ContentView.swift
//  Resolution
//
//  Created by 류지예 on 2023/04/01.
//

import SwiftUI
import PhotosUI
import CoreData

struct ContentView: View {
    @State private var text: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Form {
                Section {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                    
                    if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                    }
                }
                
                Section {
                    TextEditorWithPlaceholder(text: $text)
                }
            }
            
            Spacer()
            
            Button("Post") {
                let newPost = Post(context: viewContext)
                newPost.todayResolution = text
                
                if let selectedImageData = selectedImageData {
                    newPost.todayPhoto = selectedImageData
                }
                
                newPost.timestamp = Date()
                
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }

        }
    }
}

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text("오늘의 다짐을 작성해주세요!")
                        .padding(.top, 10)
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            
            VStack {
                TextEditor(text: $text)
                    .frame(minHeight: 150, maxHeight: 300)
                    .opacity(text.isEmpty ? 0.85 : 1)
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
