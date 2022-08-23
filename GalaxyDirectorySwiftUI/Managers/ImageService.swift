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

    var data = Date()

    private var image = Image("person")

    func getImage(for person: Person) -> Image {
        return image
    }

    func loadImage(for person: Person) {
        let persistenceController = PersistenceController.shared
        persistenceController.fetchImageFromStore(for: Int(person.id)) { result in
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }

            switch result {
            case .success(let image):
                guard let imageData = image?.storedImage,
                      let image = UIImage(data: imageData) else {
                    fetchImage(for: person)
                    return
                }
                self.image = Image(uiImage: image)
            case .failure(let error):
                print("Error checking store for image\(error)")
            }


        }
    }

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
                    self.image = Image(uiImage: uiImage)
                }
            }
        }
    }
}
