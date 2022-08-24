//
//  Persistence.swift
//  GalaxyDirectorySwiftUI
//
//  Created by Gabe Guerrero on 8/22/22.
//

import CoreData


struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GalaxyDirectorySwiftUI")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func personsAreEmpty(completion: ((Result<Bool, Error>) -> Void)) {
        let request = NSFetchRequest<Person>(entityName: "Person")
        checkStore(request: request, completion: completion)
    }

    func fetchImageFromStore(for id: Int, completion: ((Result<ProfileImage?, Error>) -> Void)) {
        let request = NSFetchRequest<ProfileImage>(entityName: "ProfileImage")
        do {
            let image = try container.viewContext.fetch(request)
            completion(.success(image.first { $0.id == id }))
        } catch {
            completion(.failure(error))
        }
    }

    private func checkStore<T>(request: NSFetchRequest<T>, completion: (Result<Bool, Error>) -> Void) {
        do {
            let empty = try container.viewContext.fetch(request).isEmpty
            completion(.success(empty))
        } catch {
            completion(.failure(error))
        }
    }
}


extension PersistenceController {

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let person = Person(context: viewContext)
        person.id = 1
        person.firstName = "Luke"
        person.lastName = "Skywalker"
        person.birthdate = Date()
        person.profilePicture = "https://edge.ldscdn.org/mobile/interview/07.png"
        person.forceSensitive = true
        person.affiliation = "JEDI"

        let person2 = Person(context: viewContext)
        person2.id = 2
        person2.firstName = "Leia"
        person2.lastName = "Organa"
        person2.birthdate = Date()
        person2.profilePicture = "https://edge.ldscdn.org/mobile/interview/06.png"
        person2.forceSensitive = true
        person2.affiliation = "RESISTANCE"

        let person3 = Person(context: viewContext)
        person3.id = 3
        person3.firstName = "Han"
        person3.lastName = "Solo"
        person3.birthdate = Date()
        person3.profilePicture = "https://edge.ldscdn.org/mobile/interview/04.png"
        person3.forceSensitive = false
        person3.affiliation = "RESISTANCE"

        let person4 = Person(context: viewContext)
        person4.id = 4
        person4.firstName = "Chewbacca"
        person4.lastName = ""
        person4.birthdate = Date()
        person4.profilePicture = "https://edge.ldscdn.org/mobile/interview/01.png"
        person4.forceSensitive = false
        person4.affiliation = "RESISTANCE"

        let person5 = Person(context: viewContext)
        person5.id = 5
        person5.firstName = "Kylo"
        person5.lastName = "Ren"
        person5.birthdate = Date()
        person5.profilePicture = "https://edge.ldscdn.org/mobile/interview/05.jpg"
        person5.forceSensitive = true
        person5.affiliation = "FIRST_ORDER"

        let person6 = Person(context: viewContext)
        person6.id = 6
        person6.firstName = "Supreme Leader"
        person6.lastName = "Snoke"
        person6.birthdate = Date()
        person6.profilePicture = "https://edge.ldscdn.org/mobile/interview/08.jpg"
        person6.forceSensitive = true
        person6.affiliation = "FIRST_ORDER"

        let person7 = Person(context: viewContext)
        person7.id = 7
        person7.firstName = "General"
        person7.lastName = "Hux"
        person7.birthdate = Date()
        person7.profilePicture = "https://edge.ldscdn.org/mobile/interview/03.png"
        person7.forceSensitive = true
        person7.affiliation = "FIRST_ORDER"

        let person8 = Person(context: viewContext)
        person8.id = 8
        person8.firstName = "Darth"
        person8.lastName = "Vader"
        person8.birthdate = Date()
        person8.profilePicture = "https://edge.ldscdn.org/mobile/interview/02.jpg"
        person8.forceSensitive = true
        person8.affiliation = "SITH"

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

}
