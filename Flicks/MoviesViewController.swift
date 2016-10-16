//
//  MoviesViewController.swift
//  Flicks
//
//  Created by YINYEE LAI on 10/14/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import AFNetworking


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    
    
    var movies: [NSDictionary]?
    let rootUrl: String = "https://api.themoviedb.org/3/movie/"
    let endPoint: String = "now_playing"
    let apiKey: String = "a07e22bc18f5cb106bfe4cc1f83ad8ed"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        let url = URL(string:"\(rootUrl)\(endPoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.movieTableView.reloadData()
                }
            }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieViewCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        
        cell.titleLabel.text = title
        cell.overViewLabel.text = overview
        
        
        
        
        if let posterURL = movie["poster_path"] as? String {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let imageURL = URL(string: baseURL + posterURL)
            cell.posterImageView.setImageWith(imageURL!)
        } else {
            //set blank image?
        }
        
        
        return cell
    }


}

