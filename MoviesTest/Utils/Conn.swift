//
//  Conn.swift
//  Conn
//
//  Created by Fernando Ortiz on 24/5/18.
//  Copyright © 2018 Fernando Ortiz. All rights reserved.
//
import Foundation

public enum ConnError: Swift.Error {
    case invalidURL
    case noData
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public struct RequestData {
    public let path: String
    public let method: HTTPMethod
    public let params: [String: Any?]?
    public let headers: [String: String]?
    
    public init (
        path: String,
        method: HTTPMethod = .get,
        params: [String: Any?]? = nil,
        headers: [String: String]? = nil
    ) {
        self.path = path
        self.method = method
        self.params = params
        self.headers = headers
    }
}

public protocol RequestType {
    associatedtype ResponseType: Codable
    var data: RequestData { get }
}

public extension RequestType {
    public func execute (
        dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance,
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (Error) -> Void
        ) -> URLSessionDataTask? {
        return dispatcher.dispatch(
            request: self.data,
            onSuccess: { (responseData: Data) in
                do {
                    let jsonDecoder = JSONDecoder()
                    let result = try jsonDecoder.decode(ResponseType.self, from: responseData)
                    DispatchQueue.main.async {
                        onSuccess(result)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        onError(error)
                    }
                }
            },
            onError: { (error: Error) in
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        )
    }
}

public protocol NetworkDispatcher {
    @discardableResult
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask?
}

public struct URLSessionNetworkDispatcher: NetworkDispatcher {
    public static let instance = URLSessionNetworkDispatcher()
    private init() {}
    
    @discardableResult
    public func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask? {
        print("-------------------")
        print("Dispatching request to \(request.path)")
        
        guard let url = URL(string: request.path) else {
            onError(ConnError.invalidURL)
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if let json = request.params {
            print("Params: \(getPrintableJSON(json))")
        }
        
        do {
            if let params = request.params {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            }
        } catch let error {
            onError(error)
            return nil
        }
        
        if let headers = request.headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        print("-------------------")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            
            guard let _data = data else {
                onError(ConnError.noData)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: _data, options: []) {
                print("Received response from \(request.path)")
                print(getPrintableJSON(json))
            }
            
            onSuccess(_data)
        }
        
        dataTask.resume()
        
        return dataTask
    }
}

func JSONStringify(_ value: AnyObject,prettyPrinted:Bool = false) -> String{
    
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    
    
    if JSONSerialization.isValidJSONObject(value) {
        
        do{
            let data = try JSONSerialization.data(withJSONObject: value, options: options)
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        }catch {
            
            print("error")
            //Access error here
        }
        
    }
    return ""
}

func getPrintableJSON(_ json: AnyObject) -> NSString {
    return JSONStringify(json, prettyPrinted: true) as NSString
}

func getPrintableJSON(_ json: Any) -> NSString {
    return getPrintableJSON(json as AnyObject)
}
