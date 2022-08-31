//
//  ContentView.swift
//  CurrentLocationExample
//
//  Created by Hoye Lam on 28/08/2022.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            if viewModel.locationStatus == .unknown {
               noPermissionsGivenView
            } else {
                if let region = viewModel.region {
                    Text("I'm here!")
                        .font(.title)
                    
                    Map(
                        coordinateRegion: .constant(region),
                        interactionModes: [],
                        showsUserLocation: true
                    )
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(16)
                } else {
                    Text("Loading up current location")
                }
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .padding()
    }
    
    private var noPermissionsGivenView: some View {
        VStack {
            Text("Location permissions not given")
                .font(.title)
                .multilineTextAlignment(.center)
            
            Button {
                viewModel.onTapRequestPermissions()
            } label: {
                Text("Request permissions again")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
