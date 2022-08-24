//
//  PersonRow.swift
//  GalaxyDirectorySwiftUI (iOS)
//
//  Created by Gabe Guerrero on 8/22/22.
//

import SwiftUI

struct PersonRow: View {
    var person: Person

    var body: some View {
        HStack {
            PersonImage(person: person, imageService: ImageService.shared, image: Image("person"))
                .frame(width: 70, height: 70)
            Text(person.firstName ?? "")
            Text(person.lastName ?? "")

            Spacer()
        }
    }
}

struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {

        let context = PersistenceController.preview.container.viewContext
        PersonRow(person: Person(context: context))
            .environment(\.managedObjectContext, context)
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
