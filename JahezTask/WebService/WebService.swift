//
//  WebService.swift
//  JahezTask
//
//  Created by Satham Hussain on 1/25/22.
//

import Foundation
class WebService{
    static func fetchRestaurants(completionHandler: @escaping ([Restaurant]) -> Void) {
        let url = URL(string: "https://jahez-other-oniiphi8.s3.eu-central-1.amazonaws.com/restaurants.json")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print("Error with the response, unexpected status code: \(response)")
                      return
                  }
            if let data = data,
               let restaurants = try? JSONDecoder().decode([Restaurant].self, from: data) {
                completionHandler(restaurants)
            }
        })
        task.resume()
    }
}
