//
//  NetworkManager.swift
//  coppelTest
//
//  Created by Tony on 8/18/22.
//

import Foundation

class NetworkManager {
    private let api_key = "f8c0ec636a7906af9977e6ba7ad0c832"
    
    var baseUrl = "https://api.themoviedb.org/3"
    var baseUrLForImages = "https://image.tmdb.org/t/p/w300"
    
    static var sharedInstance = NetworkManager()
    private let urlSession: URLSession
    
    var dataTask: URLSessionDataTask?
    
    // MARK: - Variables And Properties
    var request_token: String?
    var movies: [Movie] = []
    var movieDet = Movie()
    var session_id: String?
    
    // MARK: - Type Alias
    
    typealias JSONDictionary = [String: Any]
    
    required init() {
        let config: URLSessionConfiguration = .default
//        config.timeoutIntervalForRequest = 60
//        config.timeoutIntervalForResource = 60
        urlSession = URLSession(configuration: config)
    }
    
    func requestToken(completion: @escaping (String)-> Void) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: baseUrl + "/authentication/token/new") {
            urlComponents.query = "api_key=\(api_key)"
            
            var responseJson: JSONDictionary?
            guard let url = urlComponents.url else { return }
            
            dataTask = urlSession.dataTask(with: url, completionHandler: { [weak self] data, response, error in
                defer {
                  self?.dataTask = nil
                }
                
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    
                    do {
                        responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                    } catch let parseError as NSError {
                        print(parseError.localizedDescription)
                        return
                    }
                    
                    self?.request_token = responseJson!["request_token"] as? String
                    DispatchQueue.main.async {
                        completion(self?.request_token ?? "")
                    }
                }
            })
            
            dataTask?.resume()
        }
    }
    
    func requestTokenAsync() async throws -> String {
        
        if var urlComponents = URLComponents(string: baseUrl + "/authentication/token/new") {
            urlComponents.query = "api_key=\(api_key)"
            
            var responseJson: JSONDictionary?
            guard let url = urlComponents.url else { throw NSError() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            do {
                let (data, response) = try await urlSession.data(for: urlRequest)
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                }
            } catch let parseError as NSError {
                print(parseError.localizedDescription)
            }
            self.request_token = responseJson!["request_token"] as? String
            
        }
        return self.request_token ?? ""
    }
    
    func createSessionWithLogin(username: String, password: String) async throws -> (Bool, String) {
        var success:Bool = false
        var statusMessage:String = ""
        
        let params = [
            "username" : username,
            "password": password,
            "request_token": self.request_token
        ]
        
        if var urlComponents = URLComponents(string: baseUrl + "/authentication/token/validate_with_login") {
            urlComponents.query = "api_key=\(api_key)"
            
            var responseJson: JSONDictionary?
            guard let url = urlComponents.url else { throw NSError() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            do {
                let (data, response) = try await urlSession.data(for: urlRequest)
                if let _ = response as? HTTPURLResponse {
                    responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                }
            } catch let parseError as NSError {
                print(parseError.localizedDescription)
            }
            
            guard let successResponse = responseJson!["success"] as? Bool else { throw NSError() }
            if let message = responseJson!["status_message"] as? String { statusMessage = message }
            success = successResponse
            
        }
        return (success, statusMessage)
    }
    
    func getMovies() async throws -> [Movie]{
        
        if var urlComponents = URLComponents(string: baseUrl + "/discover/movie") {
            let queryItems = [URLQueryItem(name: "api_key", value: api_key), URLQueryItem(name: "sort_by", value: "popularity.desc")]
            urlComponents.queryItems = queryItems
            
            var responseJson: JSONDictionary?
            guard let url = urlComponents.url else { return Array<Movie>() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let (data, response) = try await urlSession.data(for: urlRequest)
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                }
            } catch let parseError as NSError {
                print(parseError.localizedDescription)
            }
            
            guard let array = responseJson!["results"] as? [Any] else { return Array<Movie>() }
            
            for movieDictionary in array {
                if let movieDic = movieDictionary as? JSONDictionary,
                    let title = movieDic["title"] as? String,
                    let description = movieDic["overview"] as? String,
                    let rating = movieDic["vote_average"] as? Double,
                    let releaseDate = movieDic["release_date"] as? String,
                    let id = movieDic["id"] as? Int {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YYYY-MM-DD"
                        let date = dateFormatter.date(from: releaseDate)
                        let newMovie = Movie()
                        newMovie.title = title
                        newMovie.description = description
                        newMovie.rating = rating
                        newMovie.id = id
                        newMovie.releaseDate = date
                        if let poster = movieDic["poster_path"] as? String {
                            newMovie.imgdata = try? await downloadImage(poster)
                        }
                        movies.append(newMovie)
                }
            }
        }
        return movies
    }
    
    func downloadImage(_ imgUrl: String) async throws -> Data? {
        var imgData: Data?
        if var urlComponents = URLComponents(string: baseUrLForImages + imgUrl) {
            urlComponents.query = "api_key=\(api_key)"
            
            guard let url = urlComponents.url else { throw NSError() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            do{
                let (urlFile, _) = try await urlSession.download(for: urlRequest)
                imgData = try Data(contentsOf: urlFile)
                
            } catch let parseError as NSError {
                print(parseError.localizedDescription)
            }
        }
        return imgData
    }
    
    func checkToken() -> Bool {
        let token = LocalSettings.request_token
        self.request_token = token
        return token != nil
    }
    
    func checkSession() -> Bool{
        let sessionid = LocalSettings.session_id
        self.session_id = sessionid
        return sessionid != nil
    }
    
    func createSession() async throws {
        if var urlComponents = URLComponents(string: baseUrl + "/authentication/session/new") {
            urlComponents.query = "api_key=\(api_key)"
            
            let params = ["request_token": self.request_token]
            
            var responseJson: JSONDictionary?
            guard let url = urlComponents.url else { throw NSError() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            do {
                let (data, response) = try await urlSession.data(for: urlRequest)
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                    self.session_id = responseJson!["session_id"] as? String
                    LocalSettings.session_id = responseJson!["session_id"] as? String
                }
            } catch let parseError as NSError {
                print(parseError.localizedDescription)
            }
        }
    }
    
    func getProfile() async throws -> User? {
        if !checkToken() {
            let _ = try? await requestTokenAsync()
        } //TODO: check it or call it
        if !checkSession() {
            try? await createSession()
        }
        var profile : User = User()
        if var urlComponents = URLComponents(string: baseUrl + "/account") {
            let queryItems = [URLQueryItem(name: "api_key", value: api_key), URLQueryItem(name: "session_id", value: session_id)]
            urlComponents.queryItems = queryItems
            
            var responseJson: JSONDictionary?
            guard let url = urlComponents.url else { throw NSError() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            do {
                let (data, response) = try await urlSession.data(for: urlRequest)
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                }
            } catch let parseError as NSError {
                print(parseError.localizedDescription)
            }
            
            if let username = responseJson!["username"] as? String,
               let name = responseJson!["name"] as? String,
               let avatar = responseJson!["avatar"] as? JSONDictionary,
               let tmdb = avatar["tmdb"] as? JSONDictionary,
               let avatarPath = tmdb["avatar_path"] as? String
            {
                let avatarData = try? await downloadImage(avatarPath)
                profile.username = username
                profile.name = name
                profile.avatar = avatarData
            }
        }
        return profile
    }
    
    func getMovieDetails(_ id:Int) async throws -> Movie? {
        
        if var urlComponents = URLComponents(string: baseUrl + "/movie/\(id)") {
            urlComponents.query = "api_key=\(api_key)"
            
            var responseJson: JSONDictionary?
            guard let url = urlComponents.url else { throw NSError() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do{
                let (data, response) = try await urlSession.data(for: urlRequest)
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                    
                    if let title = responseJson!["title"] as? String,
                       let description = responseJson!["overview"] as? String,
                       let rating = responseJson!["vote_average"] as? Double,
                       let releaseDate = responseJson!["release_date"] as? String,
                       let id = responseJson!["id"] as? Int,
                       let duration = responseJson!["runtime"] as? Int,
                       let adult = responseJson!["adult"] as? Bool{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YYYY-MM-DD"
                        let date = dateFormatter.date(from: releaseDate)
                        movieDet.title = title
                        movieDet.description = description
                        movieDet.rating = rating
                        movieDet.id = id
                        movieDet.releaseDate = date
                        movieDet.durarion = duration
                        movieDet.adult = adult
                        if let poster = responseJson!["poster_path"] as? String {
                            movieDet.imgdata = try? await downloadImage(poster)
                        }
                    }
                    
                    if let companies = responseJson!["production_companies"] as? Array<JSONDictionary> {
                        var movieCompanies = [ProductionCompany]()
                        for company in companies {
                            if let name = company["name"] as? String,
                                let id = company["id"] as? Int,
                                let logo_path = company["logo_path"] as? String{
                                    let newCompany = ProductionCompany(id: id, logo_path: logo_path, name: name)
                                movieCompanies.append(newCompany)
                            }
                        }
                        movieDet.productionCompanies = movieCompanies
                    }
                } 
                
            } catch let parseError as NSError {
                print(parseError.localizedDescription)
            }
        }
        return movieDet
    }
}
