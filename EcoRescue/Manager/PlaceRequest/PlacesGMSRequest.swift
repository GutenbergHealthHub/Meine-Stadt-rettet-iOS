//
//  AnnotationGMSPlacesRequest.swift
//  EcoRescue
//
//  Created by Christoph Erl on 25.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

import GooglePlaces
import CoreLocation

class PlacesGMSRequest: PlacesRequest {
    
    static let BaseUrl = "https://maps.googleapis.com/maps/api/place/" // AIzaSyC_bfCU1S_SpJlOHzWh7pIycWgukTKxaQA
    static let ApiKey  = "AIzaSyC_bfCU1S_SpJlOHzWh7pIycWgukTKxaQA" // "AIzaSyDrKyxDIDKQHzcHOpy3aF5SWWduINoQcic" // "AIzaSyC_bfCU1S_SpJlOHzWh7pIycWgukTKxaQA" //"AIzaSyANMcKiqyGmaumZejnL7HBXAxPXuK6_xQ4" // "AIzaSyB6-hQVTlQQJFcAebYOTvqTosr5T2qv9dQ" //
    
    // Managers
    private let placesClient    = GMSPlacesClient.shared()
    private let locationManager = CLLocationManager()
    
    // Data Task
    private var dataTask:   URLSessionDataTask?
    private let placeType:  PlaceType
    
    init(placeType:  PlaceType) {
        self.placeType = placeType
        super.init()
    }
    
    // MARK: - Public Methods
    
    class func requestPlace(placeId: String, placeType: PlaceType, completion: @escaping (NSObject?, Error?) -> ()) {
        GMSPlacesClient.shared().lookUpPlaceID(placeId) { (gmsPlace, error) in
            if let gmsPlace = gmsPlace {
                let place = Place(place: gmsPlace, type: placeType)
                completion(place, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - Override
    
    override func requestPlaces(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, location: CLLocationCoordinate2D, completion: @escaping ([NSObject]?, Error?) -> ()) {
        dataTask = PlacesGMSRequest.findPlaces(southWest: southWest, northEast: northEast, location: location, type: placeType) { (places, error) in
            if let error = error { print(error) }
            completion(places, error)
        }
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
    // MARK: Private Methods - Network
    
    private static func findPlaces(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, location: CLLocationCoordinate2D, type: PlaceType, completion: @escaping (([Place]?, Error?)->())) -> URLSessionDataTask {
        
        //let location    = CLLocationCoordinate2D(latitude: (southWest.latitude+northEast.latitude)/2, longitude: (southWest.longitude+northEast.longitude)/2)
        let request     = URLRequest(url: PlacesGMSRequest.createNearbySearchUrl(location: location, radius: 5000, type: type.rawValue))
        //let request     = URLRequest(url: PlacesGMSRequest.findBasicPlaces(location: location, radius: 5000, type: type.rawValue))
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    var places = [Place]()
                    if let json = jsonSerialized, let results = json["results"] as? [Dictionary<String, Any>] {
                        for result in results {
                            places.append(Place(dictionary: result, type: type))
                        }
                        DispatchQueue.main.async { completion(places, nil) }
                        
                    } else {
                        DispatchQueue.main.async { completion(nil, error) }
                    }
                }  catch let error as NSError {
                    DispatchQueue.main.async { completion(nil, error) }
                }
            } else if let error = error {
                DispatchQueue.main.async { completion(nil, error) }
                
            }
        }
        
        task.resume()
        return task
    }
    
    private static func createNearbySearchUrl(location: CLLocationCoordinate2D, radius: Double, type: String) -> URL {
        return URL(string: PlacesGMSRequest.BaseUrl + "nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&type=\(type)&key=\(PlacesGMSRequest.ApiKey)")!
    }
    
    private static func findBasicPlaces(location: CLLocationCoordinate2D, radius: Double, type: String) -> URL {
            return URL(string: PlacesGMSRequest.BaseUrl + "findplacefromtext/json?input=\(type)&inputtype=textquery&fields=place_id,formatted_address,name&locationbias=circle:\(radius)@\(location.latitude),\(location.longitude)&key=\(PlacesGMSRequest.ApiKey)")!
    }
    


}
