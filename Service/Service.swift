//
//  Service.swift
//  Celo test
//
//  Created by Raj Patel on 16/04/20.
//  Copyright © 2020 Raj Patel. All rights reserved.
//

import Foundation

struct Service {
    
    //Singleton
    public static let shared = Service()
    
    func getUsers(with resultSize: Int, completion: @escaping (_ users: [User]?, _ error: Error?) -> ()) {
        if let url = URL(string: "\(peopleUrl)\(resultSize)") {
            let task = _session.dataTask(with: url, completionHandler:  { data, response, error in
                if response is HTTPURLResponse,
                (response as! HTTPURLResponse).statusCode == 200,
                    let data = data {
                    do {
                        let result = try JSONDecoder().decode(UsersResult.self, from: data)
                        completion(result.results, error)
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    print(error.debugDescription)
                    print(response.debugDescription)
                    completion(nil, error)
                }
            })
            task.resume()
        }
    }
    
    private let _session = URLSession.shared
    //inc param is hardcoded :(, can improve this. Its passed to reduce the payload size to exactly what I needed.
    private let peopleUrl = "https://randomuser.me/api/?inc=gender,name,picture,cell,email,location,dob&results="
}
