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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Post.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Post.timestamp, ascending: false)
    ]) var posts: FetchedResults<Post>
    
    @State private var isEditing = false
    
    let categories = ["학습", "건강", "인간관계", "취미", "여행", "경제", "사회봉사", "도전"]
    let cateogyColor = [Color("myRed"), Color("myOrange"), Color("myYellow"), Color("myGreen"), Color("mySky"), Color("myIndigo"), Color("myPurple"), Color("myPink")]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 10) {
                    ForEach(posts, id: \.self) { post in
                        let categoryIndex = categories.firstIndex(of: post.category ?? "") ?? 0
                        let categoryColor = cateogyColor[categoryIndex % cateogyColor.count]
                        NavigationLink(destination: DetailView(post: post)) {
                            VStack(alignment: .leading) {
                                if let imageData = post.todayPhoto {
                                    Image(uiImage: UIImage(data: imageData)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                } else {
                                    Rectangle()
                                        .foregroundColor(Color.gray)
                                        .frame(height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                }
                                Text(post.todayResolution ?? "Unknown Resolution")
                                    .font(.headline)
                                    .lineLimit(2)
                                    .padding(.top, 5)
                                Text(post.timestamp ?? Date(), style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                            }
                            .padding()
                            .background(categoryColor)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                            .padding(.vertical, 5)
                        }
                    }

                }
            }
            .navigationBarTitle(Text("Posts"))
            .navigationBarItems(trailing:
                NavigationLink(destination: AddPostView()) {
                    Image(systemName: "plus")
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
