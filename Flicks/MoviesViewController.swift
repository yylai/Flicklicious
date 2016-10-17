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
    @IBOutlet weak var errorView: UIView!
    
    
    
    var movies: [NSDictionary]?
    var endPoint: String = "now_playing"
    let rootUrl: String = "https://api.themoviedb.org/3/movie/"
    let apiKey: String = "a07e22bc18f5cb106bfe4cc1f83ad8ed"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: .valueChanged)
        movieTableView.insertSubview(refreshControl, at: 0)
        
        errorView.isHidden = true
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        let movieURL = "\(rootUrl)\(endPoint)?api_key=\(apiKey)"
        
        fetchMovies(from: movieURL, refresher: nil, successCallback: self.reloadMovies, errorCallback: self.handleNetworkError)
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
        
        let movieURL = "\(rootUrl)\(endPoint)?api_key=\(apiKey)"
        
        fetchMovies(from: movieURL, refresher: refreshControl, successCallback: self.reloadMovies, errorCallback: self.handleNetworkError)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = movieTableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        
        detailViewController.movie = movie
        
    }
    
    func reloadMovies(with movies: [NSDictionary]) {
        self.movies = movies
        self.movieTableView.reloadData()
    }
    
    func handleNetworkError(error: Error) {
        errorView.isHidden = false
    }
    
    func fetchMovies(from url: String, refresher: UIRefreshControl?, successCallback: ([NSDictionary]) -> Void, errorCallback: ((Error) -> Void)?) {
        
        let movieURL = URL(string: url)
        let request = URLRequest(url: movieURL!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        //Network error by icon 54 from the Noun Project
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, errorOrNil) in
            if let requestError = errorOrNil {
                errorCallback?(requestError)
                
            } else {
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //NSLog("response: \(responseDictionary)")
                    let movies = responseDictionary["results"] as! [NSDictionary]
                    self.reloadMovies(with: movies)
                    self.errorView.isHidden = true
                }
            }
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if let refresh = refresher {
                refresh.endRefreshing()
            }
        });
        
        task.resume()
    }
}

