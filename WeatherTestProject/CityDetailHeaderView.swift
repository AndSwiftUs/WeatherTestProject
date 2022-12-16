//
//  CityDetailHeaderView.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 14.12.2022.
//

import SwiftUI

struct CityDetailHeaderView: View {
    
    var safeArea: EdgeInsets
    var size: CGSize
    
    var temperature = 0
    var hTemperature = 0
    var lTemperature = 0
    var weatherDescription = "no description"
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
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
        } // end ScrollView
    }
}

//struct CityDetailHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityDetailHeaderView(safeArea: <#EdgeInsets#>, size: <#CGSize#>)
//    }
//}
