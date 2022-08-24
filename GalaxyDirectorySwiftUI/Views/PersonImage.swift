//
//  PersonImage.swift
//  GalaxyDirectorySwiftUI
//
//  Created by Gabe Guerrero on 8/22/22.
//

import SwiftUI


struct PersonImage: View {
    var person: Person

    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var imageService: ImageService
    @State var image: Image

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .onAppear(perform: {
                imageService.loadImage(for: person) { image in
                    self.image = image
                }
            })
    }
}

struct PersonImage_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        PersonImage(person: Person(context: context), imageService: ImageService.shared, image: Image("person"))
    }
}
