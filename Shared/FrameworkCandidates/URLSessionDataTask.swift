//
// Created by Apps AS on 26/01/16.
// Copyright (c) 2016 All rights reserved.
//
// COMMUNICATION PROVIDER
// Responsible for wrapping NSURLSession and NSURLDataTask.

import Foundation
import Reachability
import SwiftyJSON

class URLSessionDataTask: NSObject, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    enum Thread {
        case background
        case main
    }
    
    fileprivate var mySession: Foundation.URLSession?
    fileprivate let myConfiguration: URLSessionConfiguration
    fileprivate var myDataTask: Foundation.URLSessionDataTask?
    fileprivate var myRequestHTTPMethod: String?
    fileprivate var myRequestedHTTPbody: JSON?
    fileprivate var myResponseData: Data?
    fileprivate var myRequestCompletion: ((Data?) -> Void)?
    fileprivate var myRequestCompletionThread: Thread?
    fileprivate var myErrorHandler: ((Error?, URLResponse?, Data?) -> Void)?
    fileprivate var myLogOutHandler: ((_ statusCode: Int) -> Void)?
    
    override init() {
        myConfiguration = URLSessionConfiguration.default
        myConfiguration.urlCache = URLCache.shared
        myConfiguration.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        myRequestHTTPMethod = HTTPMethod.get.rawValue
    }
    
    @discardableResult
    func onConfigureRequest(_ configuration: (_ config:URLSessionConfiguration) -> Void) -> URLSessionDataTask {
        configuration(self.myConfiguration)
        
        return self
    }
    
    @discardableResult
    func onRequestHTTPMethod(_ method: HTTPMethod) -> URLSessionDataTask {
        self.myRequestHTTPMethod = method.rawValue
        return self
    }
    
    @discardableResult
    func onRequestHTTBody(_ json: JSON?) -> URLSessionDataTask {
        self.myRequestedHTTPbody = json
        return self
    }
    
    @discardableResult
    func onRequestCompleted(onThread completionThread: Thread, completion: @escaping (_ responseData:Data?) -> Void) -> URLSessionDataTask {
        myRequestCompletion = completion
        myRequestCompletionThread = completionThread
        return self
    }
    
    @discardableResult
    func onError(_ errorHandler: @escaping (_ error:Error?, _ response:URLResponse?, _ data:Data?) -> Void) -> URLSessionDataTask {
        myErrorHandler = errorHandler
        return self
    }
    
    @discardableResult
    func onlogOut(_ logOutHandler: ((_ statusCode: Int) -> Void)?) -> URLSessionDataTask  {
        self.myLogOutHandler = logOutHandler
        return self
    }
    
    @discardableResult
    func requestFromURL(_ url: URL, cachePolicy: NSURLRequest.CachePolicy? = nil) -> URLSessionDataTask {
        if cachePolicy != nil {
            myConfiguration.requestCachePolicy = cachePolicy!
        } else {
            updateCachePolicyByReachability()
        }
        
        let delegateQueue = OperationQueue()
        delegateQueue.qualityOfService = .userInitiated
        
        mySession = Foundation.URLSession(configuration: myConfiguration, delegate: self, delegateQueue: delegateQueue)
        let request = NSMutableURLRequest(url: url, cachePolicy: myConfiguration.requestCachePolicy, timeoutInterval: TimeInterval(20))
        
        if myConfiguration.requestCachePolicy != NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData {
            if let cachedResponse = URLCache.shared.cachedResponse(for: request as URLRequest) {
                self.requestCompleted(cachedResponse.data)
                log(object: "Response comes from cache for \(url.absoluteString)")
                return self
            }
        }
        
        if let json = self.myRequestedHTTPbody {
            let jsonRequest = json.description
            //        let requestData = NSString(string: jsonRequest).data(using: String.Encoding.utf8)
            let requestData = String(jsonRequest).data(using: String.Encoding.utf8) //String(jsonRequest)?.data(using: String.Encoding.utf8)
            request.httpBody = requestData
        }
        
        if let httpMethod = self.myRequestHTTPMethod {
            request.httpMethod = httpMethod
        }
        
        
        
        myDataTask = mySession!.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            if error != nil {
                log(object: "Error on request \(url): \(String(describing: error)), \(String(describing: data))")
                self.myErrorHandler?(error, response, data)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if self.checkIfResponseContainError(url: url, response: httpResponse, data: data){
                    return
                }
            }
            self.requestCompleted(data)
        })
        
        myDataTask?.resume()
        
        return self
    }
    
    fileprivate func checkIfResponseContainError(url: URL, response: HTTPURLResponse, data: Data?) -> Bool{
        if response.statusCode < 200 || response.statusCode > 299 {
            log(object: "httpResponse.statusCode \(response.statusCode)")
            if let responseData = data{
                let json = try? JSON(data: responseData)
                log(object: "Error on request \(url): \(response.statusCode), \(String(describing: json)))")
            }
            
            let errorResponse: ErrorResponse? = data?.deSerialize()
            
            self.myErrorHandler?(DnAppError.httpError(response, data), response, data)
            if errorResponse?.errorName != ErrorResponse.noEpaperErrorName && response.statusCode == 401 {
                if self.myLogOutHandler == nil {
                    self.logoutUser()
                } else {
                    self.myLogOutHandler?(response.statusCode)
                }
            }
            return true
        }
        return false
    }
    
    fileprivate func logoutUser(){
//        if DNLoginManager.sharedInstance.isLoggedIn{
//            DNLoginManager.sharedInstance.logout {
//                DispatchQueue.main.async {
//                    DNLoginManager.sharedInstance.showLoginWindow()
//                }
//            } onError: { (error) in
//                log(object: error)
//            }
//        }
    }
    
    @discardableResult
    func postJSONRequest(_ json: JSON, url: URL) -> URLSessionDataTask {
        myConfiguration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        mySession = Foundation.URLSession(configuration: myConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        let request = NSMutableURLRequest(url: url, cachePolicy: myConfiguration.requestCachePolicy, timeoutInterval: TimeInterval(20))
        if let httpMethod = self.myRequestHTTPMethod, self.isValidHTTPMethodForDataPosting(httpMethod) {
            request.httpMethod = httpMethod
        }else {
            request.httpMethod = "POST"
        }
        
        let jsonRequest = json.description
        //        let requestData = NSString(string: jsonRequest).data(using: String.Encoding.utf8)
        let requestData = String(jsonRequest).data(using: String.Encoding.utf8) //String(jsonRequest)?.data(using: String.Encoding.utf8)
        request.httpBody = requestData
        
        log(object: "Request POST: \(url) with body: \(jsonRequest) with additional headers: \(String(describing: myConfiguration.httpAdditionalHeaders))")
        
        myDataTask = mySession!.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            if error != nil {
                log(object: "Error on request \(url): \(String(describing: error)), \(String(describing: data))")
                self.myErrorHandler?(error, response, data)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                log(object: "httpResponse.statusCode \(httpResponse.statusCode)")
                if self.checkIfResponseContainError(url: url, response: httpResponse, data: data){
                    return
                }
            }
            
            if data != nil {
                do{
                    let json = try JSON(data: data!)
                    log(object: "POST request: \(url) completed with: \(json)")
                }catch{
                    log(object: "POST request: \(url) error in data")
                }
            }
            
            self.requestCompleted(data)
        })
        
        myDataTask?.resume()
        
        return self
    }
    
    @discardableResult
    func putJSONRequest(_ json: JSON, url: URL) -> URLSessionDataTask {
        myConfiguration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        mySession = Foundation.URLSession(configuration: myConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        let request = NSMutableURLRequest(url: url, cachePolicy: myConfiguration.requestCachePolicy, timeoutInterval: TimeInterval(20))
        if let httpMethod = self.myRequestHTTPMethod, self.isValidHTTPMethodForDataPosting(httpMethod) {
            request.httpMethod = httpMethod
        }else {
            request.httpMethod = "PUT"
        }
        
        let jsonRequest = json.description
        //        let requestData = NSString(string: jsonRequest).data(using: String.Encoding.utf8)
        let requestData = String(jsonRequest).data(using: String.Encoding.utf8) //String(jsonRequest)?.data(using: String.Encoding.utf8)
        request.httpBody = requestData
        
        log(object: "Request PUT: \(url) with body: \(jsonRequest) with additional headers: \(String(describing: myConfiguration.httpAdditionalHeaders))")
        
        myDataTask = mySession!.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            if error != nil {
                log(object: "Error on request \(url): \(String(describing: error)), \(String(describing: data))")
                self.myErrorHandler?(error, response, data)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                log(object: "httpResponse.statusCode \(httpResponse.statusCode)")
                if self.checkIfResponseContainError(url: url, response: httpResponse, data: data){
                    return
                }
            }
            
            if data != nil {
                do{
                    let json = try JSON(data: data!)
                    log(object: "POST request: \(url) completed with: \(json)")
                }catch{
                    log(object: "POST request: \(url) error in data")
                }
            }
            
            self.requestCompleted(data)
        })
        
        myDataTask?.resume()
        
        return self
    }
    
    fileprivate func updateCachePolicyByReachability() {
        do {
            let reachablility = try Reachability()
            let status = reachablility.connection
            if status == .unavailable {
                myConfiguration.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataDontLoad
            } else {
                myConfiguration.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
            }
        } catch {
            log(object: "Cannot create reachability!")
        }
    }
    
    fileprivate func requestCompleted(_ data: Data?) {
        defer {
            mySession!.finishTasksAndInvalidate()
        }
        
        if myRequestCompletionThread == .main {
            DispatchQueue.main.async {
                self.myRequestCompletion?(data)
            }
            return
        }
        
        myRequestCompletion?(data)
    }
    
    fileprivate func isValidHTTPMethodForDataReading(_ method: String) -> Bool {
        switch method {
        case "GET", "DELETE":
            return true
        default:
            return false
        }
    }
    
    fileprivate func isValidHTTPMethodForDataPosting(_ method: String) -> Bool {
        switch method {
        case "POST", "PUT", "DELETE":
            return true
        default:
            return false
        }
    }
    
    func getCurrenDataTask() -> URLSessionTask? {
        return myDataTask
    }
    
    // MARK: - NSURLSessionDataDelegate
    
    //    @available(iOS 7.0, *)
    //    optional public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void)
    //
    //
    //    @available(iOS 7.0, *)
    //    optional public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask)
    //
    //
    //    @available(iOS 9.0, *)
    //    optional public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask)
    //
    //
    //    @available(iOS 7.0, *)
    //    optional public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    //
    //
    //    @available(iOS 7.0, *)
    //    optional public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void)
    
    func urlSession(_ session: URLSession, dataTask: Foundation.URLSessionDataTask/*URLSessionDataTask*/, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(Foundation.URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: Foundation.URLSessionDataTask/*URLSessionDataTask*/, didReceive data: Data) {
        if dataTask.error != nil {
            self.myErrorHandler?(dataTask.error, dataTask.response, data)
            return
        }
        
        self.requestCompleted(data)
    }
    
    func urlSession(_ session: URLSession, dataTask: Foundation.URLSessionDataTask/*URLSessionDataTask*/, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        guard let HTTPResponse = proposedResponse.response as? HTTPURLResponse else {
            
            return completionHandler(proposedResponse)
        }
        
        let cacheTimeInterval = 1 * 60 * 60
        var modifiedHeaders = HTTPResponse.allHeaderFields as? [String:String]
        modifiedHeaders?["Cache-Control"] = "max-age=\(cacheTimeInterval)"
        let modifiedResponse = HTTPURLResponse(url: HTTPResponse.url!, statusCode: HTTPResponse.statusCode, httpVersion: "HTTP/1.1", headerFields: modifiedHeaders)
        let cachedResponse = CachedURLResponse(response: modifiedResponse!, data: proposedResponse.data, userInfo: proposedResponse.userInfo, storagePolicy: proposedResponse.storagePolicy)
        
        completionHandler(cachedResponse)
    }
}


struct ErrorResponse: Codable {
    var errorCode: Int
    var errorName: String
    var errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorCodeKey = "error_code"
        case errorNameKey = "error_name"
        case errorMessageKey = "error_message"
    }
    
    func encode(to encoder: Encoder) throws {

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try container.decode(Int.self, forKey: .errorCodeKey)
        errorName = try container.decode(String.self, forKey: .errorNameKey)
        errorMessage = try container.decode(String.self, forKey: .errorMessageKey)
    }
    
    static let noEpaperErrorName = "NO_EPAPER_ACCESS"
}


struct HTTPMethod : Hashable {
     let rawValue: String
    
    static let get = HTTPMethod(rawValue: "GET")
    static let post = HTTPMethod(rawValue: "POST")
    static let put = HTTPMethod(rawValue: "PUT")
    static let delete = HTTPMethod(rawValue: "DELETE")
}


extension URLComponents {
    mutating func append(newQueryItems: [URLQueryItem]) {
        var existingItems = self.queryItems ?? []
        existingItems.append(contentsOf: newQueryItems)
        self.queryItems = existingItems
    }
}
