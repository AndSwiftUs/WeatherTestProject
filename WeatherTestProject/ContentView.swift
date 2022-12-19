//
//  ContentView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("cityNameByLocation") var cityNameByLocation: String = "My location"
    @AppStorage("isAccessToLocation") var isAccessToLocation: Bool = false
    
    @StateObject var locationManager = LocationManager()
    var userLatitude: String { "\(locationManager.lastLocation?.coordinate.latitude ?? 0)" }
    var userLongitude: String { "\(locationManager.lastLocation?.coordinate.longitude ?? 0)" }
    
    @State private var searchText = ""
    @State private var cities = defaultCities
    
    @ObservedObject private var vmOWM = CurrentWeatherDataAPI()
    @State private var currentWeater = CurrentWeatherModel()
    
    var body: some View {
        NavigationStack {
            List(cities, id: \.self) { city in
                ZStack(alignment: .leading) {
                    NavigationLink(destination: CityDetailView(city: city)) { EmptyView() }.opacity(0)
                    CityListView(city: city)
                }
                .listRowSeparator(.hidden)
            }
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
            .task {
                Task {
                    currentWeater = try await vmOWM.currentWeatherByLocation(lat: userLatitude, lon: userLongitude)
                    cityNameByLocation = currentWeater.name ?? "\(userLatitude),\(userLongitude)"
                    isAccessToLocation = (locationManager.statusString == "authorizedWhenInUse")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
