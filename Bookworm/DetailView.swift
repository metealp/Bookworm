//
//  DetailView.swift
//  Bookworm
//
//  Created by Mete Alp Kizilcay on 1.11.2020.
//
import CoreData
import SwiftUI

func dateFormating(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    
    return formatter.string(from: date)
}

struct DetailView: View {
    
    @Environment (\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    
    let book: Book
    var body: some View {
        GeometryReader {
            geometry in
            VStack {
                ZStack(alignment: .bottomTrailing, content: {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -10, y: -5)
                })
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(self.book.review ?? "No review")
                    .padding()
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                Text("Added at \(dateFormating(date: self.book.createdAt!))")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(2)
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        
        .alert(isPresented: $showingDeleteAlert) { Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")){
            self.deleteBook()
        }, secondaryButton: .cancel())
        }
        
        .navigationBarItems(trailing: Button(action: {self.showingDeleteAlert = true}, label: {
            Image(systemName: "trash")
        }))
    }
    
    func deleteBook(){
        moc.delete(book)
        
        // try? self.moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType:  .mainQueueConcurrencyType)
    
    static var previews: some View {
        let date = Date()
        
        
        let book = Book(context: moc)
        book.title = "Test Book"
        book.author = "Test Author"
        book.genre = "Fantasy"
        book.rating = 4
        book.createdAt = date
        book.review = "this was a great book; i really enjoyed it"
        return NavigationView {
            
            DetailView(book: book)
        }
    }
}
