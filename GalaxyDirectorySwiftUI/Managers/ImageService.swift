//
//  ImageService.swift
//  GalaxyDirectorySwiftUI
//
//  Created by Gabe Guerrero on 8/22/22.
//

import Foundation
import SwiftUI

class ImageService: ObservableObject {
    static let shared = ImageService()

    let requestURL = "https://edge.ldscdn.org/mobile/interview/directory"
    let session = URLSession.shared

    /// Loads image from store, if it isn't found, then it will fetch
    func loadImage(for person: Person, completion: ((Image) -> Void)? = nil) {
        let persistenceController = PersistenceController.shared
        persistenceController.fetchImageFromStore(for: Int(person.id)) { result in
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }

            switch result {
            case .success(let image):
                guard let imageData = image?.storedImage,
                      let uiImage = UIImage(data: imageData) else {
                    fetchImage(for: person, completion: completion)
                    return
                }
                completion?(Image(uiImage: uiImage))
            case .failure(let error):
                print("Error checking store for image\(error)")
            }
        }
    }

    /// Fetches image from url and saves it's data into store with associated id
    private func fetchImage(for person: Person, completion: ((Image) -> Void)? = nil) {
        guard let profilePicture = person.profilePicture,
              let imageURL = URL(string: profilePicture) else {
            completion?(Image(systemName: "person"))
            return
        }

        if let data = try? Data (contentsOf: imageURL) {
            let viewContext = PersistenceController.shared.container.viewContext
            let profileImage = ProfileImage(context: viewContext)
            profileImage.id = person.id
            profileImage.storedImage = data

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Error saving image \(nsError), \(nsError.userInfo)")
            }

            if let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion?(Image(uiImage: uiImage))
                }
            }
        }
    }
}
