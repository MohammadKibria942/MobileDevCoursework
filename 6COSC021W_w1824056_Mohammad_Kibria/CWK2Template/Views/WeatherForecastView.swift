//
//  WeatherForcastView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherForecastView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                    if let hourlyData = weatherMapViewModel.weatherDataModel?.hourly {//check if there is anythign inside the hourly, and assign it to a variable
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 10) {
                                
                                ForEach(hourlyData) { hour in//loop the hourly data and send it to the hourview as current
                                    HourWeatherView(current: hour)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(height: 180)
                    }

                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    VStack {
                        List {
                            ForEach(weatherMapViewModel.weatherDataModel?.daily ?? []) { day in//loop through all the daily and send it as day
                                DailyWeatherView(day: day)
                            }
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))// removes the dividing line 
                        }
                        .listStyle(GroupedListStyle())
                        .frame(height: 500)
                    }
                    .background(Color.gray)
                }
                .background(Color.cyan.opacity(0.4))
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "sun.min.fill")
                        VStack{
                            Text("Weather Forecast for \(weatherMapViewModel.city)").font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        }
    }
}

struct WeatherForcastView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WeatherMapViewModel())
    }
}
