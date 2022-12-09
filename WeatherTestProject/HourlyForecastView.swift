//
//  HourlyForecastView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 08.12.2022.
//
import Foundation
import SwiftUI

struct TimeView: View {
    
    var time: Int
    var icon: String
    var degree: Double
    
    private func dtToHour(dt: Int) -> String {
        let day = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: day)
    }
    
    var body: some View {
        
        VStack {
            Text(dtToHour(dt: time))
            // пока для разработки просто картинка, чтобы не нагружать API
//                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"))
            Image("10n")
            Text("\(lround(degree))º")
        }
    }
}

struct HourlyForecastView: View {
    
    var city: String
    
    @StateObject private var vmOWM = FiveDayForecastAPI()
    @State private var code = "!"
    
    @ViewBuilder
    var NowView: some View {
        Text("\(code)")
            .font(.largeTitle)
    }
    
    var body: some View {
        
        ScrollView(.horizontal) {
            
            LazyHStack(spacing: 20) {
                
                Section(header: NowView) {
                    
                    ForEach(vmOWM.buffer) { item in
                        TimeView(time: item.dt!,
                                 icon: (item.weather?.first?.icon)!,
                                 degree: (item.main?.temp)!
                        )
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .task {
            Task {
                try await self.vmOWM.reload(name: city)
            }
        }
    }
}

struct HourlyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecastView(city: "Minsk")
    }
}
