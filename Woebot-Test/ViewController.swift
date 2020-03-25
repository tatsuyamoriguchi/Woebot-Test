//
//  ViewController.swift
//  Woebot-Test
//
//  Created by Tatsuya Moriguchi on 3/25/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonData = ViewController.readJSONFromFile(fileName: "allornothing")
        
        if let idData = jsonData?["EIC"] as? [String : Any] {
                        
            for (key, value) in idData {
                print(key, value)
            }

            chatTextLabel.text = idData["text"] as? String
            chatTextView.text = idData["text"] as? String
            

        } else {
            print("No data")
        }
        
    }
    
    
    
    static func readJSONFromFile(fileName: String) -> [String: Any]?
    {
        var json: [String : Any] = [:]
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return json
    }
    
    /*

     EIC -> ["ZVQ", "YMB"]
     YMB -> "ZVQ"
     ZVQ -> ["CWP", "LIQ", "LIQ", "CFK"]
     CWP -> "JXH"
     LIQ -> ["ZVQ", "OWQ"]
     CFK -> "ZVQ"
     OWQ -> "CWP"
     JXH -> ["FJB", "TOL", "FJB"]
     FJB -> ["JXH", "OWQ"]
     TOL -> "ECK"
     ECK -> ["UGE", "CSX", "CSX", "IHP"]
     CSX -> "ECK"
     IHP -> "ECK"
     UGE -> "DGP"
     DGP -> ["YRB", "TUD"]
     YRB -> "QYY"
     TUD -> "DGP"
     

 */
    


    
    
    
}

