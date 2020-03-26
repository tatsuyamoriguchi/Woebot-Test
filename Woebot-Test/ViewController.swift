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
    
  
    
    var payloadsArray: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonData = ViewController.readJSONFromFile(fileName: "allornothing")

        
        if let idData = jsonData?["EIC"] as? [String : Any] {
                        
            for (key, value) in idData {
                print(key, value)
            }

            let textData = idData["text"] as? String
            chatTextLabel.text = textData
            chatTextView.text = textData
            
            
            if (idData["replies"] != nil) {
                guard let repliesArray = (idData["replies"] as? [String]) else { return }
                var x: Int = 80
                var index: Int = 0
                for rep in repliesArray {
                    createButtons(buttonTitle: rep, x: x, index: index )
                    x = x + 80
                    index = index + 1
                }
            }
            
            if (idData["payloads"] != nil) {
                    
                payloadsArray = (idData["payloads"] as? [String])
                for payload in payloadsArray!  {
                    print(payload)
                }
                
            }
            

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
    

    
    
//    var button = UIButton()
    
    func createButtons(buttonTitle: String, x: Int, index: Int) {
        let button = UIButton()
        button.frame = CGRect(x: x, y: 700, width: 50, height: 50)
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = .darkGray

        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.tag = index
    }
    
    
    @objc func buttonAction(sender: UIButton!) {
        print("")
        print("Button tapped")
        
        print(sender.titleLabel?.text as Any)
        let reply = sender.titleLabel?.text
        chatTextView.text = chatTextView.text + "\n" + (reply ?? "ERROR")
        
        
        // grab payloadsArray element value to send to the backend server
        let index = sender.tag
        print("index: \(index)")
        let payload = payloadsArray?[index]
        // Just print it for now
        print(payload as Any)
        
        sender.removeFromSuperview()
        

    }
    

    
}

