//
//  DirectoryFetcher.swift
//  GalaxyDirectorySwiftUI (iOS)
//
//  Created by Gabe Guerrero on 8/22/22.
//

import Foundation


/// Fetches directory from request url
class DirectoryManager {

    static let shared = DirectoryManager()

    let requestURL = "https://edge.ldscdn.org/mobile/interview/directory"
    let session = URLSession.shared

    func fetchDirectoryIfNeeded() {
        let persistenceController = PersistenceController.shared
        persistenceController.personsAreEmpty { result in
            switch result {
            case .success(let empty):
                // If store is empty, then fetch
                guard empty else { return }
                fetchDirectory()
            case .failure(let error):
                print("Error checking store \(error)")
            }
        }
    }

    private func fetchDirectory() {
        let viewContext = PersistenceController.shared.container.viewContext
        let url = URL(string: requestURL)
        let task = session.dataTask(with: url!) { (data, response, error) in

            if error != nil {
                print("Error: \(error.debugDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Bad Request: \(response.debugDescription)")
                return
            }

            if let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: []) {
                if let json = jsonResult as? [String:[[String:Any]]] {
                    guard let dictArray = json["individuals"] else { return }
                    for dict in dictArray {
                        let person = Person(context: viewContext)
                        person.id = dict["id"] as? Int64 ?? 0
                        person.firstName = dict["firstName"] as? String
                        person.lastName = dict["lastName"] as? String
                        person.birthdate = dict["birthdate"] as? Date
                        person.profilePicture = dict["profilePicture"] as? String
                        person.forceSensitive = dict["forceSensitive"] as? Bool ?? false
                        person.affiliation = dict["affiliation"] as? String
                    }
                    DispatchQueue.main.async {
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }
            }
        }
        task.resume()
    }
}
