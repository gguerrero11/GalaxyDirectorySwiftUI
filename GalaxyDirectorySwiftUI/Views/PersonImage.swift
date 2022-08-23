//
//  PersonImage.swift
//  GalaxyDirectorySwiftUI
//
//  Created by Gabe Guerrero on 8/22/22.
//

import SwiftUI

struct PersonImage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var imageService: ImageService

    var person: Person

    var body: some View {
        imageService.getImage(for: person)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .onAppear(perform: {
                imageService.loadImage(for: person)
            })
    }
}

struct PersonImage_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        PersonImage(imageService: ImageService.shared, person: Person(context: context))
    }
}
