//
//  WeatherMapViewModel.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
class WeatherMapViewModel: ObservableObject {
    // MARK:   published variables/Users/w1824056/Desktop/StarterTemplate/CWK2Template/ViewModels/WeatherMapViewModel.swift
    @Published var weatherDataModel: WeatherDataModel?
    @Published var city = "London"
    @Published var coordinates: CLLocationCoordinate2D? //the latitude and longitute of a location
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()//used to store the region of the location(based on long and lat)
    var hourlyTemperatures: [Double] = []

    init() {//initialise something
        // MARK:  create Task to load London weather data when the app first launches
        Task {//allows running of code concurretley
            print("Entering Task")
            do {
                try await getCoordinatesForCity()//try await means waiting for something to complete
                print("GETTING WEATHER DATA IN")
                let weatherData = try await loadData(lat: coordinates?.latitude ?? 51.503300, lon: coordinates?.longitude ?? -0.079400)
                print("WEATHER DATA")
                print("Weather data loaded: \(String(describing: weatherData.timezone))")
                print("Done")
            } catch {
                // Handle errors if necessary
                print("Error loading weather data: \(error)")
            }
        }
    }
    func getCoordinatesForCity() async throws {
        print("")
        print("INSIDE GET COORDS")
        print("")
        // MARK:  complete the code to get user coordinates for user entered place
        // and specify the map region

        let geocoder = CLGeocoder()
        if let placemarks = try? await geocoder.geocodeAddressString(city),
           let location = placemarks.first?.location?.coordinate {

            
            DispatchQueue.main.async {//THis happens before the other stuff

                self.coordinates = location
                
                print(location)
                self.region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 51.528607, longitudeDelta: -0.4312261))//creates a region  using the long and lat( used to show the map)

            }
        } else {
            // Handle error here if geocoding fails
            print("")
            print("Error: Unable to find the coordinates for the club.")
            print("")
        }
        
        print("STUFF AFFTER ASYNC")
    }
    
    func loadData(lat: Double, lon: Double) async throws -> WeatherDataModel {
        print("")
        print("ENTERING LOAD DATA")
        print("")
        
        // MARK:  add your appid in the url below:
        if let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid="INSERT API KEY HERE"") {
            let session = URLSession(configuration: .default)
            print("URL Done")
            
            do {
                print("DECODING WEATHER DATA")
                let (data, _) = try await session.data(from: url)//Get the data from the url and stro into a vairbale
                let weatherDataModel = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                //using a decoder decode the data and store into the vairable
                //if error check if it can find the values for the keys if not make them
                
                DispatchQueue.main.async {
                    print("")
                    print("ASYNC FOR WEATHER MDOELS")
                    print("")
                    self.weatherDataModel = weatherDataModel
                    print("")
                    print("weatherDataModel loaded")
                    print("")
                }
                
                
                // MARK:  The code below is to help you see number of records and different time stamps that has been retrieved as part of api response.
                
                print("MINUTELY")
                if let count = weatherDataModel.minutely?.count {
                    if let firstTimestamp = weatherDataModel.minutely?[0].dt {
                        let firstDate = Date(timeIntervalSince1970: TimeInterval(firstTimestamp))
                        let formattedFirstDate = DateFormatterUtils.shared.string(from: firstDate)
                        print("First Timestamp: \(formattedFirstDate)")
                    }
                    
                    if let lastTimestamp = weatherDataModel.minutely?[count - 1].dt {
                        let lastDate = Date(timeIntervalSince1970: TimeInterval(lastTimestamp))
                        let formattedLastDate = DateFormatterUtils.shared.string(from: lastDate)
                        print("Last Timestamp: \(formattedLastDate)")
                    }
                } // minute
                
                print("Hourly start")
                
                let hourlyCount = weatherDataModel.hourly.count
                print(hourlyCount)
                if hourlyCount > 0 {
                    let firstTimestamp = weatherDataModel.hourly[0].dt
                    let firstDate = Date(timeIntervalSince1970: TimeInterval(firstTimestamp))
                    let formattedFirstDate = DateFormatterUtils.shared.string(from: firstDate)
                    print("First Hourly Timestamp: \(formattedFirstDate)")
                    print("Temp in first hour: \(weatherDataModel.hourly[0].temp)")
                }
                
                if hourlyCount > 0 {
                    let lastTimestamp = weatherDataModel.hourly[hourlyCount - 1].dt
                    let lastDate = Date(timeIntervalSince1970: TimeInterval(lastTimestamp))
                    let formattedLastDate = DateFormatterUtils.shared.string(from: lastDate)
                    print("Last Hourly Timestamp: \(formattedLastDate)")
                    print("Temp in last hour: \(weatherDataModel.hourly[hourlyCount - 1].temp)")
                }
                
                print("//Hourly Complete")
                
                print("Daily start")
                let dailyCount = weatherDataModel.daily.count
                print(dailyCount)
                
                if dailyCount > 0 {
                    let firstTimestamp = weatherDataModel.daily[0].dt
                    let firstDate = Date(timeIntervalSince1970: TimeInterval(firstTimestamp))
                    let formattedFirstDate = DateFormatterUtils.shared.string(from: firstDate)
                    print("First daily Timestamp: \(formattedFirstDate)")
                    print("Temp for first day: \(weatherDataModel.daily[0].temp)")
                }
                
                if dailyCount > 0 {
                    let firstTimestamp = weatherDataModel.daily[dailyCount-1].dt
                    let firstDate = Date(timeIntervalSince1970: TimeInterval(firstTimestamp))
                    let formattedFirstDate = DateFormatterUtils.shared.string(from: firstDate)
                    print("Last daily Timestamp: \(formattedFirstDate)")
                    print("Temp for last day: \(weatherDataModel.daily[dailyCount-1].temp)")
                }
                print("//daily complete")
                return weatherDataModel
            } catch {
                
                if let decodingError = error as? DecodingError {
                    
                    print("Decoding error: \(decodingError)")
                } else {
                    //  other errors
                    print("Error: \(error)")
                }
                throw error // Re-throw the error to the caller
            }
        } else {
            throw NetworkError.invalidURL
        }
    }
    
    enum NetworkError: Error {
        case invalidURL
    }
    
    
    func loadLocationsFromJSONFile() -> [Location]? {
        if let fileURL = Bundle.main.url(forResource: "places", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let allLocations = try decoder.decode([Location].self, from: data)
                
                return allLocations
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("File not found")
        }
        return nil
    }
}



