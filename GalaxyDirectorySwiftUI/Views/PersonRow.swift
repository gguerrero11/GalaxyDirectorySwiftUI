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
            PersonImage(imageService: ImageService.shared, person: person)
                .frame(width: 70, height: 70)
            person.firstName.map(Text.init)
            person.lastName.map(Text.init)

            Spacer()
        }
    }
}

struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        PersonRow(person: Person(context: context))
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
