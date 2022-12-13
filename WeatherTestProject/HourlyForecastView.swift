//
//  HourlyForecastView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 08.12.2022.
//
import Foundation
import SwiftUI

struct TimeView: View {
    
    var time: Int?
    var icon: String
    var degree: Double
    
    var body: some View {
        
        VStack(spacing: 8) {
            if time != nil {
                Text(dtToHour(dt: time!, format: "HHa"))
                    .font(.system(size: 15, weight: .semibold))
            } else {
                Text("Now")
                    .font(.system(size: 15, weight: .semibold))
            }
            
            imageFromIconB(icon: icon)
            
            Text("\(lround(degree))º")
                .font(.system(size: 20, weight: .medium))
        }
    }
}

struct HourlyForecastView: View {
    
    var city: String
    
    @StateObject private var vmOWM = FiveDayForecastAPI()
    
    var body: some View {
        
        ScrollView(.horizontal) {
            
            LazyHStack(spacing: 20) {
                ForEach(vmOWM.buffer.prefix(24)) { item in
                    TimeView(time: item.dt,
                             icon: (item.weather?.first?.icon)!,
                             degree: (item.main?.temp)!
                    )
                }
            }.padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
        .task {
            Task {
                try await self.vmOWM.reloadFiveDayForecasBuffer(name: city)
                self.vmOWM.buffer[0].dt = nil // nil == "Now"
            }
        }
    }
}

struct HourlyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecastView(city: "Minsk")
    }
}
