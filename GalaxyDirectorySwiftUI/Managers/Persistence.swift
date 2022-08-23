//
//  Persistence.swift
//  GalaxyDirectorySwiftUI
//
//  Created by Gabe Guerrero on 8/22/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<1 {
            let person = Person(context: viewContext)
            person.firstName = "Luke"
            person.lastName = "Skywalker"
            person.birthdate = Date()
            person.profilePicture = "https://edge.ldscdn.org/mobile/interview/07.png"
            person.forceSensitive = true
            person.affiliation = "JEDI"
        }
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

    func checkStore<T>(request: NSFetchRequest<T>, completion: (Result<Bool, Error>) -> Void) {
        do {
            let empty = try container.viewContext.fetch(request).isEmpty
            completion(.success(empty))
        } catch {
            completion(.failure(error))
        }
    }
}
