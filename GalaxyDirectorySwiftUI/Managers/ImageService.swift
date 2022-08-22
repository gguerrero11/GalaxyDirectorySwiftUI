//
//  ImageService.swift
//  GalaxyDirectorySwiftUI
//
//  Created by Gabe Guerrero on 8/22/22.
//

import Foundation
import SwiftUI

class ImageService {

    static let shared = DirectoryManager()

    let requestURL = "https://edge.ldscdn.org/mobile/interview/directory"
    let session = URLSession.shared

    func getImage(for person: Person, completion: ((Image) -> Void)) {
        let persistenceController = PersistenceController.shared
        persistenceController.fetchImageFromStore(for: Int(person.id)) { result in
            switch result {
            case .success(let image):
                guard let imageData = image?.storedImage,
                      let image = UIImage(data: imageData) else {
                    fetchImage(for: person, completion: completion)
                    return
                }
                completion(Image(uiImage: image))
            case .failure(let error):
                print("Error checking store for image\(error)")
            }
        }
    }

    private func fetchImage(for person: Person, completion: ((Image) -> Void)) {
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

                    DispatchQueue.main.async {
                        for dict in dictArray {
                            let person = ProfileImage(context: viewContext)
                            person.id = dict["id"] as? Int64 ?? 0
                        }
                        do {
                            try viewContext.save()
                        } catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
