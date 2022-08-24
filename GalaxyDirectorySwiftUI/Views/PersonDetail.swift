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
        HStack {
            Spacer()

            VStack {
                HStack{
                    Text(person.firstName ?? "")
                    Text(person.lastName ?? "")
                        .bold()
                }
                .font(.largeTitle)

                PersonImage(person: person, imageService: ImageService.shared, image: Image("photo"))
                    .frame(width: 300, height: 300)

                Text(person.affiliation ?? "Unknown")
                    .font(.title)

                Divider()

                VStack {
                    Group {
                        HStack{
                            Text("Birthdate: ")
                            if let birthdate = person.birthdate {
                                Text(birthdate, formatter: itemFormatter)
                            } else {
                                Text("Unknown")
                            }
                            Spacer()
                        }

                        HStack{
                            Text("Force Sensitive: ")
                            Text(person.forceSensitive ? "Yes" : "No")
                            Spacer()
                        }
                    }
                }

            }

            Spacer()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

struct PersonDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        PersonDetail(person: Person(context: context))
    }
}
