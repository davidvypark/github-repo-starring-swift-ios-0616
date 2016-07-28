//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
	
	let store = ReposDataStore.sharedInstance
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let url = NSURL(string: URLString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
	
	//get = see if it's starred
	//put = puts in a star
	//delete = removes the star
	
	class func checkIfRespositoryIsStarred(fullName: String, completion:(Bool) -> ()) {
		let url = NSURL(string: "\(githubAPIURL)/user/starred/\(fullName)")
		let session = NSURLSession.sharedSession()
		
		guard let unwrappedURL = url else {fatalError("Invalid URL") }
		let request = NSMutableURLRequest(URL: unwrappedURL)
		request.HTTPMethod = "GET"											//GET method to see if its starred
		request.addValue(githubAccessToken, forHTTPHeaderField: "Authorization")
		
		let task = session.dataTaskWithRequest(request) { (data, response, error) in
			
			guard let responseValue = response as? NSHTTPURLResponse else {
				assertionFailure("DID NOT WORK")
				return
			}
			
			if responseValue.statusCode == 204 {					//204: NO CONTENT
				completion(true)
			} else if responseValue.statusCode == 404 {				//404: NOT FOUND
				completion(false)
			} else {
				print ("Other status code \(responseValue.statusCode)")
			}
			
			print(data)					//print statements just to check what you are getting
			print(response)
			print(error)
		}
		task.resume()
	}

	class func starRepository(fullName: String, completion: () -> ()) {
		let url = NSURL(string: "\(githubAPIURL)/user/starred/\(fullName)")
		let session = NSURLSession.sharedSession()
		
		guard let unwrappedURL = url else {fatalError("Invalid URL") }
		let request = NSMutableURLRequest(URL: unwrappedURL)
		request.HTTPMethod = "PUT"											//PUT puts in a star
		request.addValue(githubAccessToken, forHTTPHeaderField: "Authorization")
		
		let task = session.dataTaskWithRequest(request) { (data, response, error) in
			
			guard let responseValue = response as? NSHTTPURLResponse else {
				assertionFailure("DID NOT WORK")
				return
			}
			
			if responseValue.statusCode == 204 {
				completion()
			} else {
				print("error")
			}
			
			
		}
		task.resume()
		
	}
	
	class func unStarRepository(fullName: String, completion: () -> ()) {
		let url = NSURL(string: "\(githubAPIURL)/user/starred/\(fullName)")
		let session = NSURLSession.sharedSession()
		
		guard let unwrappedURL = url else {fatalError("Invalid URL") }
		let request = NSMutableURLRequest(URL: unwrappedURL)
		request.HTTPMethod = "Delete"											//PUT puts in a star
		request.addValue(githubAccessToken, forHTTPHeaderField: "Authorization")
		
		let task = session.dataTaskWithRequest(request) { (data, response, error) in
			
			guard let responseValue = response as? NSHTTPURLResponse else {
				assertionFailure("DID NOT WORK")
				return
			}
			
			if responseValue.statusCode == 204 {
				completion()
			} else {
				print("error")
			}
			
			
		}
		task.resume()
		
	}
	
}

