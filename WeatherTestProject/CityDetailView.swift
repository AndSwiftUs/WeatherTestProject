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
    @State private var currentWeater = CurrentWeatherModel()
    
    @State private var temperature = 0
    @State private var hTemperature = 0
    @State private var lTemperature = 0
    @State private var weatherDescription = "no description"
    @State private var sunRise = 0
    @State private var sunSet = 0
    @State private var pressure = 0
    @State private var humidity = 0
    @State private var wind = 0
    @State private var feelLike = 0
    
    @ViewBuilder
    var CityDetailHeaderView: some View {
        
        Text("\(city)").font(.title)
        Text("\(temperature)º").font(.largeTitle)
        Text("\(weatherDescription)")
        
        HStack {
            Text("H: \(hTemperature)")
            Text("L: \(lTemperature)")
        }
    }
    
    @ViewBuilder
    var WeatherConditionView: some View {
        VStack {
            Text("Здесь должно быть длинное описание погоды")
            Divider()
            HStack {
                VStack {
                    Text("SUNRISE")
                    Text("\(sunRise)")
                        .font(.title)
                }
                VStack {
                    Text("SUNSET")
                    Text("\(sunSet)")
                        .font(.title)
                }
            }
            Divider()
            HStack {
                VStack {
                    Text("PRESSURE")
                    Text("\(pressure)")
                        .font(.title)
                }
                VStack {
                    Text("HUMIDITY")
                    Text("\(humidity)%")
                        .font(.title)
                }
            }
            Divider()
            HStack {
                VStack {
                    Text("WIND")
                    Text("\(wind) km/h")
                        .font(.title)
                }
                VStack {
                    Text("FEEL LIKE")
                    Text("\(feelLike)º")
                        .font(.title)
                }
            }
            Divider()
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "3F84DD")
                .ignoresSafeArea()
            
            NavigationStack {
                
                ScrollView {
                    LazyVGrid(columns: [GridItem()]) {
                        CityDetailHeaderView
                        Divider()
                        HourlyForecastView(city: city)
                        Divider()
                        DailyForecastView(city: city)
                        Divider()
                        WeatherConditionView
                    }
                }
                //                .navigationTitle("")
                //                .preferredColorScheme(.light)
            }
        }
        .onAppear {
            Task {
                currentWeater = try await vmOWM.currentWeather(name: city)
                temperature = lround((currentWeater.main?.temp)!)
                hTemperature = lround((currentWeater.main?.tempMax)!)
                lTemperature = lround((currentWeater.main?.tempMin)!)
                weatherDescription = (currentWeater.weather?.first?.weatherDescription)!
                sunRise = (currentWeater.sys?.sunrise)!
                sunSet = (currentWeater.sys?.sunset)!
                pressure = (currentWeater.main?.pressure)!
                humidity = (currentWeater.main?.humidity)!
                wind = lround((currentWeater.wind?.speed)!)
                feelLike = lround((currentWeater.main?.feelsLike)!)
            }
        }
    }
    
}


struct CityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CityDetailView(city: "Warsaw")
    }
}
