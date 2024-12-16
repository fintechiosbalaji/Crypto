//
//  API.swift
//  Viper_Combine_SampleApp
//
//
import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingError
    case unknownError
}

final class NetworkManager: NetworkManagerProtocol {
    
    func get<T>(
        type: T.Type,
        router: URLRouter,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        count: Int,
        method: RequestMethod
    ) -> AnyPublisher<Result<T, NetworkError>, Never> where T: Decodable {
        
        // Build the URL request
        if let request = buildRequest(router: router, parameters: parameters, headers: headers, count: count, method: method) {
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { response -> Data in
                    // Ensure valid response code
                    guard let httpResponse = response.response as? HTTPURLResponse else {
                        throw NetworkError.unknownError
                    }
                    // Check for 2xx status code
                    guard 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                    }
                    print("Response Data: \(String(data: response.data, encoding: .utf8) ?? "Invalid Data")")
                    return response.data
                }
                .decode(type: T.self, decoder: Decoders.Decoder)
                .map { Result.success($0) } // Success case
                .catch { error -> Just<Result<T, NetworkError>> in
                    // Handle errors, map to network error
                    let networkError: NetworkError
                    if let urlError = error as? URLError {
                        networkError = .unknownError // Handle URL errors here
                    } else if let decodingError = error as? DecodingError {
                        networkError = .decodingError
                    }else {
                        networkError = .unknownError
                    }
                    return Just(Result.failure(networkError)) // Failure case
                }
                .eraseToAnyPublisher()
        }
        return Just(Result.failure(NetworkError.invalidURL)).eraseToAnyPublisher()
    }
    
    func buildRequest(
        router: URLRouter,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        count: Int,
        method: RequestMethod = .get
    ) -> URLRequest? {
        var baseURL = count == 1 ? Constant.secondarybaseURL : Constant.baseURL
        
        let urlString = Constant.scheme + baseURL + router.path
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let requestHeaders = headers {
            for (field, value) in requestHeaders {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        if method != .get, let params = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("Error serializing request body: \(error)")
                return nil
            }
        }
        
        // Debugging
        print("Request URL: \(request.url?.absoluteString ?? "Invalid URL")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody {
            print("Request Body: \(String(data: body, encoding: .utf8) ?? "Invalid Body")")
        }
        return request
    }
}
