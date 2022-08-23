//
//  PersonDetail.swift
//  GalaxyDirectorySwiftUI
//
//  Created by Gabe Guerrero on 8/23/22.
//

import SwiftUI

struct PersonDetail: View {
    var person: Person

    var body: some View {
        VStack {
//            Text(person.affiliation!)
//            person.affiliation.map(Text.init)
//                font(.headline)

            PersonImage(person: person, imageService: ImageService.shared, image: Image("photo"))
                .frame(width: 300, height: 300)

//            HStack{
//                person.firstName.map(Text.init)
//                person.lastName.map(Text.init)
//            }
//
//            person.birthdate.map { date in
//                Text(date, formatter: itemFormatter)
//            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct PersonDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        PersonDetail(person: Person(context: context))
    }
}
