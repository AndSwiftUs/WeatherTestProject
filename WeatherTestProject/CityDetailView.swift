//
//  CityDetailView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 07.12.2022.
//

import SwiftUI

struct CityDetailView: View {
    
    var city: String
    
    @Environment(\.presentationMode) var presentationMode
    
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
        
        VStack {
            Text("\(temperature)º")
                .font(.system(size: 96, weight: .thin))
            Text("\(weatherDescription)")
                .font(.system(size: 20, weight: .medium))
            
            HStack(alignment: .top) {
                Text("H: \(hTemperature) ")
                Text("L: \(lTemperature)")
            }
            .font(.system(size: 20, weight: .regular))
        }
    }
    
    @ViewBuilder
    var WeatherConditionView: some View {
        VStack {
            
            Text("Здесь должно быть длинное описание погоды")
                .font(.system(size: 17, weight: .regular))
            
            LazyVGrid(columns: [GridItem(), GridItem()], alignment: .leading, spacing: 8) {
                
                Section(header: ExDivider().padding(.horizontal) ) {
                    VStack {
                        Text("SUNRISE")
                            .font(.system(size: 13, weight: .regular))
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(dtToHour(dt: sunRise, format: "HH:MM"))
                            .font(.system(size: 28, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading, 20)
                    
                    VStack {
                        Text("SUNSET")
                            .font(.system(size: 13, weight: .regular))
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(dtToHour(dt: sunSet, format: "HH:MM"))
                            .font(.system(size: 28, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Section(header: ExDivider().padding(.horizontal) ) {
                    VStack {
                        Text("PRESSURE")
                            .font(.system(size: 13, weight: .regular))
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pressure)")
                            .font(.system(size: 28, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading, 20)
                    
                    VStack {
                        Text("HUMIDITY")
                            .font(.system(size: 13, weight: .regular))
                            .opacity(0.5)
                        Text("\(humidity)%")
                            .font(.system(size: 28, weight: .regular))
                    }
                }
                
                Section(header: ExDivider().padding(.horizontal) ) {
                    VStack {
                        Text("WIND")
                            .font(.system(size: 13, weight: .regular))
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(wind) km/h")
                            .font(.system(size: 28, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading, 20)
                    
                    VStack {
                        Text("FEEL LIKE")
                            .font(.system(size: 13, weight: .regular))
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(feelLike)º")
                            .font(.system(size: 28, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "3F84DD")
                .ignoresSafeArea()
            
            NavigationStack {
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("IconBack-1a")
                    }
                    Spacer()
                }.padding()
                
                Text("\(city)")
                    .font(.custom("SF Pro Display", fixedSize: 34))
                
                CityDetailHeaderView
                
                ScrollView(showsIndicators: false) {
                    
                    Spacer()
                        .frame(minHeight: 96)
                    
                    ExDivider()
                    
                    HourlyForecastView(city: city)
                    
                    ExDivider()
                    
                    DailyForecastView(city: city)
                    
                    ExDivider()
                    
                    WeatherConditionView
                }
                .navigationBarHidden(true)
            }
        }
        .task {
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
