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
  case object([String: JSONValue])
  case array([JSONValue])
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self = try ((try? container.decode(String.self)).map(JSONValue.string))
      .or((try? container.decode(Int.self)).map(JSONValue.int))
      .or((try? container.decode(Double.self)).map(JSONValue.double))
      .or((try? container.decode(Bool.self)).map(JSONValue.bool))
      .or((try? container.decode([String: JSONValue].self)).map(JSONValue.object))
      .or((try? container.decode([JSONValue].self)).map(JSONValue.array))
      .resolve(with: DecodingError.typeMismatch(JSONValue.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON")))
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
  
  func getObjectValue() -> [String: JSONValue]? {
    switch self {
    case .object(let value):
      return value
    default:
      return nil
    }
  }
  
  func getArrayValue() -> [JSONValue] {
    switch self {
    case .array(let value):
      return value
    default:
      return []
    }
  }
}

struct UserViewItems: Decodable {
  var propertyName: String?
  enum CodingKeys: String, CodingKey {
    case propertyName
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      propertyName = try container.decode(String.self, forKey: .propertyName)
    } catch {
      propertyName = nil
      print("catch on decoding propertyName UserViewItems")
    }
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
  var canvas: String?
  var canvasText: String?
  var dark: String?
  enum CodingKeys: String, CodingKey {
    case canvas, dark, canvasText
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      canvas = try container.decode(String.self, forKey: .canvas)
    } catch {
      canvas = nil
      print("catch decoding on MetaDataColors -> canvas")
    }
    do {
      canvasText = try container.decode(String.self, forKey: .canvasText)
    } catch {
      canvasText = nil
      print("catch decoding on MetaDataColors -> canvasText")
    }
    do {
      dark = try container.decode(String.self, forKey: .dark)
    } catch {
      dark = nil
      print("catch dedocoing on MetaDataColors -> dark")
    }
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
  var screenConfigName: String? = nil
  var items: [UserViewItems]
  
  enum CodingKeys: String, CodingKey {
    case screenTemplateName, items, screenConfigName
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    screenTemplateName = try container.decode(String.self, forKey: .screenTemplateName)
    do {
      screenConfigName = try container.decode(String.self, forKey: .screenConfigName)
    } catch {
      screenConfigName = nil
      print("decoding error screenConfigName on UserView")
    }
    do {
      items = try container.decode(Array<UserViewItems>.self, forKey: .items)
    } catch {
      items = []
      print("decoding error items on UserView")
    }
  }
  
  static var keyPaths: [String : PartialKeyPath<UserView>] {
    return ["screenTemplateName" : \UserView.screenTemplateName, "screenConfigName" : \UserView.screenConfigName, "items" : \UserView.items]
  }
}

struct PostProcessNextEvent: Decodable {
  var constructType: String? = nil
  var eventName: String? = nil
  var params: [String]? = []
  var eventType: String? = nil
  
  enum CodingKeys: String, CodingKey {
    case eventName, params, eventType, constructType
  }
  
  init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      constructType = try container.decode(String.self, forKey: .constructType)
    } catch {
      constructType = nil
      print("catch decoding constructType on PostProcessNextEvent ")
    }
    do {
      eventName = try container.decode(String.self, forKey: .eventName)
    } catch {
      eventName = nil
      print("catch decoding on eventName on PostProcessNextEvent")
    }
    do {
      eventType = try container.decode(String.self, forKey: .eventType)
    } catch {
      print("error decoding eventType on PostProcessNextEvent")
    }
  }
}

struct EventsPostProcess: Decodable{
  var localEvent: String? = nil
  var nextEvent: PostProcessNextEvent? = nil
  var gotoNextUserView: Bool? = false
  // By default in nextEvent, we'll go to the next user View unless specified otherwise in the manifest
  
  enum CodingKeys: String, CodingKey {
    case localEvent, nextEvent, gotoNextUserView
  }
  
  init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      localEvent = try container.decode(String.self, forKey: .localEvent)
    } catch {
      localEvent = nil
      print("catch decoding error localEvent on  EventsPostProcess")
    }
    do {
      nextEvent = try container.decode(PostProcessNextEvent.self, forKey: .nextEvent)
    }catch {
      nextEvent = nil
      print("catch decoding error nextEvent on  EventsPostProcess")
    }
    do {
      gotoNextUserView = try container.decode(Bool.self, forKey: .gotoNextUserView)
    } catch {
      gotoNextUserView = nil
      print("error decoding gotoNextUserView on EventsPostProcess")
    }
  }
}

struct EventsProperties: Decodable {
  var eventName: String? = nil
  var type: String? = nil
  var constructType: String? = nil
  var params: [String]? = []
  var eventType: String? = nil
  var preProcess: [String:String]? = [:]
  var postProcess: EventsPostProcess? = nil
  var nextUserViewIndex: Int? = nil
  
  enum CodingKeys: String, CodingKey {
    case eventName, type, params, eventType, preProcess, postProcess, nextUserViewIndex, constructType
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      eventName = try container.decode(String.self, forKey: .eventName)
    } catch {
      eventName = nil
      print("catch decoding error eventName on  EventsProperties")
    }
    do {
      type = try container.decode(String.self, forKey: .type)
    }  catch {
      type = nil
      print("catch decoding error type on  EventsProperties")
    }
    do {
      constructType = try container.decode(String.self, forKey: .constructType)
    }  catch {
      constructType = nil
      print("catch decoding error constructType on  EventsProperties")
    }
    do {
      eventType = try container.decode(String.self, forKey: .eventType)
    }  catch {
      eventType = nil
      print("catch decoding error eventType on  EventsProperties")
    }
    do {
      postProcess = try container.decode(EventsPostProcess.self, forKey: .postProcess)
    }  catch {
      postProcess = nil
      print("catch decoding error postProcess on  EventsProperties")
    }
    do {
      nextUserViewIndex = try container.decode(Int.self, forKey: .nextUserViewIndex)
    } catch {
      nextUserViewIndex = nil
      print("error decoding error nextUserViewIndex on EventsProperties")
    }
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
  var dataTypeEnum: [String]
  var options: [EnumOptions]
  enum CodingKeys: String, CodingKey {
    case displayName, type, constructType, createdDate, customerId, companyId, value, preferredControlType, userViewPreferredControlType, options,  dataTypeEnum = "enum"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      displayName = try container.decode(String.self, forKey: .displayName)
    } catch {
      displayName = nil
      print(" error decoding displayName on Properties")
    }
    do {
      type = try container.decode(String.self, forKey: .type)
    } catch {
      type = nil
      print(" error decoding type on Properties")
    }
    do {
      constructType = try container.decode(String.self, forKey: .constructType)
    } catch {
      constructType = nil
      print(" error decoding constructType on Properties")
    }
    do {
      createdDate = try container.decode(Double.self, forKey: .createdDate)
    } catch {
      type = nil
      print(" error decoding createdDate on Properties")
    }
    do {
      customerId = try container.decode(String.self, forKey: .customerId)
    } catch {
      customerId = nil
      print(" error decoding customerId on Properties")
    }
    do {
      companyId = try container.decode(String.self, forKey: .companyId)
    } catch {
      companyId = nil
      print(" error decoding companyId on Properties")
    }
    do {
      value = try container.decode(JSONValue.self, forKey: .value)
    } catch {
      value = nil
      print(" error decoding value on Properties")
    }
    do {
      preferredControlType = try container.decode(String.self, forKey: .preferredControlType)
    } catch {
      preferredControlType = nil
      print(" error decoding preferredControlType on Properties")
    }
    do {
      userViewPreferredControlType = try container.decode(String.self, forKey: .userViewPreferredControlType)
    } catch {
      userViewPreferredControlType = nil
      print(" error decoding userViewPreferredControlType on Properties")
    }
    do {
      dataTypeEnum = try container.decode(Array<String>.self, forKey: .dataTypeEnum)
    } catch {
      dataTypeEnum = []
      print(" error decoding dataTypeEnum on Properties")
    }
    
    do {
      options = try container.decode(Array<EnumOptions>.self, forKey: .options)
    } catch {
      options = []
      print(" error decoding options on Properties")
    }
  }
}


struct ParameterItems: Decodable, KeyPathDeclaration {
  var items: [String]
  
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
  
  init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      title = try container.decode(Properties.self, forKey: .title)
    } catch {
      title = nil
      print(" error decoding title on ScreenConfigProperties")
    }
    do {
      subTitle = try container.decode(Properties.self, forKey: .subTitle)
    } catch {
      subTitle = nil
      print(" error decoding subTitle on ScreenConfigProperties")
    }
    do {
      bodyHeaderText = try container.decode(Properties.self, forKey: .bodyHeaderText)
    } catch {
      bodyHeaderText = nil
      print(" error decoding bodyHeaderText on ScreenConfigProperties")
    }
    do {
      maskType = try container.decode(Properties.self, forKey: .maskType)
    } catch {
      maskType = nil
      print(" error decoding maskType on ScreenConfigProperties")
    }
    
    do {
      showMask = try container.decode(Properties.self, forKey: .showMask)
    } catch {
      showMask = nil
      print(" error decoding showMask on ScreenConfigProperties")
    }
    do {
      autoSubmit = try container.decode(Properties.self, forKey: .autoSubmit)
    } catch {
      autoSubmit = nil
      print(" error decoding autoSubmit on ScreenConfigProperties")
    }
    do {
      bodyIcon0Name = try container.decode(Properties.self, forKey: .bodyIcon0Name)
    } catch {
      bodyIcon0Name = nil
      print(" error decoding bodyIcon0Name on ScreenConfigProperties")
    }
    do {
      bodyIcon0Link = try container.decode(Properties.self, forKey: .bodyIcon0Link)
    } catch {
      bodyIcon0Link = nil
      print(" error decoding bodyIcon0Link on ScreenConfigProperties")
    }
    do {
      showActivityIndicator = try container.decode(Properties.self, forKey: .showActivityIndicator)
    } catch {
      showActivityIndicator = nil
      print(" error decoding showActivityIndicator on ScreenConfigProperties")
    }
    do {
      bodyIcon1Name = try container.decode(Properties.self, forKey: .bodyIcon1Name)
    } catch {
      bodyIcon1Name = nil
      print(" error decoding bodyIcon1Name on ScreenConfigProperties")
    }
    do {
      bodyIcon1Link = try container.decode(Properties.self, forKey: .bodyIcon1Link)
    } catch {
      bodyIcon1Link = nil
      print(" error decoding bodyIcon1Link on ScreenConfigProperties")
    }
    do {
      bodyIcon2Name = try container.decode(Properties.self, forKey: .bodyIcon2Name)
    } catch {
      bodyIcon2Name = nil
      print(" error decoding bodyIcon2Name on ScreenConfigProperties")
    }
    do {
      bodyIcon2Link = try container.decode(Properties.self, forKey: .bodyIcon2Link)
    } catch {
      bodyIcon2Link = nil
      print(" error decoding bodyIcon2Link on ScreenConfigProperties")
    }
    do {
      bodyBackgroundTransparent = try container.decode(Properties.self, forKey: .bodyBackgroundTransparent)
    } catch {
      bodyBackgroundTransparent = nil
      print(" error decoding bodyBackgroundTransparent on ScreenConfigProperties")
    }
    do {
      showPoweredBy = try container.decode(Properties.self, forKey: .showPoweredBy)
    } catch {
      showPoweredBy = nil
      print(" error decoding showPoweredBy on ScreenConfigProperties")
    }
    do {
      footerLinkText = try container.decode(Properties.self, forKey: .footerLinkText)
    } catch {
      footerLinkText = nil
      print(" error decoding footerLinkText on ScreenConfigProperties")
    }
    do {
      firstLabel = try container.decode(Properties.self, forKey: .firstLabel)
    } catch {
      firstLabel = nil
      print(" error decoding firstLabel on ScreenConfigProperties")
    }
    do {
      secondLabel = try container.decode(Properties.self, forKey: .secondLabel)
    } catch {
      secondLabel = nil
      print(" error decoding secondLabel on ScreenConfigProperties")
    }
    do {
      onLoadEvent = try container.decode(EventsProperties.self, forKey: .onLoadEvent)
    } catch {
      onLoadEvent = nil
      print(" error decoding onLoadEvent on ScreenConfigProperties")
    }
    do {
      nextEvent = try container.decode(EventsProperties.self, forKey: .nextEvent)
    } catch {
      nextEvent = nil
      print(" error decoding nextEvent on ScreenConfigProperties")
    }
    do {
      bodyIcon0LinkPng = try container.decode(Properties.self, forKey: .bodyIcon0LinkPng)
    } catch {
      bodyIcon0LinkPng = nil
      print(" error decoding bodyIcon0LinkPng on ScreenConfigProperties")
    }
    do {
      parameters = try container.decode(ParameterItems.self, forKey: .parameters)
    } catch {
      parameters = nil
      print(" error decoding parameters on ScreenConfigProperties")
    }
    do {
      screenComponentList = try container.decode(ScreenComponentList.self, forKey: .screenComponentList)
    } catch {
      screenComponentList = nil
      print(" error decoding screenComponentList on ScreenConfigProperties")
    }
    do {
      navTitle = try container.decode(Properties.self, forKey: .navTitle)
    } catch {
      navTitle = nil
      print(" error decoding navTitle on ScreenConfigProperties")
    }
    do {
      fullScreenMode = try container.decode(Properties.self, forKey: .fullScreenMode)
    } catch {
      fullScreenMode = nil
      print(" error decoding fullScreenMode on ScreenConfigProperties")
    }
    do {
      messageTitle = try container.decode(Properties.self, forKey: .messageTitle)
    } catch {
      messageTitle = nil
      print(" error decoding messageTitle on ScreenConfigProperties")
    }
    do {
      message = try container.decode(Properties.self, forKey: .message)
    } catch {
      message = nil
      print(" error decoding message on ScreenConfigProperties")
    }
    do {
      challenge = try container.decode(Properties.self, forKey: .challenge)
    } catch {
      challenge = nil
      print(" error decoding challenge on ScreenConfigProperties")
    }
    do {
      enablePolling = try container.decode(Properties.self, forKey: .enablePolling)
    } catch {
      enablePolling = nil
      print(" error decoding enablePolling on ScreenConfigProperties")
    }
    do {
      pollRetries = try container.decode(Properties.self, forKey: .pollRetries)
    } catch {
      pollRetries = nil
      print(" error decoding pollRetries on ScreenConfigProperties")
    }
    
    do {
      pollInterval = try container.decode(Properties.self, forKey: .pollInterval)
    } catch {
      pollInterval = nil
      print(" error decoding pollInterval on ScreenConfigProperties")
    }
    do {
      viewPaddingTop = try container.decode(Properties.self, forKey: .viewPaddingTop)
    } catch {
      viewPaddingTop = nil
      print(" error decoding viewPaddingTop on ScreenConfigProperties")
    }
    do {
      viewPaddingRight = try container.decode(Properties.self, forKey: .viewPaddingRight)
    } catch {
      viewPaddingRight = nil
      print(" error decoding viewPaddingRight on ScreenConfigProperties")
    }
    do {
      viewPaddingBottom = try container.decode(Properties.self, forKey: .viewPaddingBottom)
    } catch {
      viewPaddingBottom = nil
      print(" error decoding viewPaddingBottom on ScreenConfigProperties")
    }
    do {
      viewPaddingLeft = try container.decode(Properties.self, forKey: .viewPaddingLeft)
    } catch {
      viewPaddingLeft = nil
      print(" error decoding viewPaddingLeft on ScreenConfigProperties")
    }
    do {
      viewTextColor = try container.decode(Properties.self, forKey: .viewTextColor)
    } catch {
      viewTextColor = nil
      print(" error decoding viewTextColor on ScreenConfigProperties")
    }
    do {
      viewBackgroundColor = try container.decode(Properties.self, forKey: .viewBackgroundColor)
    } catch {
      viewBackgroundColor = nil
      print(" error decoding viewBackgroundColor on ScreenConfigProperties")
    }
    do {
      navbarTextColor = try container.decode(Properties.self, forKey: .navbarTextColor)
    } catch {
      navbarTextColor = nil
      print(" error decoding navbarTextColor on ScreenConfigProperties")
    }
    do {
      navbarBackgroundColor = try container.decode(Properties.self, forKey: .navbarBackgroundColor)
    } catch {
      navbarBackgroundColor = nil
      print(" error decoding navbarBackgroundColor on ScreenConfigProperties")
    }
    
    do {
      nextButtonText = try container.decode(Properties.self, forKey: .nextButtonText)
    } catch {
      nextButtonText = nil
      print(" error decoding nextButtonText on ScreenConfigProperties")
    }
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
  var createdDate: Double?
  var customerId: String?
  var companyId: String?
  var properties: ScreenConfigProperties?
  var constructItems: [String]?
  
  enum CodingKeys: String, CodingKey {
    case displayName, type, constructType, createdDate, customerId, companyId, properties, constructItems
  }
  
  init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      displayName = try container.decode(String.self, forKey: .displayName)
    } catch {
      displayName = nil
      print(" error decoding displayName on ScreenConfig")
    }
    do {
      type = try container.decode(String.self, forKey: .type)
    } catch {
      type = nil
      print(" error decoding type on ScreenConfigProperties")
    }
    do {
      constructType = try container.decode(String.self, forKey: .constructType)
    } catch {
      constructType = nil
      print(" error decoding constructType on ScreenConfigProperties")
    }
    do {
      createdDate = try container.decode(Double.self, forKey: .createdDate)
    } catch {
      createdDate = nil
      print(" error decoding createdDate on ScreenConfigProperties")
    }
    do {
      customerId = try container.decode(String.self, forKey: .customerId)
    } catch {
      customerId = nil
      print(" error decoding customerId on ScreenConfigProperties")
    }
    do {
      properties = try container.decode(ScreenConfigProperties.self, forKey: .properties)
    } catch {
      properties = nil
      print(" error decoding properties on ScreenConfigProperties")
    }
    
    do {
      constructItems = try container.decode(Array<String>.self, forKey: .constructItems)
    } catch {
      constructItems = []
      print(" error decoding constructItems on ScreenConfigProperties")
    }
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
  
  enum CodingKeys: String, CodingKey {
    case screen0Config, screen1Config, screen2Config, screen3Config, screen4Config, screen5Config, title, description, authDescription, iconUrl, iconUrlPng
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      screen0Config = try container.decode(ScreenConfig.self, forKey: .screen0Config)
    } catch{
      screen0Config = nil
      print("error on screen0Config on MFAListValueProperties")
    }
    do {
      screen1Config = try container.decode(ScreenConfig.self, forKey: .screen1Config)
    } catch{
      screen1Config = nil
      print("error on screen1Config on MFAListValueProperties")
    }
    do {
      screen2Config = try container.decode(ScreenConfig.self, forKey: .screen2Config)
    } catch{
      screen2Config = nil
      print("error on screen2Config on MFAListValueProperties")
    }
    do {
      screen3Config = try container.decode(ScreenConfig.self, forKey: .screen3Config)
    } catch{
      screen3Config = nil
      print("error on screen3Config on MFAListValueProperties")
    }
    do {
      screen4Config = try container.decode(ScreenConfig.self, forKey: .screen4Config)
    } catch{
      screen4Config = nil
      print("error on screen4Config on MFAListValueProperties")
    }
    do {
      screen5Config = try container.decode(ScreenConfig.self, forKey: .screen5Config)
    } catch{
      screen5Config = nil
      print("error on screen5Config on MFAListValueProperties")
    }
    do {
      title = try container.decode(Properties.self, forKey: .title)
    } catch{
      title = nil
      print("error on title on MFAListValueProperties")
    }
    do {
      description = try container.decode(Properties.self, forKey: .description)
    } catch{
      description = nil
      print("error on description on MFAListValueProperties")
    }
    do {
      authDescription = try container.decode(Properties.self, forKey: .authDescription)
    } catch{
      authDescription = nil
      print("error on authDescription on MFAListValueProperties")
    }
    do {
      iconUrl = try container.decode(Properties.self, forKey: .iconUrl)
    } catch{
      iconUrl = nil
      print("error on iconUrl on MFAListValueProperties")
    }
    do {
      iconUrlPng = try container.decode(Properties.self, forKey: .iconUrlPng)
    } catch {
      iconUrlPng = nil
      print("error on iconUrlPng MFAListValueProperties")
    }
  }
  
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
  var metadata: MetaData?
  var userViews: [UserView]
  var properties: MFAListValueProperties?
  
  enum CodingKeys: String, CodingKey {
    case connectionId, connectorId, name, metadata, userViews, properties
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      connectionId = try container.decode(String.self, forKey: .connectionId)
    } catch {
      print("error docoding connectionId on MFAListValue")
      connectionId = ""
    }
    
    do {
      connectorId = try container.decode(String.self, forKey: .connectorId)
    } catch {
      print("error docoding connectorId on MFAListValue")
      connectorId = ""
    }
    
    do {
      name = try container.decode(String.self, forKey: .name)
    } catch {
      print("error docoding name on MFAListValue")
      name = ""
    }
    
    do {
      metadata = try container.decode(MetaData.self, forKey: .metadata)
    } catch {
      print("error docoding metadata on MFAListValue")
      metadata = nil
    }

    
    do {
      userViews = try container.decode(Array<UserView>.self, forKey: .userViews)
    } catch {
      print("error docoding userViews on MFAListValue")
      userViews = []
    }
    
    do {
      properties = try container.decode(MFAListValueProperties.self, forKey: .properties)
    } catch {
      print("error docoding properties on MFAListValue")
      properties = nil
    }

  }
}

struct MFAList: Decodable, KeyPathDeclaration {
  var displayName: String?
  var type: String?
  var constructType: String?
  var createdDate: Double?
  var customerId: String?
  var companyId: String?
  var value: [MFAListValue]
  
  enum CodingKeys: String, CodingKey {
    case displayName, type, constructType, createdDate, customerId, companyId, value
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      displayName = try container.decode(String.self, forKey: .displayName)
    } catch {
      displayName = nil
      print("erorr decoding displayName on MfaList")
    }
    do {
      type = try container.decode(String.self, forKey: .type)
    } catch {
      type = nil
      print("erorr decoding type on MfaList")
    }
    do {
      constructType = try container.decode(String.self, forKey: .constructType)
    } catch {
      constructType = nil
      print("erorr decoding constructType on MfaList")
    }
    do {
      createdDate = try container.decode(Double.self, forKey: .createdDate)
    } catch {
      createdDate = nil
      print("erorr decoding createdDate on MfaList")
    }
    do {
      customerId = try container.decode(String.self, forKey: .customerId)
    } catch {
      customerId = nil
      print("erorr decoding customerId on MfaList")
    }
    do {
      companyId = try container.decode(String.self, forKey: .companyId)
    } catch {
      companyId = nil
      print("erorr decoding companyId on MfaList")
    }
    
    do {
      value = try container.decode(Array<MFAListValue>.self, forKey: .value)
    } catch {
      value = []
      print("erorr decoding value on MfaList")
    }
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
  var hashedVisibility: Bool
  var imageType: String?
  var imageContentMode: String?
  var height: Double? = 0
  var options: [String]
  
  enum CodingKeys: String, CodingKey {
    case variant, alignment, keyboardType, displayName, placeholder, color, hashedVisibility, imageType, imageContentMode, height, options
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      variant = try container.decode(String.self, forKey: .variant)
    } catch {
      variant = nil
      print("decoding error on variant ScreenCompoentListValueAttributes")
    }
    do {
      alignment = try container.decode(String.self, forKey: .alignment)
    } catch {
      alignment = nil
      print("decoding error on alignment ScreenCompoentListValueAttributes")
    }
    do {
      keyboardType = try container.decode(String.self, forKey: .keyboardType)
    } catch {
      keyboardType = nil
      print("decoding error on keyboardType ScreenCompoentListValueAttributes")
    }
    do {
      displayName = try container.decode(String.self, forKey: .displayName)
    }  catch {
      displayName = nil
      print("decoding error on displayName ScreenCompoentListValueAttributes")
    }
    do {
      placeholder = try container.decode(String.self, forKey: .placeholder)
    }  catch {
      placeholder = nil
      print("decoding error on placeholder ScreenCompoentListValueAttributes")
    }
    do {
      color = try container.decode(String.self, forKey: .color)
    }  catch {
      color = nil
      print("decoding error on color ScreenCompoentListValueAttributes")
    }
    do {
      hashedVisibility = try container.decode(Bool.self, forKey: .hashedVisibility)
    } catch {
      hashedVisibility = false
      print("decoding error on hashedVisibility ScreenCompoentListValueAttributes")
    }
    do {
      imageType = try container.decode(String.self, forKey: .imageType)
    } catch {
      imageType = nil
      print("decoding error on imageType ScreenCompoentListValueAttributes")
    }
    do {
      imageContentMode = try container.decode(String.self, forKey: .imageContentMode)
    } catch {
      imageContentMode = nil
      print("decoding error on imageContentMode ScreenCompoentListValueAttributes")
    }
    do {
      height = try container.decode(Double.self, forKey: .height)
    }catch {
      height = nil
      print("decoding error on height ScreenCompoentListValueAttributes")
    }
  
    do {
      options = try container.decode(Array<String>.self, forKey: .options)
    }catch {
      options = []
      print("decoding error on options ScreenCompoentListValueAttributes")
    }
    
  }
  
  
  static var keyPaths: [String : PartialKeyPath<ScreenCompoentListValueAttributes>] {
    return ["variant" : \ScreenCompoentListValueAttributes.variant, "alignment" : \ScreenCompoentListValueAttributes.alignment,
            "keyboardType" : \ScreenCompoentListValueAttributes.keyboardType, "displayName" : \ScreenCompoentListValueAttributes.displayName,
            "placeholder" : \ScreenCompoentListValueAttributes.placeholder, "color" : \ScreenCompoentListValueAttributes.color,
            "hashedVisibility" : \ScreenCompoentListValueAttributes.hashedVisibility, "imageType" : \ScreenCompoentListValueAttributes.imageType,
            "imageContentMode" : \ScreenCompoentListValueAttributes.imageContentMode, "height" : \ScreenCompoentListValueAttributes.height,
            "options" : \ScreenCompoentListValueAttributes.options]
  }
  
}


struct ScreenComponentListValue: Decodable, KeyPathDeclaration {
  var propertyName: String?
  var preferredControlType: String?
  var value: JSONValue?
  var attributes: ScreenCompoentListValueAttributes?
  
  enum CodingKeys: String, CodingKey {
    case propertyName, preferredControlType, value, attributes
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      propertyName = try container.decode(String.self, forKey: .propertyName)
      preferredControlType = try container.decode(String.self, forKey: .preferredControlType)
      value = try container.decode(JSONValue.self, forKey: .value)
      attributes = try container.decode(ScreenCompoentListValueAttributes.self, forKey: .attributes)
    } catch {
      print("decoding error on ScreenComponentListValue")
    }
  }
  
  
  static var keyPaths: [String : PartialKeyPath<ScreenComponentListValue>] {
    return ["preferredControlType" : \ScreenComponentListValue.preferredControlType, "propertyName": \ScreenComponentListValue.propertyName,
            "attributes" : \ScreenComponentListValue.attributes, "value" : \ScreenComponentListValue.value
    ]
  }
}

struct ScreenComponentList: Decodable, KeyPathDeclaration {
  var displayName: String?
  var createdDate: Double?
  var value: [ScreenComponentListValue]
  
  enum CodingKeys: String, CodingKey {
    case displayName, createdDate, value
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      displayName = try container.decode(String.self, forKey: .displayName)
    } catch {
      print("decoding error displayName on ScreenComponentList")
      displayName = nil
    }
    do {
      createdDate = try container.decode(Double.self, forKey: .createdDate)
    } catch {
      createdDate = nil
      print("decoding createdDate on ScreenComponentList")
    }
    
    do {
      value = try container.decode(Array<ScreenComponentListValue>.self, forKey: .value)
    } catch {
      value = []
      print("decoding createdDate on ScreenComponentList")
    }
  }
  
  static var keyPaths: [String : PartialKeyPath<ScreenComponentList>] {
    return ["displayName" : \ScreenComponentList.displayName,
            "createdDate" : \ScreenComponentList.createdDate, "value" : \ScreenComponentList.value]
  }
}

struct ScreenProperties: Decodable, KeyPathDeclaration {
  var mfaList: MFAList?
  var screen0Config: ScreenConfig?
  var screen1Config: ScreenConfig?
  var screen2Config: ScreenConfig?
  var screen3Config: ScreenConfig?
  var screen4Config: ScreenConfig?
  var screen5Config: ScreenConfig?
  var variableList: Properties?
  var title: Properties?
  var bodyText: Properties?
  var description: Properties?
  var authDescription: Properties?
  var iconUrl: Properties?
  var iconUrlPng: Properties?
  
  enum CodingKeys: String, CodingKey {
    case mfaList, screen0Config, screen1Config, screen2Config, screen3Config, screen4Config, screen5Config, variableList, title, bodyText, description, authDescription, iconUrl, iconUrlPng
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    do {
      screen0Config = try container.decode(ScreenConfig.self, forKey: .screen0Config)
    } catch  {
      screen0Config = nil
      print("ScreenProperties screen0Config decoding error")
    }
    
    do {
      screen1Config = try container.decode(ScreenConfig.self, forKey: .screen1Config)
    } catch {
      screen1Config = nil
      print("ScreenProperties screen1Config decoding error")
    }
    do {
      screen2Config = try container.decode(ScreenConfig.self, forKey: .screen2Config)
    } catch {
      screen2Config = nil
      print("ScreenProperties screen2Config decoding error")
    }
    
    do {
      screen3Config = try container.decode(ScreenConfig.self, forKey: .screen3Config)
    } catch {
      screen3Config = nil
      print("ScreenProperties screen3Config decoding error")
    }
    
    do {
      screen4Config = try container.decode(ScreenConfig.self, forKey: .screen4Config)
    } catch  {
      screen4Config = nil
      print("ScreenProperties screen4Config decoding error")
    }
    
    do {
      screen5Config = try container.decode(ScreenConfig.self, forKey: .screen5Config)
    } catch  {
      screen5Config = nil
      print("ScreenProperties screen5Config decoding error")
    }
    
    do {
      variableList = try container.decode(Properties.self, forKey: .variableList)
    } catch {
      variableList = nil
      print("ScreenProperties variableList decoding error")
    }
    do {
      title = try container.decode(Properties.self, forKey: .title)
    } catch {
      title = nil
      print("ScreenProperties title decoding error")
    }
    do {
      bodyText = try container.decode(Properties.self, forKey: .bodyText)
    } catch {
      bodyText = nil
      print("ScreenProperties bodyText decoding error")
    }
    do {
      description = try container.decode(Properties.self, forKey: .description)
    } catch {
      description = nil
      print("ScreenProperties description decoding error")
    }
    do {
      authDescription = try container.decode(Properties.self, forKey: .authDescription)
    } catch {
      authDescription = nil
      print("ScreenProperties authDescription decoding error")
    }
    do {
      iconUrl = try container.decode(Properties.self, forKey: .iconUrl)
    } catch {
      iconUrl = nil
      print("ScreenProperties iconUrl decoding error")
    }
    do {
      iconUrlPng = try container.decode(Properties.self, forKey: .iconUrlPng)
    } catch {
      iconUrlPng = nil
      print("ScreenProperties  iconUrlPng decoding error")
    }
    do {
      mfaList = try container.decode(MFAList.self, forKey: .mfaList)
    } catch {
      mfaList = nil
      print("ScreenProperties mfaList decoding error")
    }
    
  }
  
  
  static var keyPaths: [String : PartialKeyPath<ScreenProperties>] {
    return ["mfaList" : \ScreenProperties.mfaList,
            "screen0Config" : \ScreenProperties.screen0Config,
            "screen1Config" : \ScreenProperties.screen1Config,
            "screen2Config" : \ScreenProperties.screen2Config,
            "screen3Config" : \ScreenProperties.screen3Config,
            "screen4Config" : \ScreenProperties.screen4Config,
            "screen5Config" : \ScreenProperties.screen5Config,
            "variableList" : \ScreenProperties.variableList,
            "title" : \ScreenProperties.title,
            "bodyText" : \ScreenProperties.bodyText,
            "description" : \ScreenProperties.description,
            "authDescription" : \ScreenProperties.authDescription,
            "iconUrl" : \ScreenProperties.iconUrl,
            "iconUrlPng" : \ScreenProperties.iconUrlPng
    ]
  }
}

struct Screen: Decodable, KeyPathDeclaration {
  var name: String
  var properties: ScreenProperties?
  var userViews: [UserView]
  var metadata: MetaData?
  
  enum CodingKeys: String, CodingKey {
    case name, userViews, metadata, properties
  }
  static var keyPaths: [String : PartialKeyPath<Screen>] {
    return ["name" : \Screen.name, "properties" : \Screen.properties, "userViews" : \Screen.userViews, "metadata" : \Screen.metadata]
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    do {
      name = try container.decode(String.self, forKey: .name)
    } catch  {
      name = ""
      print("Screen name decoding error")
    }
    
    do {
      properties = try container.decode(ScreenProperties.self, forKey: .properties)
    } catch  {
      properties = nil
      print("Screen properties decoding error")
    }
    
    do {
      userViews = try container.decode(Array<UserView>.self, forKey: .userViews)
    } catch  {
      userViews = []
      print("Screen userViews decoding error")
    }
    
    do {
      metadata = try container.decode(MetaData.self, forKey: .metadata)
    } catch  {
      metadata = nil
      print("Screen userViews decoding error")
    }
  }
}


struct Flow: Decodable {
  var screen: Screen?
  var id: String
  var companyId: String
  var flowId: String
  var connectionId: String
  var capabilityName: String
  var interactionId: String
  
  enum CodingKeys: String, CodingKey {
    case screen, id, companyId, flowId, connectionId, capabilityName, interactionId
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    do {
      screen = try container.decode(Screen.self, forKey: .screen)
    } catch DecodingError.keyNotFound(let key, let context) {
        fatalError("Failed to decode  due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
    } catch DecodingError.typeMismatch(_, let context) {
        fatalError("Failed to decode  due to type mismatch – \(context.debugDescription)")
    } catch DecodingError.valueNotFound(let type, let context) {
        fatalError("Failed to decode  due to missing \(type) value – \(context.debugDescription)")
    } catch DecodingError.dataCorrupted(_) {
        fatalError("Failed to decode  because it appears to be invalid JSON")
    } catch {
        fatalError("Failed to decode  from bundle: \(error.localizedDescription)")
    }
    
    do {
      id = try container.decode(String.self, forKey: .id)
    } catch  {
      id = ""
      print("Flow id decoding error")
    }
    
    do {
      companyId = try container.decode(String.self, forKey: .companyId)
    } catch  {
      companyId = ""
      print("Flow screen decoding error")
    }
    
    do {
      flowId = try container.decode(String.self, forKey: .flowId)
    } catch  {
      flowId = ""
      print("Flow screen decoding error")
    }
    
    do {
      connectionId = try container.decode(String.self, forKey: .connectionId)
    } catch  {
      connectionId = ""
      print("Flow screen decoding error")
    }
    
    do {
      capabilityName = try container.decode(String.self, forKey: .capabilityName)
    } catch  {
      capabilityName = ""
      print("Flow screen decoding error")
    }
    
    do {
      interactionId = try container.decode(String.self, forKey: .interactionId)
    } catch  {
      interactionId = ""
      print("Flow screen decoding error")
    }
  }
}
