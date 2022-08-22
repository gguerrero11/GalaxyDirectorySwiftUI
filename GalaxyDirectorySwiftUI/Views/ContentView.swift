//
//  ContentView.swift
//  GalaxyDirectorySwiftUI
//
//  Created by Gabe Guerrero on 8/22/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
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
                        destination: Text(person.firstName!),
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
