//
//  DetailViewController.swift
//  Flicks
//
//  Created by YINYEE LAI on 10/16/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    
    
    var movie: NSDictionary!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        titleLabel.text = title
        overviewLabel.text = overview
        
        overviewLabel.sizeToFit()
        
        if let posterURL = movie["poster_path"] as? String {
            //let baseURL = "https://image.tmdb.org/t/p/w500"
            
            let lowImgBaseURL = "https://image.tmdb.org/t/p/w45"
            let origImgBaseURL = "https://image.tmdb.org/t/p/original"
            
            let lowImgURL = URL(string: lowImgBaseURL + posterURL)
            let origImgURL = URL(string: origImgBaseURL + posterURL)
            
            
            let lowImgReq = URLRequest(url: lowImgURL!)
            let origImgReq = URLRequest(url: origImgURL!)
            
            
            posterImageView.setImageWith(lowImgReq, placeholderImage: nil, success: { (req, resp, lowImg) in
                if let response = resp {
                    self.posterImageView.alpha = 0
                    self.posterImageView.image = lowImg
                   UIView.animate(withDuration: 0.3, animations: {
                    self.posterImageView.alpha = 1
                    }, completion: { (success) in
                        self.posterImageView.setImageWith(origImgReq, placeholderImage: lowImg, success: { (origReq, origResp, origImg) in
                            self.posterImageView.image = origImg
                            }, failure: { (origReq, origResp, origError) in
                                self.posterImageView.image = lowImg
                        })
                        
                   })
                } else {
                    self.posterImageView.image = lowImg
                }
                }, failure: { (req, resp, err) in
                    self.posterImageView.image = nil
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
