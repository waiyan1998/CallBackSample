//
//  ViewController.swift
//  CallBackSample
//
//  Created by Wai Yan on 1/30/20.
//  Copyright © 2020 Wai Yan. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    var movieData: MovieResponse?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callBackSample(success: { (networkResponse) in
            print("The success value is")
            print(networkResponse)
            self.movieData = networkResponse
            for i in (self.movieData?.results)! {
                print(i.title)
                print(i.original_title)
                print("0-0000000")
            }
            DispatchQueue.main.async {

            do {
                let url = URL(string: "https://image.tmdb.org/t/p/w500/" + (self.movieData?.results?.last!.poster_path)! )
                let data = try  Data(contentsOf: url! )
                self.imageView.image = UIImage(data: data)

            }catch {
                
            }

                }
            
            
           
            
            
        })
        { (error) in
            DispatchQueue.main.async {
                let myAlert = UIAlertController(title: error.localizedDescription, message: "this is message", preferredStyle: .alert)
                myAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                myAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(myAlert, animated: true, completion: nil)
            }
        }
            
        }
    
    
    
    func callBackSample(success: @escaping (MovieResponse) -> Void,
                        failure: @escaping (Error) -> Void) {
        let movieApiRoute = "https://api.themoviedb.org/3/movie/upcoming?page=1&language=en-US&api_key=0e11ec4415ce25d5faa6aa39553e27ac"
        let url = URL(string: movieApiRoute)
        let session = URLSession.shared
        
        url?.asyncDownload(completion: { ( data , Response , Error ) in
            guard let data = data else { return }
                                    do {
                                        let jsonDecoder = JSONDecoder()
                                        let responseModel = try jsonDecoder.decode(MovieResponse.self, from: data)
                                        success(responseModel)
                                    } catch let error {
                                        failure(error)
                                    }
        })
        
        
//        let req = URLRequest(url: url!)
//        let dataTask = session.dataTask(with: req) { (data , response , error ) in
//            guard let data = data else { return }
//                        do {
//                            let jsonDecoder = JSONDecoder()
//                            let responseModel = try jsonDecoder.decode(MovieResponse.self, from: data)
//                            success(responseModel)
//                        } catch let error {
//                            failure(error)
//                        }
//        }
       // dataTask.resume()
        
        }
        
        
        
        
        
            
}
        
        
//            Alamofire.request(movieApiRoute , method: .get , parameters: nil , encoding: URLEncoding.default , headers: nil).response { (response) in
//            guard let data = response.data else { return }
//            do {
//                let jsonDecoder = JSONDecoder()
//                let responseModel = try jsonDecoder.decode(MovieResponse.self, from: data)
//                success(responseModel)
//            } catch let error {
//                failure(error)
//            }

    
        
        
        

extension URL {
    func asyncDownload(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: self, completionHandler: completion).resume()
    }
}





