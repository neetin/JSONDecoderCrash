//
//  data.swift
//  JSONCheck
//
//  Created by neetin on 13/01/2021.
//

import Foundation

struct SampleData {
static let jsonString = """
{
    "id": "ou91xzbrua",
    "companyId": "Hxbr5vyDs4fBpuVroo52sS2q19JmEkUz",
    "flowId": "JzinCYdDIgwpdFodYpnyhugBNof3xNNo",
    "connectionId": "e89f9ec675416d65640b1d9d4746cc33",
    "capabilityName": "createView",
    "screen": {
        "name": "Screen",
        "properties": {
            "screen1Config": null,
            "screen2Config": null,
            "screen3Config": null,
            "screen4Config": null,
            "screen5Config": null,
            "screen0Config": {
                "type": "array",
                "constructType": "screenConfig",
                "displayName": "First Screen Properties",
                "constructItems": [
                    "title",
                    "subTitle",
                    "bodyHeaderText",
                    "bodyText",
                    "nextButtonText",
                    "maskType",
                    "showMask",
                    "autoSubmit",
                    "bodyIcon0Name",
                    "bodyIcon0Link",
                    "bodyIcon0LinkPng",
                    "showActivityIndicator",
                    "bodyIcon1Name",
                    "bodyIcon1Link",
                    "bodyIcon2Name",
                    "bodyIcon2Link",
                    "bodyBackgroundTransparent",
                    "showPoweredBy",
                    "footerLinkText",
                    "firstLabel",
                    "secondLabel",
                    "hideButton",
                    "formFieldsList",
                    "screenComponentList",
                    "messageTitle",
                    "message",
                    "enablePolling",
                    "pollInterval",
                    "pollRetries",
                    "challenge",
                    "navTitle",
                    "fullScreenMode",
                    "customJsx",
                    "customStyles",
                    "viewPaddingTop",
                    "viewPaddingRight",
                    "viewPaddingBottom",
                    "viewPaddingLeft",
                    "viewBackgroundColor",
                    "navbarBackgroundColor",
                    "navbarTextColor",
                    "viewTextColor"
                ],
                "createdDate": 1610517226368,
                "customerId": "ecb9bf8a2fab854e65045d02cb6bab50",
                "companyId": "45acecb9bf85acecb95acecb95acecb95",
                "properties": {
                    "title": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "Title"
                    },
                    "subTitle": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Sub Title"
                    },
                    "bodyHeaderText": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Body Header Text"
                    },
                    "bodyText": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Body Text"
                    },
                    "nextButtonText": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Next Button Text",
                        "preferredControlType": "textField",
                        "userViewPreferredControlType": "label",
                        "css": {},
                        "value": "Submit"
                    },
                    "maskType": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "Mask Type",
                        "options": [
                            {
                                "name": "PhoneNumber",
                                "value": "phoneNumber"
                            },
                            {
                                "name": "Email",
                                "value": "email"
                            }
                        ],
                        "enum": [
                            "phoneNumber",
                            "email"
                        ]
                    },
                    "showMask": {
                        "type": "boolean",
                        "constructType": null,
                        "displayName": "Show Mask?",
                        "value": false
                    },
                    "autoSubmit": {
                        "type": "boolean",
                        "constructType": null,
                        "displayName": "Auto submit?",
                        "value": false
                    },
                    "bodyIcon0Name": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Body Icon Name"
                    },
                    "bodyIcon0Link": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Body Icon Link"
                    },
                    "bodyIcon0LinkPng": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Body Icon Link"
                    },
                    "showActivityIndicator": {
                        "type": "boolean",
                        "constructType": null,
                        "displayName": null,
                        "value": false
                    },
                    "bodyIcon1Name": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Body Icon Name"
                    },
                    "bodyIcon1Link": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Body Icon Link"
                    },
                    "bodyIcon2Name": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Body Icon Name"
                    },
                    "bodyIcon2Link": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Body Icon Link"
                    },
                    "bodyBackgroundTransparent": {
                        "type": "boolean",
                        "constructType": null,
                        "displayName": "Background Transparent?",
                        "value": false
                    },
                    "showPoweredBy": {
                        "type": "boolean",
                        "constructType": null,
                        "displayName": "Show Powered By?",
                        "value": false,
                        "preferredControlType": "toggleSwitch"
                    },
                    "footerLinkText": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Footer Button Text"
                    },
                    "firstLabel": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " First Label"
                    },
                    "secondLabel": {
                        "type": "string",
                        "constructType": null,
                        "displayName": " Second Label"
                    },
                    "hideButton": {
                        "type": "boolean",
                        "constructType": null,
                        "displayName": "Hide Close Button",
                        "value": false
                    },
                    "formFieldsList": {
                        "type": "array",
                        "constructType": "formFieldsList",
                        "displayName": "Fields List"
                    },
                    "screenComponentList": {
                        "type": "array",
                        "constructType": "screenComponentList",
                        "displayName": "Screen Component List",
                        "preferredControlType": "screenComponentList",
                        "hideLabel": true,
                        "value": [
                            {
                                "propertyName": "heading",
                                "preferredControlType": "label",
                                "preferredDataType": "string",
                                "value": "Welcome to account opening form",
                                "attributes": {
                                    "alignment": "center",
                                    "variant": "title",
                                    "color": "#4a90e2"
                                }
                            },
                            {
                                "propertyName": "logo",
                                "preferredControlType": "image",
                                "preferredDataType": "string",
                                "value": "https://ctznbank.com/assets/backend/uploads/logo-new.png",
                                "attributes": {
                                    "imageType": "pngURLImage",
                                    "imageContentMode": "aspectFill",
                                    "alignment": "left"
                                }
                            },
                            {
                                "propertyName": "email",
                                "preferredControlType": "textField",
                                "preferredDataType": "string",
                                "value": "",
                                "attributes": {
                                    "displayName": "Email Address",
                                    "color": "#4a90e2",
                                    "keyboardType": "emailAddress"
                                }
                            },
                            {
                                "propertyName": "phoneNumber",
                                "preferredControlType": "textField",
                                "preferredDataType": "string",
                                "value": "",
                                "attributes": {
                                    "displayName": "Phone Number",
                                    "color": "#4a90e2",
                                    "keyboardType": "phonePad"
                                }
                            }
                        ]
                    },
                    "messageTitle": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "Message Title",
                        "preferredControlType": "textField",
                        "enableParameters": true,
                        "value": ""
                    },
                    "message": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "Message",
                        "preferredControlType": "textArea",
                        "value": "",
                        "enableParameters": true
                    },
                    "enablePolling": {
                        "type": "boolean",
                        "constructType": "skEvent",
                        "displayName": "Enable Polling?",
                        "preferredControlType": "toggleSwitch",
                        "value": false,
                        "eventName": "polling",
                        "params": [],
                        "eventType": "post"
                    },
                    "pollInterval": {
                        "type": "number",
                        "constructType": null,
                        "displayName": "Poll Interval in ms",
                        "value": 2000,
                        "preferredControlType": "textField",
                        "visibility": [
                            {
                                "enablePolling": true
                            }
                        ]
                    },
                    "pollRetries": {
                        "type": "number",
                        "constructType": null,
                        "displayName": "Number of Poll Retries",
                        "value": 60,
                        "preferredControlType": "textField",
                        "visibility": [
                            {
                                "enablePolling": true
                            }
                        ]
                    },
                    "challenge": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "Challenge",
                        "preferredControlType": "textField",
                        "enableParameters": true
                    },
                    "navTitle": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "Navigation Title",
                        "info": "Navigation title.",
                        "preferredControlType": "textField",
                        "value": "Welcome"
                    },
                    "fullScreenMode": {
                        "type": "boolean",
                        "constructType": null,
                        "displayName": "Full Screen Mode?",
                        "value": false,
                        "info": "Hide navigation bar which also hides navigation title and back button",
                        "preferredControlType": "toggleSwitch"
                    },
                    "customJsx": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "Custom JSX"
                    },
                    "customStyles": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "Custom Styles"
                    },
                    "viewPaddingTop": {
                        "type": "number",
                        "constructType": null,
                        "displayName": "View padding top",
                        "info": "Top padding",
                        "preferredControlType": "textField",
                        "value": 10
                    },
                    "viewPaddingRight": {
                        "type": "number",
                        "constructType": null,
                        "displayName": "View padding right",
                        "info": "Right padding",
                        "preferredControlType": "textField",
                        "value": 30
                    },
                    "viewPaddingBottom": {
                        "type": "number",
                        "constructType": null,
                        "displayName": "View padding bottom",
                        "info": "Bottom padding",
                        "preferredControlType": "textField",
                        "value": 40
                    },
                    "viewPaddingLeft": {
                        "type": "number",
                        "constructType": null,
                        "displayName": "View padding left",
                        "info": "Left padding",
                        "preferredControlType": "textField",
                        "value": 50
                    },
                    "viewBackgroundColor": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "View Background Color",
                        "preferredControlType": "colorPicker",
                        "value": "#88afff"
                    },
                    "navbarBackgroundColor": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "Navigation Bar Background Color",
                        "preferredControlType": "colorPicker",
                        "value": "#f8e71c"
                    },
                    "navbarTextColor": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "Navigation Bar Text Color",
                        "preferredControlType": "colorPicker",
                        "value": "#fefff1"
                    },
                    "viewTextColor": {
                        "type": "string",
                        "constructType": null,
                        "displayName": "View Text Color",
                        "preferredControlType": "colorPicker",
                        "value": "#fafaff"
                    },
                    "description": {
                        "displayName": "Add UI components that you want to show on screen.",
                        "preferredControlType": "label",
                        "css": {}
                    },
                    "nextEvent": {
                        "constructType": "skEvent",
                        "eventName": "submit",
                        "eventType": "post"
                    },
                    "messageIcon": {
                        "preferredControlType": "textField",
                        "displayName": "Message Icon Url"
                    }
                }
            }
        },
        "userViews": [
            {
                "screenTemplateName": "CustomScreenTemplate",
                "screenConfigName": "screen0Config",
                "items": [
                    {
                        "propertyName": "navTitle"
                    },
                    {
                        "propertyName": "navbarBackgroundColor"
                    },
                    {
                        "propertyName": "navbarTextColor"
                    },
                    {
                        "propertyName": "viewPaddingTop"
                    },
                    {
                        "propertyName": "viewPaddingRight"
                    },
                    {
                        "propertyName": "viewPaddingBottom"
                    },
                    {
                        "propertyName": "viewPaddingLeft"
                    },
                    {
                        "propertyName": "viewTextColor"
                    },
                    {
                        "propertyName": "viewBackgroundColor"
                    },
                    {
                        "propertyName": "screenComponentList"
                    },
                    {
                        "propertyName": "nextButtonText"
                    },
                    {
                        "propertyName": "fullScreenMode"
                    },
                    {
                        "propertyName": "showPoweredBy"
                    },
                    {
                        "propertyName": "nextEvent"
                    }
                ]
            }
        ],
        "metadata": {
            "colors": {
                "canvas": "#58DFFF",
                "canvasText": "#000000",
                "dark": "#666666"
            },
            "logos": {
                "canvas": {
                    "imageFileName": "http.svg"
                }
            }
        }
    },
    "interactionId": "wFEvuCtuLULNvaOKwOvkNkBUkRMDDyeJ0GtbbUi7tfaCSaF0FnSrYOEUU0WU4AUY"
}
"""
}
