//
//  TouristPlacesMapView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct TouristPlacesMapView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State var locations: [Location] = []
    
    
    var filteredLocations: [Location] {//orders the locations
        locations.filter { $0.cityName == weatherMapViewModel.city }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                
                VStack{
                    //set the coords of the map to the currently entered city, else have the default coords be london
                    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: weatherMapViewModel.coordinates?.latitude ?? 51.503300, longitude: weatherMapViewModel.coordinates?.longitude ?? -0.09), latitudinalMeters: 5000, longitudinalMeters: 10000)
                    Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: filteredLocations) { location in//create map using the entered coords
                        MapAnnotation(coordinate: location.coordinates) {// pins for the map, from the location coords
                            VStack {
                                Image(systemName: "mappin.circle.fill")// the map pins
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    VStack{
                        Text("Tourist Attractions in \(weatherMapViewModel.city)")
                            .font(.title2)
                    }
                }
                
                List(filteredLocations, id: \.id) { location in//displays all the locations from the list
                    
                    VStack(alignment: .leading) {
                        HStack{
                            Image(location.imageNames.last ?? "defaultImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            Text(location.name)
                                .font(.headline)
                        }
                        Divider()//divider
                    }
                }
            }
            .frame(height:700)
            .padding()
        }
        .onAppear {
            // Loads the tourist places
            if let url = Bundle.main.url(forResource: "places", withExtension: "json"){// find the placecs.json file
                do {
                    let data = try Data(contentsOf: url)//try to load the file into a variable
                    let decoder = JSONDecoder()// assign the JSONDecoder into a varaible
                    // If coordinates are stored as latitude and longitude in the JSON file
                    decoder.userInfo[CodingUserInfoKey(rawValue: "coordinates")!] = CLLocationCoordinate2D.self
                    //using the decoder, get the coords fro an entered location and store them
                    //decode using the coding key 'coordinates', the CLL translates the read coords to its own self
                    self.locations = try decoder.decode([Location].self, from: data)// try to put the coords into a variable
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else {
                print("Places JSON file not found")
                return
            }
        }
    }
}

struct TouristPlacesMapView_Previews: PreviewProvider {
    static var previews: some View {
        TouristPlacesMapView().environmentObject(WeatherMapViewModel())
    }
}
