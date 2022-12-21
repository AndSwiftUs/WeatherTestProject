//
//  CityListView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 08.12.2022.
//

import SwiftUI

struct CityListView: View {
    
    var city: String
    
    @AppStorage("cityNameByLocation") var cityNameByLocation: String = "My location"
    @AppStorage("isAccessToLocation") var isAccessToLocation: Bool = false
    
    @ObservedObject private var vmOWM = CurrentWeatherDataAPI()
    
    @State private var time = ""
    @State private var picture = "⛄︎"
    @State private var temperature = 0
    
    
    var body: some View {
        
        switch city {
        case "My location":
            if isAccessToLocation {
                HStack {
                    VStack(alignment: .leading) {
                        Text(cityNameByLocation)
                            .font(.system(size: 15, weight: .regular))
                        Text(city)
                            .font(.system(size: 25, weight: .medium))
                    }
                    Spacer()
                    
                    //                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(picture)@2x.png"))
                    imageFromIconA(icon: picture)
                        .frame(maxWidth: 60)
                    
                    Text("\(temperature)º")
                        .font(.system(size: 50, weight: .thin))
                        .frame(maxWidth: 96, alignment: .trailing)
                }
                .task {
                    Task {
                        (temperature, picture, time) = try await vmOWM.weatherTemperaturePictureTimeZone(name: cityNameByLocation)
                    }
                }
            } else {
                VStack(alignment: .leading) {
                    Text("No access to")
                        .font(.system(size: 15, weight: .regular))
                    Text(city)
                        .font(.system(size: 25, weight: .medium))
                }
                Spacer()
            }
            
        default:
            HStack {
                VStack(alignment: .leading) {
                    Text(time)
                        .font(.system(size: 15, weight: .regular))
                    Text(city)
                        .font(.system(size: 25, weight: .medium))
                }
                
                Spacer()
                
                //            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(picture)@2x.png"))
                imageFromIconA(icon: picture)
                    .frame(maxWidth: 60)
                
                Text("\(temperature)º")
                    .font(.system(size: 50, weight: .thin))
                    .frame(maxWidth: 96, alignment: .trailing)
            }
            .task {
                Task {
                    (temperature, picture, time) = try await vmOWM.weatherTemperaturePictureTimeZone(name: city)
                }
                
            }
        }
    }
}

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView(city: "My location")
    }
}
