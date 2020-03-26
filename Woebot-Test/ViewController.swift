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
        
        repliesArray = []
        payloadsArray = []
        routesArray = []

        if let idData = jsonData?[jsonID] as? [String : Any] {
            
            for (key, value) in idData {
                // Debug purpose
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

                    // Debug purpose
                    print("\nreplies is not an array.")

                    let buttonTitle = idData["replies"]
                    createButtons(buttonTitle: buttonTitle as! String, x: 40, index: 0)
                }
            }
            
            if (idData["payloads"] != nil) {
                
                if let array = (idData["payloads"] as? [String]) {

                    // Debug purpose
                    print("\npayload as Array")

                    payloadsArray = array
                    for payload in array  {
                        
                        print(payload)
                    }
                    
                } else {
                    
                    // Debug purpose
                    print("\npayloads is not Array.")
                    print(idData["payloads"] as Any)

                    payloadsArray?.append(idData["payloads"] as! String)
                    
                    // Debug purpose
                    print("\npayloadsArray: \(String(describing: payloadsArray))")
                                    
                }
            }
            
            if (idData["routes"] != nil) {
                
                if let array = (idData["routes"] as? [String]) {
                   routesArray = array
                    
                    // Debug purpose
                    print("\nroute as Array")
                    for route in array  {
                        // Debug purpose
                        print(route)
                    }
                    
                } else {
                    // Debug purpose
                    print("\nroute is not Array.")

                    routesArray?.append(idData["routes"] as! String)
                    
                    // Debug purpose
                    print("\nroutesArray: \(String(describing: routesArray))")
                }
            }
            
        } else {
            print("\nNo data")
        }
    }
    

    
    func createButtons(buttonTitle: String, x: Int, index: Int) {
        let button = UIButton()

        self.view.addSubview(button)

        // dynamically position buttons
        let constantX = CGFloat(x)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: constantX).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30.0).isActive = true
        
// Old code to statically position buttons
//        let maxWidth = 200
//        button.frame = CGRect(x: x, y: 200, width: maxWidth, height: 50)
        
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = .darkGray
        
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        button.tag = index

        self.buttonArray.append(button)

    }
    
    
    @objc func buttonAction(sender: UIButton!) {

        removeButtons()
        
        // Debug purpose
        print("\n********Button tapped***********")
        print("\nsender.titleLabel?.text as Any")
        print(sender.titleLabel?.text as Any)
        
        let reply = sender.titleLabel?.text
        let chatData = chatTextView.text + "\n" + "You: " + (reply ?? "ERROR") + "\n"
        chatTextView.text = chatData
        
        
        // grab payloadsArray element value to send to the backend server
        let index = sender.tag
        
        // Debug purpose
        print("\nindex: \(index)")

        // pass Json nextID to display next question
        guard let nextID = routesArray?[index] else { return  }
        
        // Debug purpose
        print("\nnextID: \(nextID)")
        
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

