//
//  DailyForecastView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 08.12.2022.
//

import SwiftUI

struct DailyForecastView: View {
    
    var city: String
    
    var body: some View {
        
        ScrollView(.vertical) {
            
            LazyVStack(spacing: 20) {
                ForEach(0 ..< 6) { item in
                    Image(systemName: "\(item).circle")
                        .font(.title)
                }
            }
        }
    }
}

struct DailyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastView(city: "Minsk")
    }
}
