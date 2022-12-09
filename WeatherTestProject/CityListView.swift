//
//  CityListView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 08.12.2022.
//

import SwiftUI

struct CityListView: View {
    
    var city: String
    
    @ObservedObject private var vmTime = NinjaWorldTimeAPI()
    @ObservedObject private var vmWeather = NinjaWeatherAPI()
    @ObservedObject private var vmOWM = CurrentWeatherDataAPI()
    
    @State private var time = "00:00"
    @State private var picture = "⛄︎"
    @State private var temperature = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(time)").font(.footnote)
                Text(city).font(.title)
            }
            Spacer()
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(picture)@2x.png"))
                .frame(width: 20, height: 20)
            
            Spacer().frame(width: 30)
            Text("\(temperature)º")
                .font(.title)
                .frame(width: 58)
        }
        .task {
            Task {
                time = try await vmTime.whatTimeInCity(name: city)
                (temperature, picture) = try await vmOWM.weatherTemperaturePicture(name: city)
            }
            
        }
    }
}

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView(city: "Minsk")
    }
}
