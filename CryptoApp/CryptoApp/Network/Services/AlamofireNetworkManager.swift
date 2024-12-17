//
//  AlamofireNetworkManager.swift
//  CryptoApp
//
//  Created by Rockz on 16/12/24.
//


import Foundation
import Combine
import Alamofire

// Define a NetworkError enum for error handling
enum NetworkError: Error {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingError
    case responseError(String)
    case unknownError
}

// Protocol for NetworkManager
protocol AlamofireNetworkManagerProtocol {
    func request<T: Decodable>(
        type: T.Type,
        router: URLRouter,
        parameters: [String: Any]?,
        headers: [String: String]?,
        count: Int,
        method: HTTPMethod
    ) -> AnyPublisher<Result<T, NetworkError>, Never>

    func requestString(
        router: URLRouter,
        parameters: [String: Any]?,
        headers: [String: String]?,
        count: Int,
        method: HTTPMethod
    ) -> AnyPublisher<Result<String, NetworkError>, Never>

    func requestJSON(
        router: URLRouter,
        parameters: [String: Any]?,
        headers: [String: String]?,
        count: Int,
        method: HTTPMethod
    ) -> AnyPublisher<Result<Any, NetworkError>, Never>
}

final class AlamofireNetworkManager: AlamofireNetworkManagerProtocol {
    func request<T: Decodable>(
        type: T.Type,
        router: URLRouter,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        count: Int,
        method: HTTPMethod
    ) -> AnyPublisher<Result<T, NetworkError>, Never> {
        guard let url = buildURL(router: router, count: count) else {
            return Just(Result.failure(NetworkError.invalidURL)).eraseToAnyPublisher()
        }

        return Future { promise in
            AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(headers ?? [:]))
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        promise(.success(Result.success(decodedData)))
                    case .failure(let error):
                        promise(.success(Result.failure(self.mapError(error, response: response))))
                    }
                }
        }.eraseToAnyPublisher()
    }

    func requestString(
        router: URLRouter,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        count: Int,
        method: HTTPMethod
    ) -> AnyPublisher<Result<String, NetworkError>, Never> {
        guard let url = buildURL(router: router, count: count) else {
            return Just(Result.failure(NetworkError.invalidURL)).eraseToAnyPublisher()
        }

        return Future { promise in
            AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(headers ?? [:]))
                .validate()
                .responseString { response in
                    switch response.result {
                    case .success(let responseString):
                        promise(.success(Result.success(responseString)))
                    case .failure(let error):
                        promise(.success(Result.failure(self.mapError(error, response: response))))
                    }
                }
        }.eraseToAnyPublisher()
    }

    func requestJSON(
        router: URLRouter,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        count: Int,
        method: HTTPMethod
    ) -> AnyPublisher<Result<Any, NetworkError>, Never> {
        guard let url = buildURL(router: router, count: count) else {
            return Just(Result.failure(NetworkError.invalidURL)).eraseToAnyPublisher()
        }

        return Future { promise in
            AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(headers ?? [:]))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        promise(.success(Result.success(json)))
                    case .failure(let error):
                        promise(.success(Result.failure(self.mapError(error, response: response))))
                    }
                }
        }.eraseToAnyPublisher()
    }

    // Build the full URL for the request
    private func buildURL(router: URLRouter, count: Int) -> URL? {
        let baseURL = count == 1 ? Constant.secondarybaseURL : Constant.baseURL
        let urlString = Constant.scheme + baseURL + router.path
        return URL(string: urlString)
    }

    // Map Alamofire errors to NetworkError
    private func mapError<T>(_ error: AFError, response: DataResponse<T, AFError>) -> NetworkError {
        if let httpResponse = response.response {
            if !(200...299).contains(httpResponse.statusCode) {
                return .serverError(statusCode: httpResponse.statusCode)
            }
        }

        if let underlyingError = error.underlyingError as? DecodingError {
            return .decodingError
        }

        if let responseData = response.data, let errorString = String(data: responseData, encoding: .utf8) {
            return .responseError(errorString)
        }

        return .unknownError
    }
}
