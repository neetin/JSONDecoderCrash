//
//  ViewController.swift
//  JSONCheck
//
//  Created by neetin on 13/01/2021.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let rawData =  SampleData.jsonString.data(using: .utf8) else {
      print("invalid JSON string")
      return
    }
    
    do {
      let flow = try JSONDecoder().decode(Flow.self, from:rawData)
        print(flow.connectionId)
      
      print("Flow Screen: \(flow.screen)")
        
    } catch (let error) {
      print(error)
    }

    
    
  }


}

