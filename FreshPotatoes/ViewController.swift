//
//  ViewController.swift
//  FreshPotatoes
//
//  Created by Jianfeng Ye on 2/2/15.
//  Copyright (c) 2015 Dion613. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var movies : [Movie] = []
    
    var refresh: UIRefreshControl!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.brownColor()
        
//        self.movies = [Movie(name: "Inception"), Movie(name: "Edge of Tomorrow"), Movie(name: "American Sniper"), Movie(name: "The Imitation Game")]

        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("loadMovieData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        self.ErrorLabel.hidden = true
        
        loadMovieData()
    }
    
    func loadMovieData() {
        self.movies = []
        SVProgressHUD.show()
        
        let rottenTomatoesURLBox = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=10&country=us&apikey=djm3a6pjg6wethbby5b22tgr"
        let rottenTomatoesURLDvd = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?limit=10&country=us&apikey=djm3a6pjg6wethbby5b22tgr"
        let url = self.restorationIdentifier == "box" ? rottenTomatoesURLBox : rottenTomatoesURLDvd
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response, data, error) in
            var errorValue: NSError? = error
            if let errorValue = errorValue {
                let errorDetail = errorValue.localizedDescription
                self.ErrorLabel.hidden = false
                //self.ErrorLabel.text = errorDetail
                SVProgressHUD.dismiss()
                self.refreshControl?.endRefreshing()
            }
            else {
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            let moviesData = dictionary["movies"] as NSArray
            for data in moviesData as [NSDictionary]
            {
                var posterUrl = (data["posters"] as NSDictionary)["thumbnail"] as String
                self.movies.append(Movie(name: data["title"] as String, synopsis: data["synopsis"] as String, posterUrl: posterUrl))
            }
                self.ErrorLabel.hidden = true
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as MovieTableViewCell
        var m = self.movies[indexPath.row]
        cell.NameLabel.text = m.name
        cell.PosterImageView.setImageWithURL(NSURL(string: m.posterSmallUrl))
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsView = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsView") as MovieDetailsViewController
        let selectedMovie = self.movies[indexPath.row]
        detailsView.movie = selectedMovie
        self.navigationController?.pushViewController(detailsView, animated: true)
    }
}

