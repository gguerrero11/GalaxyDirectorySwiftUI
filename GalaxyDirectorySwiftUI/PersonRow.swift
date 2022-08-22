//
//  PersonRow.swift
//  GalaxyDirectorySwiftUI (iOS)
//
//  Created by Gabe Guerrero on 8/22/22.
//

import SwiftUI

struct PersonRow: View {
    var body: some View {
        HStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 50, height: 50)
            Text("Person")

            Spacer()
        }
    }
}

struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {
        PersonRow()
    }
}