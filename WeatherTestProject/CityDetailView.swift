//
//  CityDetailView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import SwiftUI

struct CityDetailView: View {
    
    var city: String
    
    @ObservedObject private var vmOWM = CurrentWeatherDataAPI()
    
    @State private var temperature = 0
    @State private var hTemperature = 0
    @State private var lTemperature = 0
    @State private var weatherDescription = "no description"
    
    @ViewBuilder
    var HeaderView: some View {
        Text("\(city)").font(.title)
        Text("\(temperature)º").font(.largeTitle)
        Text("\(weatherDescription)")
    }
    
    @ViewBuilder
    var HourlyForecastView: some View {
        Text("HourlyForecastView")
    }
    
    @ViewBuilder
    var DailyForecastView: some View {
        Text("DailyForecastView")
    }
    
    @ViewBuilder
    var WeatherConditionView: some View {
        Text("WeatherConditionView")
    }
    
    var body: some View {
        ZStack {
            Color(hex: "3F84DD")
                .ignoresSafeArea()
            
            NavigationStack {
                
                ScrollView {
                    LazyVGrid(columns: [GridItem()]) {
                        HeaderView
                        HStack {
                            Text("H: \(hTemperature)")
                            Text("L: \(lTemperature)")
                        }
                        Spacer()
                        Divider()
                        HourlyForecastView
                        Divider()
                        DailyForecastView
                        Divider()
                        WeatherConditionView
                    }
                }
//                .navigationTitle("")
//                .preferredColorScheme(.light)
            }
        }
    }
    
}


struct CityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CityDetailView(city: "Minsk")
    }
}
