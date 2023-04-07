//
//  DetailView.swift
//  Resolution
//
//  Created by 류지예 on 2023/04/07.
//

import SwiftUI

struct DetailView: View {
    let post: Post
    @State private var editedResolution: String
    @State private var isEditing = false
    
    init(post: Post) {
        self.post = post
        self._editedResolution = State(wrappedValue: post.todayResolution ?? "")
    }

    var body: some View {
        VStack {
            if let imageData = post.todayPhoto,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }

            if isEditing {
                TextEditor(text: $editedResolution)
                    .padding()
            } else {
                Text(post.todayResolution ?? "")
                    .padding()
            }
        }
        .navigationBarTitle(Text("Detail"))
        .navigationBarItems(trailing:
            Button(isEditing ? "Done" : "Edit") {
                isEditing.toggle()
                if !isEditing {
                    post.todayResolution = editedResolution
                    do {
                        try post.managedObjectContext?.save()
                    } catch {
                        print("Failed to save edited resolution:", error.localizedDescription)
                    }
                }
            }
        )
    }
}
