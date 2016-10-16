//
//  MoviesViewController.swift
//  Flicks
//
//  Created by YINYEE LAI on 10/14/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    
    
    var movies: [NSDictionary]?
    let rootUrl: String = "https://api.themoviedb.org/3/movie/"
    let endPoint: String = "now_playing"
    let apiKey: String = "a07e22bc18f5cb106bfe4cc1f83ad8ed"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: .valueChanged)
        movieTableView.insertSubview(refreshControl, at: 0)
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        let url = URL(string:"\(rootUrl)\(endPoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.movieTableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
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
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
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
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.movieTableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        });
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = movieTableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        
        detailViewController.movie = movie
        
        
    }
    
//    private let params = ["api-key": "53eb9541b4374660d6f3c0001d6249ca:19:70900879"]
//    private let resourceUrl = "http://api.nytimes.com/svc/topstories/v1/home.json"
//    class func fetchStories(successCallback: ([Story]) -> Void, error: ((NSError?) -> Void)?) {
//        let manager = AFHTTPRequestOperationManager()
//        manager.GET(resourceUrl, parameters: params, success: { (operation ,responseObject) -> Void in
//            if let results = responseObject["results"] as? NSArray {
//                var stories: [Story] = []
//                for result in results as [NSDictionary] {
//                    stories.append(Story(jsonResult: result))
//                }
//                successCallback(stories)
//            }
//            }, failure: { (operation, requestError) -> Void in
//                if let errorCallback = error? {
//                    errorCallback(requestError)
//                }
//        })
//    }


}

