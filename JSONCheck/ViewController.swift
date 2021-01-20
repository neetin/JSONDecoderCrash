//
//  ViewController.swift
//  JSONCheck
//
//  Created by neetin on 13/01/2021.
//

import UIKit


let jsonData = """
{
  "screen0Config": {
    "type": "array",
    "constructType": "screenConfig",
    "displayName": "First Screen Properties",
  },
  "name": "test",
}
""".data(using: .utf8)

struct Screens: Decodable {
  var type: String?
  var constructType: String?
  var displayName: String?
}

struct FlowCheck: Decodable {
  var screen0Config: Screens?
  var screen1Config: Screens?
  var screen2Config: Screens?
  var screen3Config: Screens?
  var screen4Config: Screens?
  var screen5Config: Screens?
  var screen6Config: Screens?
  var screen7Config: Screens?
  var screen8Config: Screens?
  var screen9Config: Screens?
  var screen10Config: Screens?
  var screen11Config: Screens?
  var screen12Config: Screens?
  var screen13Config: Screens?
  var screen14Config: Screens?
  var name: String?
  var hobby: String?
  var address: String?
  var dob: Double?
}


class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let rawData =  SampleData.jsonString.data(using: .utf8) else {
      print("invalid JSON string")
      return
    }
//
    do {
      let flow = try JSONDecoder().decode(Flow.self, from:rawData)
        print(flow.connectionId)
        print("Flow Screen: \(flow.screen)")

      
//      let flowCheck = try JSONDecoder().decode(FlowCheck.self, from: jsonData!)
//      print("flowCheck: ", flowCheck)
      
    } catch (let error) {
      print(error)
    }
  }
}






