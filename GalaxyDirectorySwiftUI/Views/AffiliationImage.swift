//
//  AffiliationImage.swift
//  GalaxyDirectorySwiftUI
//
//  Created by Gabe Guerrero on 8/23/22.
//

import SwiftUI

struct AffiliationImage: View {

    enum Affiliation {
        case firstOrder
        case jedi
        case resistance
        case sith
        case unknown

        init(affiliation: String) {
            switch affiliation {
            case "FIRST ORDER":
                self = .firstOrder
            case "JEDI":
                self = .jedi
            case "RESISTANCE":
                self = .resistance
            case "SITH":
                self = .sith
            default:
                self = .unknown
            }
        }
    }

    var affiliation: Affiliation

    var body: some View {
        selectImage()
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.gray, lineWidth: 4.0)
                    .frame(width: 90, height: 90)
            )
            .background(
                Circle()
                    .fill(Color.white)
                    .frame(width: 90, height: 90)
            )
    }

    private func selectImage() -> Image {
        switch affiliation {
        case .firstOrder:
            return Image("firstorder")
        case .jedi:
            return Image("jedi")
        case .resistance:
            return Image("resistance")
        case .sith:
            return Image("sith")
        case .unknown:
            return Image(systemName: "questionmark")
        }
    }
}

struct AffiliationImage_Previews: PreviewProvider {
    static var previews: some View {
        AffiliationImage(affiliation: .resistance)
    }
}
