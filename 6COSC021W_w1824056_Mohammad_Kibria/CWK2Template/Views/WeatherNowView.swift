//
//  WeatherNowView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherNowView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State private var isLoading = false
    @State private var temporaryCity = ""
    var body: some View {
        
        VStack{
            HStack{
                Text("Change Location")
                
                TextField("Enter New Location", text: $temporaryCity)
                    .onSubmit {
                        weatherMapViewModel.city = temporaryCity// assignt he city entered to the datamodel
                        Task {
                            do {
                                try await weatherMapViewModel.getCoordinatesForCity()//go the the function to get coords
                                let weatherData = try await weatherMapViewModel.loadData(lat: weatherMapViewModel.coordinates?.latitude ?? 51.503300, lon: weatherMapViewModel.coordinates?.longitude ?? -0.079400)//assign the coords to the datamodel
                                print("Weather data loaded: \(String(describing: weatherData.timezone))")
                            } catch {
                                print("Error: \(error)")
                                isLoading = false
                            }
                        }
                    }
            }
            .bold()
            .font(.system(size: 20))
            .padding(10)
            .shadow(color: .blue, radius: 10)
            .cornerRadius(10)
            .fixedSize()
            .font(.custom("Arial", size: 26))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .cornerRadius(15)
            
            VStack{
                HStack{
                    Text("Current Location: \(weatherMapViewModel.city)")
                }
                .bold()
                .font(.system(size: 20))
                .padding(10)
                .shadow(color: .blue, radius: 10)
                .cornerRadius(10)
                .fixedSize()
                .font(.custom("Arial", size: 26))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(15)
                let timestamp = TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0)
                
                let formattedDate = DateFormatterUtils.formattedDateTime(from: timestamp)
                Text(formattedDate)
                    .padding()
                    .font(.title)
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 1)
            }
            
            
            VStack{
                
                HStack{
                    // Weather Forecast Value
                    if let currentWeather = weatherMapViewModel.weatherDataModel?.current,//CHeck if there is something in current, if ther eis put in variabnle
                       let currentIcon = currentWeather.weather.first?.icon,//current icon check if there is anything in the current icon, if there is then put it in variable, also the .first? just ckecks the first value as there can only be one current, the .first? is alsothe only value
                       let weatherDescription = currentWeather.weather.first?.weatherDescription.rawValue {
                        Label{
                            Text((weatherDescription.capitalized))
                                .font(.system(size: 25, weight: .medium))
                        } icon: {
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(currentIcon)@2x.png"))
                                .frame(width: 40.0, height: 40.0)
                                .padding()
                        }

                    } else {
                        Text("N/A")
                            .frame(width: 40.0, height: 40.0)
                    }
                }
                
                HStack{
                    // Weather Temperature Value
                    if let forecast = weatherMapViewModel.weatherDataModel {
                        Label{
                            Text("Temp: \((Double)(forecast.current.temp), specifier: "%.2f") ºC")
                                .font(.system(size: 25, weight: .medium))
                        } icon: {
                            Image("temperature")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                        }
                    } else {
                        Label{
                            Text("Temp: N/A")
                                .font(.system(size: 25, weight: .medium))
                        } icon: {
                            Image("temperature")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                            
                        }
                    }
                }
                
                HStack{
                    if let forecast = weatherMapViewModel.weatherDataModel {
                        Label{
                            Text("Humidity: \((Int)(forecast.current.humidity)) %")
                                .font(.system(size: 25, weight: .medium))
                        } icon: {
                            Image("humidity")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                        }
                    } else {
                        Label{
                            Text("Humidity: N/A")
                                .font(.system(size: 25, weight: .medium))
                        } icon: {
                            Image("humidity")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                        }
                    }
                }
                
                HStack{
                    if let forecast = weatherMapViewModel.weatherDataModel {
                        Label{
                            Text("Pressure: \((Int)(forecast.current.pressure))")
                                .font(.system(size: 25, weight: .medium))
                        } icon: {
                            Image("pressure")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                        }
                    } else {
                        Label{
                            Text("Pressure: N/A")
                                .font(.system(size: 25, weight: .medium))
                        } icon: {
                            Image("pressure")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                        }
                    }
                }
                
                HStack{
                    if let forecast = weatherMapViewModel.weatherDataModel {
                        Label{
                            Text("WindSpeed: \((Int)(forecast.current.windSpeed))")
                                .font(.system(size: 25, weight: .medium))
                        } icon: {
                            Image("windSpeed")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                        }
                    } else {
                        Label{
                            Text("WindSpeed: N/A")
                                .font(.system(size: 25, weight: .medium))
                        } icon: {
                            Image("windSpeed")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                        }
                    }
                }
                
            }//VS2
        }// VS1
        .background(
            Image("sky")
                .opacity(0.5)
        )
    }
}
struct WeatherNowView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherNowView()
            .environmentObject(WeatherMapViewModel())
        
    }
}
