//
//  ViewController.swift
//  Woebot-Test
//
//  Created by Tatsuya Moriguchi on 3/25/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

import UIKit


/* payloads -> JSON ID Tree

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


class ViewController: UIViewController {

    // Properties
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatTextLabel: UILabel!
    
  
    let jsonData = ViewController.readJSONFromFile(fileName: "allornothing")
    var repliesArray: [String]?
    var payloadsArray: [String]?
    var routesArray: [String]?
    var buttonArray = [UIButton]()
    
    // View
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJson(chatData: "", jsonID: "EIC")
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let bottom = NSMakeRange(chatTextView.text.count - 1, 1)
        chatTextView.scrollRangeToVisible(bottom)

    }
    
    // Methods
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
    
    
    
    func parseJson(chatData: String, jsonID: String) {
        
        if let idData = jsonData?[jsonID] as? [String : Any] {
            
            for (key, value) in idData {
                print(key, value)
            }
            
            guard let textData = idData["text"] as? String else { return }

            chatTextLabel.text = textData
            chatTextView.text = chatData + "\n" + textData
            
  
            if (idData["replies"] != nil) {
                if let array = (idData["replies"] as? [String]) {
                    
                    
                repliesArray = array
                    var x: Int = 40
                    var index: Int = 0
                    for rep in array {
                        createButtons(buttonTitle: rep, x: x, index: index )
                        x = x + 40
                        index = index + 1

                    }
                    
                } else {
                    print("replies is not an array.")
                    var array: [String]?
                    
                    array?.append(idData["replies"] as! String)
                    print("ERROR: ")
                    print(idData["replies"] as Any)

                    let buttonTitle = idData["replies"]

                    createButtons(buttonTitle: buttonTitle as! String, x: 40, index: 0)

                }
            }
            
            if (idData["payloads"] != nil) {
                
                if let array = (idData["payloads"] as? [String]) {
                    
                    payloadsArray = array
                    for payload in array  {
                        print(payload)
                    }
                    
                } else {
                    let payload = idData["payloads"] as? String
                    print(payload as Any)
                    
                }
            }
            
            if (idData["routes"] != nil) {
                
                if let array = (idData["routes"] as? [String]) {
                   routesArray = array
                    for route in array  {
                        print(route)
                    }
                } else {
                    let route = idData["routes"] as? String
                    print(route as Any)
                }
            }
            
            
            
        } else {
            print("No data")
        }
        
    }
    

    
    func createButtons(buttonTitle: String, x: Int, index: Int) {
        let button = UIButton()
        

        let maxWidth = 200
        button.frame = CGRect(x: x, y: 700, width: maxWidth, height: 50)
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = .darkGray
        
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.tag = index

        self.buttonArray.append(button)

    }
    
    
    @objc func buttonAction(sender: UIButton!) {
        
        removeButtons()
        
        print("")
        print("Button tapped")
        
        print(sender.titleLabel?.text as Any)
        let reply = sender.titleLabel?.text
        let chatData = chatTextView.text + "\n" + (reply ?? "ERROR")
        chatTextView.text = chatData
        
        
        // grab payloadsArray element value to send to the backend server
        let index = sender.tag
        print("index: \(index)")
        let payload = payloadsArray?[index]
        // Just print it for now
        print(payload as Any)
        

     

        
        // pass Json nextID to display next question
        guard let nextID = routesArray?[index] else { return  }
        
        print("nextID: \(nextID)")

       
        parseJson(chatData: chatData, jsonID: nextID)
        
    }
    
    func removeButtons() {
        // Remove buttons
         for btn in buttonArray {
             btn.removeFromSuperview()
         }
    }
  
    
    @IBAction func clearData(_ sender: UIButton) {
        removeButtons()
        parseJson(chatData: "", jsonID: "EIC")
    }
    
    

    
}

