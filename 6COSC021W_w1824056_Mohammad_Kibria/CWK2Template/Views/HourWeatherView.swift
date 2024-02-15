//
//  HourWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct HourWeatherView: View {
    var current: Current
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var body: some View {
        
        let formattedDate = DateFormatterUtils.formattedDateWithDay(from: TimeInterval(current.dt))
        VStack(alignment: .center, spacing: 5) {
            
            //Show all the dates
            Text(formattedDate)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.black)
            
            // Show all weather icons
            if let weatherIcon = current.weather.first?.icon {// checks to see if there is anything inside weather.icon
                let iconUrl = "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png"//gets the icon image from the website
                AsyncImage(url: URL(string: iconUrl)) { image in// displays the image, async used to load from the url and siaply at teh same time
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45.0, height: 45.0).padding()
                } placeholder: {
                    ProgressView()//shows a loading image to show that the images are being laoded
                }
            }
            
            // Show all tepreatures
            Text("\(current.temp, specifier: "%.1f")ºC")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.black)
            
            // Show all the weather descrioptions
            if let description = current.weather.first?.weatherDescription {
                Text(description.rawValue.capitalized)
                    .frame(width: 125)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background(Color.cyan)
        .cornerRadius(20)
    }
}
