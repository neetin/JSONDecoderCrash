//
//  Flow.swift
//  JSONCheck
//
//  Created by neetin on 13/01/2021.
//

import Foundation

extension Optional {
  func or(_ other: Optional) -> Optional {
      switch self {
      case .none: return other
      case .some: return self
      }
  }
  func resolve(with error: @autoclosure () -> Error) throws -> Wrapped {
      switch self {
      case .none: throw error()
      case .some(let wrapped): return wrapped
      }
  }
}

public protocol KeyPathDeclaration
{
  static var keyPaths: [String : PartialKeyPath<Self>] { get }
}


public enum JSONValue: Decodable {
  case string(String)
  case int(Int)
  case double(Double)
  case bool(Bool)
  
  public init(from decoder: Decoder) throws {
    
    if let string = try? decoder.singleValueContainer().decode(String.self) {
        self = .string(string)
        return
    }
    
    if let int = try? decoder.singleValueContainer().decode(Int.self) {
        self = .int(int)
        return
    }
    
    if let double = try? decoder.singleValueContainer().decode(Double.self) {
        self = .double(double)
        return
    }
    
    if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
        self = .bool(bool)
        return
    }
    
    throw JSONValueError.missingValue
  }
  
  enum JSONValueError: Error {
          case missingValue
      }
  
  func getStringValue() -> String? {
    switch self {
    case .string(let value):
      return value
    default:
      return nil
    }
  }
  
  func getBoolValue() -> Bool? {
    switch self {
    case .bool(let value):
      return value
    default:
      return nil
    }
  }
  
  func getDoubleValue() ->Double? {
    switch self {
    case .double(let value):
      return value
    case .int(let value):
      return Double(value)
    case .string(let value):
      return Double(value)
    default:
      return nil
    }
  }
}

struct UserViewItems: Decodable {
  var propertyName: String
  enum CodingKeys: String, CodingKey {
    case propertyName
  }
}

struct MetaDataLogos: Decodable {
  var canvas: MetaDataCanvas
  
  enum CodingKeys: String, CodingKey {
    case canvas
  }
}

struct MetaDataCanvas: Decodable {
  var imageFileName: String
  enum CodingKeys: String, CodingKey {
    case imageFileName
  }
}

struct MetaDataColors: Decodable {
  var canvas: String
  var canvasText: String?
  var dark: String
  enum CodingKeys: String, CodingKey {
    case canvas, dark, canvasText
  }
}

struct MetaData: Decodable {
  var colors: MetaDataColors
  var logos: MetaDataLogos
  
  enum CodingKeys: String, CodingKey {
    case colors, logos
  }
}

struct UserView: Decodable, KeyPathDeclaration {
  var screenTemplateName: String
  var screenConfigName: String?
  var items: [UserViewItems]?
  
  enum CodingKeys: String, CodingKey {
    case screenTemplateName, items, screenConfigName
  }
  
  static var keyPaths: [String : PartialKeyPath<UserView>] {
    return ["screenTemplateName" : \UserView.screenTemplateName, "screenConfigName" : \UserView.screenConfigName, "items" : \UserView.items]
  }
}

struct PostProcessNextEvent: Decodable {
  var constructType: String?
  var eventName: String?
  var params: [String]?
  var eventType: String?
  
  enum CodingKeys: String, CodingKey {
    case eventName, params, eventType, constructType
  }
}


struct EventsPostProcess: Decodable{
  var localEvent: String?
  var nextEvent: PostProcessNextEvent?
  var gotoNextUserView: Bool?
  // By default in nextEvent, we'll go to the next user View unless specified otherwise in the manifest
  
  enum CodingKeys: String, CodingKey {
    case localEvent, nextEvent, gotoNextUserView
  }
}

struct EventsProperties: Decodable {
  var eventName: String?
  var type: String?
  var constructType: String?
  var params: [String]?
  var eventType: String?
  var preProcess: [String:String]?
  var postProcess: EventsPostProcess?
  var nextUserViewIndex: Int?
  
  enum CodingKeys: String, CodingKey {
    case eventName, type, params, eventType, preProcess, postProcess, nextUserViewIndex, constructType
  }
}

struct EnumOptions: Decodable {
  var name: String
  var value: String
  
  enum CodingKeys: String, CodingKey {
    case name, value
  }
}

struct Properties: Decodable {
  var displayName: String?
  var type: String?
  var constructType: String?
  var createdDate: Double?
  var customerId: String?
  var companyId: String?
  var value: JSONValue?
  var preferredControlType: String?
  var userViewPreferredControlType: String?
  var css: [String: String]?
  var sections: [String]?
  var dataTypeEnum: [String]?
  var options: [EnumOptions]?
  enum CodingKeys: String, CodingKey {
    case displayName, type, constructType, createdDate, customerId, companyId, value, preferredControlType, userViewPreferredControlType, css, sections, options,  dataTypeEnum = "enum"
  }
}


struct ParameterItems: Decodable, KeyPathDeclaration {
  var items: [String]?
  
  enum CodingKeys: String, CodingKey {
    case items
  }
  
  static var keyPaths: [String : PartialKeyPath<ParameterItems>] {
    return ["items" : \ParameterItems.items]
  }
}

struct ScreenConfigProperties: Decodable, KeyPathDeclaration {
  var title: Properties?
  var subTitle: Properties?
  var bodyHeaderText: Properties?
  var bodyText: Properties?
  var nextButtonText: Properties?
  var maskType: Properties?
  var showMask: Properties?
  var autoSubmit: Properties?
  var bodyIcon0Name: Properties?
  var bodyIcon0Link: Properties?
  var bodyIcon0LinkPng: Properties?
  var showActivityIndicator: Properties?
  var bodyIcon1Name: Properties?
  var bodyIcon1Link: Properties?
  var bodyIcon2Name: Properties?
  var bodyIcon2Link: Properties?
  var bodyBackgroundTransparent: Properties?
  var showPoweredBy: Properties?
  var footerLinkText: Properties?
  var firstLabel: Properties?
  var secondLabel: Properties?
  var onLoadEvent: EventsProperties?
  var nextEvent: EventsProperties?
  var parameters: ParameterItems?
  var screenComponentList: ScreenComponentList?
  var navTitle: Properties?
  var fullScreenMode: Properties?
  var messageTitle: Properties?
  var message: Properties?
  var challenge: Properties?
  var enablePolling: Properties?
  var pollInterval: Properties?
  var pollRetries: Properties?
  var viewPaddingTop: Properties?
  var viewPaddingRight: Properties?
  var viewPaddingBottom: Properties?
  var viewPaddingLeft: Properties?
  var viewTextColor: Properties?
  var viewBackgroundColor: Properties?
  var navbarTextColor: Properties?
  var navbarBackgroundColor: Properties?
  
  enum CodingKeys: String, CodingKey {
    case title, subTitle, bodyHeaderText, bodyText, nextButtonText, maskType, showMask, autoSubmit, bodyIcon0Name, bodyIcon0Link, showActivityIndicator, bodyIcon1Name, bodyIcon1Link, bodyIcon2Name, bodyIcon2Link, bodyBackgroundTransparent, showPoweredBy, footerLinkText, firstLabel, secondLabel, onLoadEvent, nextEvent, bodyIcon0LinkPng, parameters, screenComponentList, navTitle, fullScreenMode, messageTitle, message, challenge, enablePolling, pollRetries, pollInterval, viewPaddingTop, viewPaddingRight, viewPaddingBottom, viewPaddingLeft, viewTextColor, viewBackgroundColor, navbarTextColor, navbarBackgroundColor
  }
  
  static var keyPaths: [String : PartialKeyPath<ScreenConfigProperties>] {
    return ["title" : \ScreenConfigProperties.title, "subTitle" : \ScreenConfigProperties.subTitle,
            "bodyHeaderText" : \ScreenConfigProperties.bodyHeaderText, "bodyText" : \ScreenConfigProperties.bodyText,
            "nextButtonText" : \ScreenConfigProperties.nextButtonText, "maskType" : \ScreenConfigProperties.maskType,
            "showMask" : \ScreenConfigProperties.showMask, "autoSubmit" : \ScreenConfigProperties.autoSubmit,
            "bodyIcon0Name" : \ScreenConfigProperties.bodyIcon0Name, "bodyIcon0Link" : \ScreenConfigProperties.bodyIcon0Link,
            "bodyIcon0LinkPng" : \ScreenConfigProperties.bodyIcon0LinkPng, "showActivityIndicator" : \ScreenConfigProperties.showActivityIndicator,
            "bodyIcon1Name" : \ScreenConfigProperties.bodyIcon1Name, "bodyIcon1Link" : \ScreenConfigProperties.bodyIcon1Link,
            "bodyIcon2Name" : \ScreenConfigProperties.bodyIcon2Name,
            "bodyIcon2Link" : \ScreenConfigProperties.bodyIcon2Link, "bodyBackgroundTransparent" : \ScreenConfigProperties.bodyBackgroundTransparent,
            "showPoweredBy" : \ScreenConfigProperties.showPoweredBy, "footerLinkText" : \ScreenConfigProperties.footerLinkText,
            "firstLabel" : \ScreenConfigProperties.firstLabel, "secondLabel" : \ScreenConfigProperties.secondLabel,
            "onLoadEvent" : \ScreenConfigProperties.onLoadEvent, "nextEvent" : \ScreenConfigProperties.nextEvent,
            "parameters": \ScreenConfigProperties.parameters,
            "screenComponentList" : \ScreenConfigProperties.screenComponentList,
            "navTitle" : \ScreenConfigProperties.navTitle,
            "fullScreenMode" : \ScreenConfigProperties.fullScreenMode,
            "messageTitle" : \ScreenConfigProperties.messageTitle,
            "message" : \ScreenConfigProperties.message,
            "challenge" : \ScreenConfigProperties.challenge,
            "enablePolling" : \ScreenConfigProperties.enablePolling,
            "pollInterval" : \ScreenConfigProperties.pollInterval,
            "pollRetries" : \ScreenConfigProperties.pollRetries,
            "viewPaddingTop": \ScreenConfigProperties.viewPaddingTop,
            "viewPaddingRight": \ScreenConfigProperties.viewPaddingRight,
            "viewPaddingBottom": \ScreenConfigProperties.viewPaddingBottom,
            "viewPaddingLeft": \ScreenConfigProperties.viewPaddingLeft,
            "viewTextColor": \ScreenConfigProperties.viewTextColor,
            "viewBackgroundColor": \ScreenConfigProperties.viewBackgroundColor,
            "navbarTextColor": \ScreenConfigProperties.navbarTextColor,
            "navbarBackgroundColor": \ScreenConfigProperties.navbarBackgroundColor
    ]
      
  }
}

struct ScreenConfig: Decodable, KeyPathDeclaration {
  var displayName: String?
  var type: String?
  var constructType: String?
  var createdDate: Double? = 0
  var customerId: String?
  var companyId: String?
  var properties: ScreenConfigProperties?
  var constructItems: [String]?
  
  enum CodingKeys: String, CodingKey {
    case displayName, type, constructType, createdDate, customerId, companyId, properties, constructItems
  }
  
  static var keyPaths: [String : PartialKeyPath<ScreenConfig>] {
    return ["displayName" : \ScreenConfig.displayName, "type" : \ScreenConfig.type, "constructType" : \ScreenConfig.constructType, "createdDate" : \ScreenConfig.createdDate, "customerId" : \ScreenConfig.customerId, "properties" : \ScreenConfig.properties, "constructItems" : \ScreenConfig.constructItems, "companyId": \ScreenConfig.companyId]
  }
  
}

struct MFAListValueProperties: Decodable, KeyPathDeclaration {
  var screen0Config: ScreenConfig?
  var screen1Config: ScreenConfig?
  var screen2Config: ScreenConfig?
  var screen3Config: ScreenConfig?
  var screen4Config: ScreenConfig?
  var screen5Config: ScreenConfig?
  var title: Properties?
  var description: Properties?
  var authDescription: Properties?
  var iconUrl: Properties?
  var iconUrlPng: Properties?
  
  static var keyPaths: [String : PartialKeyPath<MFAListValueProperties>] {
    return ["screen0Config" : \MFAListValueProperties.screen0Config, "screen1Config" : \MFAListValueProperties.screen1Config, "screen2Config" : \MFAListValueProperties.screen2Config, "screen3Config" : \MFAListValueProperties.screen3Config, "screen4Config" : \MFAListValueProperties.screen4Config, "screen5Config" : \MFAListValueProperties.screen5Config, "title" : \MFAListValueProperties.title,
            "description" : \MFAListValueProperties.description, "authDescription" : \MFAListValueProperties.authDescription,
            "iconUrl" : \MFAListValueProperties.iconUrl, "iconUrlPng" : \MFAListValueProperties.iconUrlPng
    ]
  }
}

struct MFAListValue: Decodable {
  var connectionId: String
  var connectorId: String
  var name: String
  var metadata: MetaData
  var userViews: [UserView]
  var properties: MFAListValueProperties
  
  enum CodingKeys: String, CodingKey {
    case connectionId, connectorId, name, metadata, userViews, properties
  }
}

struct MFAList: Decodable, KeyPathDeclaration {
  var displayName: String?
  var type: String?
  var constructType: String?
  var createdDate: Double?
  var customerId: String?
  var companyId: String?
  var value: [MFAListValue]?
  
  enum CodingKeys: String, CodingKey {
    case displayName, type, constructType, createdDate, customerId, companyId, value
  }
  static var keyPaths: [String : PartialKeyPath<MFAList>] {
    return ["displayName" : \MFAList.displayName,
            "type" : \MFAList.type, "constructType": \MFAList.constructType,  "createdDate" : \MFAList.createdDate,
            "customerId" : \MFAList.customerId, "companyId" : \MFAList.companyId,
            "value" : \MFAList.value
    ]
  }
}

struct ScreenCompoentListValueAttributes: Decodable, KeyPathDeclaration {
  var variant: String?
  var alignment: String?
  var keyboardType: String?
  var displayName: String?
  var placeholder: String?
  var color: String?
  var hashedVisibility: Bool?
  var imageType: String?
  var imageContentMode: String?
  var height: Double? = 0
  var width: Double? = 0
  var options: [String]?
  
  static var keyPaths: [String : PartialKeyPath<ScreenCompoentListValueAttributes>] {
    return ["variant" : \ScreenCompoentListValueAttributes.variant, "alignment" : \ScreenCompoentListValueAttributes.alignment,
    "keyboardType" : \ScreenCompoentListValueAttributes.keyboardType, "displayName" : \ScreenCompoentListValueAttributes.displayName,
    "placeholder" : \ScreenCompoentListValueAttributes.placeholder, "color" : \ScreenCompoentListValueAttributes.color,
    "hashedVisibility" : \ScreenCompoentListValueAttributes.hashedVisibility, "imageType" : \ScreenCompoentListValueAttributes.imageType,
    "imageContentMode" : \ScreenCompoentListValueAttributes.imageContentMode, "height" : \ScreenCompoentListValueAttributes.height,
    "width" : \ScreenCompoentListValueAttributes.width, "options" : \ScreenCompoentListValueAttributes.options]
  }
  
}


struct ScreenComponentListValue: Decodable, KeyPathDeclaration {
  var propertyName: String?
  var preferredControlType: String?
  var value: JSONValue?
  var attributes: ScreenCompoentListValueAttributes?
  
  static var keyPaths: [String : PartialKeyPath<ScreenComponentListValue>] {
    return ["preferredControlType" : \ScreenComponentListValue.preferredControlType, "propertyName": \ScreenComponentListValue.propertyName,
            "attributes" : \ScreenComponentListValue.attributes, "value" : \ScreenComponentListValue.value
    ]
  }
}

struct ScreenComponentList: Decodable, KeyPathDeclaration {
  var displayName: String?
  var createdDate: Double?
  var value: [ScreenComponentListValue]?
  
  static var keyPaths: [String : PartialKeyPath<ScreenComponentList>] {
    return ["displayName" : \ScreenComponentList.displayName,
            "createdDate" : \ScreenComponentList.createdDate, "value" : \ScreenComponentList.value]
  }
}

struct ScreenProperties: Decodable, KeyPathDeclaration {
  var mfaList: MFAList? = nil
  var screen0Config: ScreenConfig? = nil
  var screen1Config: ScreenConfig? = nil
  var screen2Config: ScreenConfig? = nil
  var screen3Config: ScreenConfig? = nil
  var screen4Config: ScreenConfig? = nil
  var screen5Config: ScreenConfig? = nil
  var variableList: Properties? = nil
  var title: Properties? = nil
  var bodyText: Properties? = nil
  var description: Properties? = nil
  var authDescription: Properties? = nil
  var iconUrl: Properties? = nil
  var iconUrlPng: Properties? = nil
  
  enum CodingKeys: String, CodingKey {
    case mfaList, screen0Config, screen1Config, screen2Config, screen3Config, screen4Config, screen5Config, variableList, title, bodyText, description, authDescription, iconUrl, iconUrlPng
    
  }
  
  static var keyPaths: [String : PartialKeyPath<ScreenProperties>] {
    return ["mfaList" : \ScreenProperties.mfaList as PartialKeyPath<ScreenProperties>,
            "screen0Config" : \ScreenProperties.screen0Config as PartialKeyPath<ScreenProperties>,
            "screen1Config" : \ScreenProperties.screen1Config as PartialKeyPath<ScreenProperties>,
            "screen2Config" : \ScreenProperties.screen2Config as PartialKeyPath<ScreenProperties>,
            "screen3Config" : \ScreenProperties.screen3Config as PartialKeyPath<ScreenProperties>,
            "screen4Config" : \ScreenProperties.screen4Config as PartialKeyPath<ScreenProperties>,
            "screen5Config" : \ScreenProperties.screen5Config as PartialKeyPath<ScreenProperties>,
            "variableList" : \ScreenProperties.variableList,
            "title" : \ScreenProperties.title,
            "bodyText" : \ScreenProperties.bodyText,
            "description" : \ScreenProperties.description as PartialKeyPath<ScreenProperties>,
            "authDescription" : \ScreenProperties.authDescription,
            "iconUrl" : \ScreenProperties.iconUrl,
            "iconUrlPng" : \ScreenProperties.iconUrlPng
    ]
  }
}

struct Screen: Decodable, KeyPathDeclaration {
  var name: String
  var properties: ScreenProperties
  var userViews: [UserView]
  var metadata: MetaData
  
  enum CodingKeys: String, CodingKey {
    case name, userViews, metadata, properties
  }
  
  static var keyPaths: [String : PartialKeyPath<Screen>] {
    return ["name" : \Screen.name, "properties" : \Screen.properties, "userViews" : \Screen.userViews, "metadata" : \Screen.metadata]
  }
}


struct Flow: Decodable {
  var screen: Screen
  var id: String
  var companyId: String
  var flowId: String
  var connectionId: String
  var capabilityName: String
  var interactionId: String
  
  enum CodingKeys: String, CodingKey {
    case screen, id, companyId, flowId, connectionId, capabilityName, interactionId
  }
}
