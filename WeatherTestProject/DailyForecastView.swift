//
//  DailyForecastView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 08.12.2022.
//

import SwiftUI

struct DailyForecastView: View {
    
    var city: String
    
    @AppStorage("cityNameByLocation") var cityNameByLocation: String = "My location"
    @AppStorage("isAccessToLocation") var isAccessToLocation: Bool = false
    
    @StateObject private var vmOWM = FiveDayForecastAPI()
    @State private var fiveDayForecast = FiveDayForecastModel()
        
    var body: some View {
        
        ZStack {
            VStack(spacing: 8) {
                ForEach(fiveDayForecast.buff!) { item in
                    
                    if dtToHour(dt: item.dt!, format: "HH") == "12" {
                        
                        HStack {
                            
                            Text(dtToHour(dt: item.dt!, format: "EEEE"))
                                .font(.system(size: 20, weight: .regular))
                            
                            Spacer()
                            
                            imageFromIconB(icon: item.weather?.first?.icon ?? "bad icon")
                                .frame(maxWidth: 30)
                            
                            Text("\(lround((item.rain?.r3h ?? 0.0)*100), specifier: "%.2d")%")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(hex: "#7CCFF9"))
                                .opacity(((item.rain?.r3h) != nil) ? 1 : 0)
                                .frame(maxWidth: 64, alignment: .leading)
                            
                            HStack {
                                Text("\(lround((item.main?.tempMax)!))º")
                                    .font(.system(size: 20, weight: .medium))
                                    .frame(width: 45, alignment: .trailing)
                                Text("\(lround((item.main?.tempMin)!))º")
                                    .font(.system(size: 20, weight: .medium))
                                    .opacity(0.5)
                                    .frame(width: 45, alignment: .trailing)
                            }
                            .frame(width: 90)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .task {
            Task {
                fiveDayForecast = try await vmOWM.fiveDay3HourForecats(name: city != "My location" ? city : cityNameByLocation)
            }
        }
    }
}

struct DailyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastView(city: "Bucharest")
    }
}
