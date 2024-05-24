//
//  TestView.swift
//  TravelApp
//
//  Created by Agfi on 17/05/24.
//

import SwiftUI

struct TestView: View {
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        ForEach(modelData.hikeData) { hike in
            Text("\(hike.name)")
            
        }
    }
}

#Preview {
    TestView()
}
