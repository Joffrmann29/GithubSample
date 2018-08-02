//
//  GithubService.swift
//  GIthubSample
//
//  Created by Joffrey Mann on 8/2/18.
//  Copyright © 2018 Joffrey Mann. All rights reserved.
//

import Foundation

class GithubService {
    var githubRepos = [GithubModel]()
    func fetchReposWithURLSession(user: String, results: String, completion: @escaping ([GithubModel]?) -> Void){
        let urlPath = String(format: "https://api.github.com/users/%@/repos?per_page=%@", user, results)
        let url = URL(string: urlPath)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard data != nil && error == nil else {
                let errorDesc = error!.localizedDescription
                print(errorDesc)
                return
            }
            
            do {
                self.githubRepos.removeAll()
                if let jsonArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]] {
                    var licenseName = ""
                    var repoName = ""
                    var descr = ""
                    var created = ""
                    for githubModel in jsonArray{
                        if let name = githubModel["name"] as? String{
                            repoName = name
                        }
                        else{
                            repoName = "No name"
                        }
                        if let desc = githubModel["description"] as? String{
                            descr = desc
                        }
                        else{
                            descr = "No description"
                        }
                        if let createdAt = githubModel["created_at"] as? String{
                            created = createdAt
                        }
                        if let licenseDict = githubModel["license"] as? [String:Any]{
                            licenseName = licenseDict["name"] as! String
                        }
                        else{
                            licenseName = "No license"
                        }
                        
                        let githubObj = GithubModel(name: repoName, desc: descr, createdAt: created, license: licenseName)
                        
                        self.githubRepos.append(githubObj)
                    }
                    DispatchQueue.main.async {
                        completion(self.githubRepos)
                    }
                }
            } catch let parseError as NSError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
