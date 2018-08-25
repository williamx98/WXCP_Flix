//
//  TrailerViewController.swift
//  WXCP_Flix
//
//  Created by Will Xu  on 8/25/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import WebKit
class TrailerViewController: UIViewController, WKUIDelegate{

    @IBOutlet weak var webView: WKWebView!
    var movie: [String: Any]?
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let movieId = String(movie!["id"] as! Int)
        let trailerURLURL = URL(string: "https://api.themoviedb.org/3/movie/" + movieId + "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: trailerURLURL, cachePolicy: .returnCacheDataElseLoad , timeoutInterval: 3)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                let data = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                var results = data["results"] as! [[String: Any]]
                var result = results[0]
                print(result)
                let key = result["key"] as! String
                let trailerURL = URL(string: "https://www.youtube.com/watch?v=" + key)
                let trailerRequest = URLRequest(url: trailerURL!)
                self.webView.load(trailerRequest)
            }
        }
        task.resume()
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
