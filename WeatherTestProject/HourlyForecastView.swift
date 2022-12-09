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
        
        VStack(spacing: 10) {
            if time != nil {
                Text(dtToHour(dt: time!, format: "HHa")).font(.caption)
            } else {
                Text("Now").font(.caption)
            }
            
            // пока для разработки просто картинка, чтобы не нагружать API
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"))
                .scaledToFit()
                .frame(width: 40, height: 40)
            //            Image("10n")
            Text("\(lround(degree))º").font(.title)
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
            }
        }
        .scrollIndicators(.hidden)
        .task {
            Task {
                try await self.vmOWM.reload(name: city)
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
