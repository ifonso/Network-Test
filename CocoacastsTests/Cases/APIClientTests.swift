//
//  APIClientTests.swift
//  CocoacastsTests
//
//  Created by Afonso Lucas on 17/12/23.
//

import XCTest
import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import Cocoacasts

final class APIClientTests: XCTestCase {
    
    // MARK: Utility
    
    private var cancellables: Set<AnyCancellable> = []
    private var stubsDescriptors: [HTTPStubsDescriptor] = []
    
    private let videoID = "1"

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        stubsDescriptors.forEach { stub in
            HTTPStubs.removeStub(stub)
        }
    }
    
    // MARK: - SignIn endpoint
    
    func testSignIn_Success() throws {
        runSignInTests(isSuccess: true)
    }
    
    func testSignIn_Failure() throws {
        runSignInTests(isSuccess: false)
    }
    
    private func runSignInTests(isSuccess: Bool) {
        let apiClient = APIClient(accessTokenProvider: MockAccessTokenProvider(accessToken: nil))
        let endpoint = Endpoint.auth(isSuccess: isSuccess)
        
        stubAPI(
            endpoint: endpoint,
            statusCode: isSuccess ? 200 : 401,
            response: .file(name: endpoint.stub)
        )
        .store(in: &stubsDescriptors)
        
        let expectation = XCTestExpectation(description: "SignIn")
        expectation.expectedFulfillmentCount = isSuccess ? 2 : 1
        
        apiClient.signIn(email: "test@cocoacasts.com", password: "1234567")
            .sink { completion in
                switch completion {
                case .finished:
                    if !isSuccess { XCTFail("Request Should Fail") }
                case .failure:
                    if isSuccess { XCTFail("Request Should Succeed") }
                }
                expectation.fulfill()
            } receiveValue: { signInResponse in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    // MARK: - Episodes endpoint
    
    func testEpisodes_Success() throws {
        runEpisodesTests(statusCode: 200)
    }
    
    func testEpisodes_Unauthorized() throws {
        runEpisodesTests(statusCode: 401)
    }
    
    func testEpisodes_NotFound() throws {
        runEpisodesTests(statusCode: 404)
    }
    
    private func runEpisodesTests(statusCode: StatusCode) {
        let apiClient = APIClient(accessTokenProvider: MockAccessTokenProvider(accessToken: nil))
        let endpoint = Endpoint.episodes
        
        stubAPI(
            endpoint: endpoint,
            statusCode: statusCode,
            response: .file(name: endpoint.stub)
        )
        .store(in: &stubsDescriptors)

        let expectation = XCTestExpectation(description: "Fetch Episodes")
        
        apiClient.episodes()
            .sink { completion in
                switch completion {
                case .finished:
                    if !statusCode.isSuccess { XCTFail("Request Should Fail") }
                case .failure(let error):
                    if statusCode.isSuccess { XCTFail("Request Should Succeed") }
                    
                    switch statusCode {
                    case 401:
                        XCTAssertEqual(error, APIError.unauthorized)
                    default:
                        XCTAssertEqual(error, APIError.failedRequest)
                    }
                }
                expectation.fulfill()
            } receiveValue: { episodes in
                XCTAssertEqual(episodes.count, 12)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    // MARK: - Video endpoint
    
    func testVideo_Success() throws {
        runVideoTest(isSuccess: true)
    }
    
    func testVideo_Failure() throws {
        runVideoTest(isSuccess: false)
    }
    
    private func runVideoTest(isSuccess: Bool) {
        let accessTokenProvider = MockAccessTokenProvider(accessToken: "fake_token")
        let apiClient = APIClient(accessTokenProvider: accessTokenProvider)
        
        let endpoint = Endpoint.video(id: videoID)
        
        stubAPI(
            endpoint: endpoint,
            statusCode: 200,
            response: isSuccess ? .file(name: endpoint.stub) : .data(data: Data())
        )
        .store(in: &stubsDescriptors)
        
        let expectation = XCTestExpectation(description: "Fetch Video")
        expectation.expectedFulfillmentCount = isSuccess ? 2 : 1
        
        apiClient.video(id: videoID)
            .sink { completion in
                switch completion {
                case .finished:
                    if !isSuccess { XCTFail("Request Should Fail") }
                case .failure(let error):
                    if isSuccess {
                        XCTFail("Request Should Succeed")
                    }
                    XCTAssertEqual(error, APIError.invalidResponse)
                }
                expectation.fulfill()
            } receiveValue: { video in
                expectation.fulfill()
                XCTAssertEqual(video.duration, 279)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    // MARK: - Progress for video endpoint
    
    func testProgressForVideo_Success() throws {
        runProgressForVideoTests()
    }
    
    func testProgressForVideo_Failure_NotConnected() throws {
        runProgressForVideoTests(urlErrorCode: .notConnectedToInternet)
    }
    
    func testProgressForVideo_Failure_CannotFindHost() throws {
        runProgressForVideoTests(urlErrorCode: .cannotFindHost)
    }
    
    private func runProgressForVideoTests(urlErrorCode: URLError.Code? = nil) {
        let apiClient = APIClient(accessTokenProvider: MockAccessTokenProvider(accessToken: "fake_token"))
        let endpoint = Endpoint.progressForVideo(id: videoID)
        
        if let code = urlErrorCode {
            simulateFailure(
                endpoint: endpoint,
                error: URLError(code)
            )
            .store(in: &stubsDescriptors)
        } else {
            stubAPI(
                endpoint: endpoint,
                statusCode: 200,
                response: .file(name: endpoint.stub)
            )
            .store(in: &stubsDescriptors)
        }
        
        let expectation = XCTestExpectation(description: "Progress For Video")
        
        apiClient.progressForVideo(id: videoID)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    if let code = urlErrorCode {
                        expectation.fulfill()
                        switch code {
                        case .notConnectedToInternet:
                            XCTAssertEqual(error, .unreachable)
                        default:
                            XCTAssertEqual(error, .failedRequest)
                        }
                    } else {
                        XCTFail("Request Should Succeed")
                    }
                }
            } receiveValue: { videoProgressResponse in
                XCTAssertEqual(videoProgressResponse.cursor, 124)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
    }
    
    // MARK: - UpdateProgressForVideo endpoint
    
    func testUpdateProgressForVideo_Success() throws {
        runUpdateProgressForVideo(isSuccess: true)
    }
    
    func testUpdateProgressForVideo_Failure() throws {
        runUpdateProgressForVideo(isSuccess: false)
    }
    
    private func runUpdateProgressForVideo(isSuccess: Bool) {
        let apiClient = APIClient(accessTokenProvider: MockAccessTokenProvider(accessToken: "fake_token"))
        let endpoint = Endpoint.updateProgressForVideo(id: videoID)
        
        if isSuccess {
            stubAPI(
                endpoint: endpoint,
                statusCode: isSuccess ? 200 : 401,
                response: .file(name: endpoint.stub)
            )
            .store(in: &stubsDescriptors)
        } else {
            simulateFailure(
                endpoint: endpoint,
                error: URLError(.notConnectedToInternet)
            )
            .store(in: &stubsDescriptors)
        }
        
        let expectation = XCTestExpectation(description: "Update Progress For Video")
        expectation.expectedFulfillmentCount = isSuccess ? 2 : 1
        
        apiClient.updateProgressForVideo(id: videoID, cursor: 10)
            .sink { completion in
                switch completion {
                case .finished:
                    if !isSuccess { XCTFail("Request Should Fail") }
                case .failure:
                    if isSuccess { XCTFail("Request Should Succeed") }
                }
                expectation.fulfill()
            } receiveValue: { videoProgressResponse in
                expectation.fulfill()
                XCTAssertEqual(videoProgressResponse.cursor, 124)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
    }
    
    // MARK: - Delete progress endpoint
    
    func testDeleteProgressForVideo_Authorized() throws {
        runDeleteProgressForVideoTests(isAuthorized: true)
    }
    
    func testDeleteProgressForVideo_Unauthorized() throws {
        runDeleteProgressForVideoTests(isAuthorized: false)
    }
    
    private func runDeleteProgressForVideoTests(isAuthorized: Bool) {
        let apiClient = APIClient(accessTokenProvider: MockAccessTokenProvider(accessToken: isAuthorized ? "fake_token" : nil))
        let endpoint = Endpoint.deleteVideoProgress(id: videoID)
        
        stubAPI(
            endpoint: endpoint,
            statusCode: 204,
            response: .data(data: Data())
        )
        .store(in: &stubsDescriptors)
        
        let expectation = XCTestExpectation(description: "Delete Progress For Video")
        
        apiClient.deleteProgressForVideo(id: videoID)
            .sink { completion in
                switch completion {
                case .finished:
                    if !isAuthorized { XCTFail("Request Should Fail due to an unauthorized user") }
                case .failure(let error):
                    if isAuthorized {
                        XCTFail("Request Should Succeed due to authorized user")
                    } else {
                        XCTAssertEqual(error, APIError.unauthorized)
                    }
                }
                expectation.fulfill()
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
}

fileprivate enum Endpoint {
    
    case auth(isSuccess: Bool)
    case episodes
    case video(id: String)
    case updateProgressForVideo(id: String)
    case progressForVideo(id: String)
    case deleteVideoProgress(id: String)
    
    var path: String {
        let path: String = {
            switch self {
            case .auth:
                return "auth"
            case .episodes:
                return "episodes"
            case .video(let id):
                return "videos/\(id)"
            case .deleteVideoProgress(let id),
                 .progressForVideo(let id),
                 .updateProgressForVideo(let id):
                return "videos/\(id)/progress"
            }
        }()
        
        return "/api/v1/" + path
    }
    
    var stub: String {
        switch self {
        case .auth(let success):
            return success ? "auth-success.json" : "auth-failure.json"
        case .episodes:
            return "episodes.json"
        case .video:
            return "video.json"
        case .updateProgressForVideo:
            return "update-progress-for-video.json"
        case .progressForVideo:
            return "video-progress.json"
        case .deleteVideoProgress:
            fatalError("This endpoint doesnt define a stub.")
        }
    }
}

fileprivate extension APIClientTests {
    
    enum Response {
        case data(data: Data)
        case file(name: String)
    }
    
    func simulateFailure(endpoint: Endpoint, error: Error) -> HTTPStubsDescriptor {
        stub { request in
            request.url?.path() == endpoint.path
        } response: { _ in
            HTTPStubsResponse(error: error)
        }
    }
    
    func stubAPI(endpoint: Endpoint, statusCode: StatusCode, response: Response) -> HTTPStubsDescriptor {
        stub { request in
            request.url?.path() == endpoint.path
        } response: { request in
            if statusCode.isSuccess {
                switch response {
                case .data(let data):
                    return HTTPStubsResponse(data: data, statusCode: Int32(statusCode), headers: nil)
                case .file(let file):
                    guard let filePath = OHPathForFile(file, type(of: self))
                    else { fatalError("Unable to Find Stub in bundle") }
                    
                    return fixture(filePath: filePath, status: Int32(statusCode), headers: [:])
                }
                
            } else {
                return HTTPStubsResponse(data: Data(), statusCode: Int32(statusCode), headers: nil)
            }
        }
    }
}
