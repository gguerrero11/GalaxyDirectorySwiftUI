//
//  PersonList.swift
//  GalaxyDirectorySwiftUI
//
//  Created by Gabe Guerrero on 8/23/22.
//

import CoreData
import SwiftUI

struct PersonList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.firstName, ascending: true)],
        animation: .default)
    private var persons: FetchedResults<Person>

    var body: some View {
        NavigationView {
            List {
                ForEach(persons) { person in
                    NavigationLink(
                        destination: PersonDetail(person: person),
                        label: {
                            PersonRow(person: person)
                        })
                }
            }
            .onAppear(perform: DirectoryManager.shared.fetchDirectoryIfNeeded)
            .navigationTitle("Select a person")
        }
    }
}

struct PersonList_Previews: PreviewProvider {
    static var previews: some View {
        PersonList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
