//
//  ContentView.swift
//  FixConvNum
//
//  Created by ezen on 30/11/2024.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
		NavigationStack {
			HomeView(vm: HomeViewModel())			
		}
    }
}

#Preview {
    ContentView()
}
