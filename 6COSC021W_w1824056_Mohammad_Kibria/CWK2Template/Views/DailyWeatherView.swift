//
//  DailyWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct DailyWeatherView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var day: Daily
    
    var body: some View {
        HStack{
            if let weatherIcon = day.weather.first?.icon {
                let iconUrl = "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png"
                AsyncImage(url: URL(string: iconUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45.0, height: 45.0)
                } placeholder: {
                    ProgressView()
                }
            }
            
            VStack{
                if let weatherDescription = day.weather.first?.weatherDescription.rawValue{
                    Text(weatherDescription)
                        .font(.caption)
                    
                    let formattedDate = DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(day.dt))
                    Text(formattedDate)
                        .font(.headline)
                }
            }//end of Vstack
            
            VStack {
                Text("\(day.temp.max, specifier: "%.0f") / \(day.temp.min, specifier: "%.0f")°C")
            }//Vstack End
            .padding(.all)
            
        }//Hstack End
        .padding(.all)//end of HS
        .padding(.horizontal, 40)
        .frame(width: 500.0, height: 100.0)
        .background(
            Image("background")
                .resizable()
                .frame(width: 500.0, height: 100.0)
                .opacity(0.2)
        )
        .background(Color.gray.opacity(0.1))
    }
    
    struct DailyWeatherView_Previews: PreviewProvider {
        static var day = WeatherMapViewModel().weatherDataModel!.daily
        static var previews: some View {
            DailyWeatherView(day: day[0])
        }
    }
}
