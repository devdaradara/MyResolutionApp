//
//  AddPostView.swift
//  Resolution
//
//  Created by 류지예 on 2023/04/07.
//

import SwiftUI
import PhotosUI
import CoreData

struct AddPostView: View {
    @State private var text: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var selectedCategory = "학습"
    
    let categories = ["학습", "건강", "인간관계", "취미", "여행", "경제", "사회봉사", "도전"]
    let cateogyColor = [Color("myRed"), Color("myOrange"), Color("myYellow"), Color("myGreen"), Color("mySky"), Color("myIndigo"), Color("myPurple"), Color("myPink")]
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Form {
                Section(header: Text("카테고리")) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(cateogyColor[categories.firstIndex(of: selectedCategory) ?? 0])
                                .frame(width: 20, height: 20)
                            Picker("카테고리", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }
                }

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
                newPost.category = selectedCategory
                if let selectedImageData = selectedImageData {
                    newPost.todayPhoto = selectedImageData
                }
                
                newPost.timestamp = Date()
                
                do {
                    try viewContext.save()
                    presentationMode.wrappedValue.dismiss()
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

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
