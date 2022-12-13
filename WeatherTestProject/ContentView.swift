//
//  ContentView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchText = ""
    @State private var cities = defaultCities
    
    var body: some View {
        NavigationStack {
            List(cities, id: \.self) { city in
                ZStack(alignment: .leading) {
                    NavigationLink(destination: CityDetailView(city: city)) { EmptyView() }.opacity(0)
                    CityListView(city: city)
                } //end of ZStack
                .listRowSeparator(.hidden)
            } // end of List
            .listStyle(.plain)
            .navigationTitle("Weather")
            .searchable(text: $searchText, prompt: "City name")
            .onChange(of: searchText) { searchText in
                if !searchText.isEmpty {
                    cities = defaultCities.filter { String($0).contains(searchText) }
                } else {
                    cities = defaultCities
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
