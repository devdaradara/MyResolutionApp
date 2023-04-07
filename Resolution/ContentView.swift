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
    
    func deletePost(at offsets: IndexSet) {
        for index in offsets {
            let post = posts[index]
            managedObjectContext.delete(post)
        }
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(posts, id: \.self) { post in
                    NavigationLink(destination: DetailView(post: post)) {
                        VStack(alignment: .leading) {
                            Text(post.todayResolution ?? "Unknown Resolution")
                                .font(.headline)
                            Text(post.timestamp ?? Date(), style: .date)
                                .font(.subheadline)
                            if let imageData = post.todayPhoto {
                                Image(uiImage: UIImage(data: imageData)!)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                }
                .onDelete(perform: deletePost)
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
