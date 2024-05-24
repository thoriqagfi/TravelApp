//
//  UnsplashImageService.swift
//  TravelApp
//
//  Created by Agfi on 20/05/24.
//

import SwiftUI
import Combine

class UnsplashImageService: ObservableObject {
    @Published var image: UIImage?
    @Published var images: [UIImage?] = []
    private var cancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchImage(for query: String) {
        guard let url = URL(string: "https://api.unsplash.com/photos/random?query=\(query)&client_id=daUEA0uH6vRi4APkwOXA0tZKI-4SqXNkuoiIsanarpg") else {
            print("Invalid URL")
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: UnsplashImageResponse.self, decoder: JSONDecoder())
            .map { URL(string: $0.urls.regular) }
            .flatMap { url -> AnyPublisher<UIImage?, Never> in
                guard let url = url else {
                    return Just(nil).eraseToAnyPublisher()
                }
                return URLSession.shared.dataTaskPublisher(for: url)
                    .map { UIImage(data: $0.data) }
                    .replaceError(with: nil)
                    .eraseToAnyPublisher()
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func fetchSomeImages(for query: String, count: Int) {
        guard let url = URL(string: "https://api.unsplash.com/photos/random?query=\(query)&count=\(count)&client_id=daUEA0uH6vRi4APkwOXA0tZKI-4SqXNkuoiIsanarpg") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [UnsplashImageResponse].self, decoder: JSONDecoder())
            .flatMap { responses -> AnyPublisher<[UIImage?], Never> in
                let urls = responses.compactMap { URL(string: $0.urls.regular) }
                let publishers = urls.map { url in
                    URLSession.shared.dataTaskPublisher(for: url)
                        .map { UIImage(data: $0.data) }
                        .replaceError(with: nil)
                        .eraseToAnyPublisher()
                }
                return Publishers.MergeMany(publishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.images = images
            }
            .store(in: &cancellables)
    }
}

struct UnsplashImageResponse: Codable {
    let urls: ImageURLs
}

struct ImageURLs: Codable {
    let regular: String
}
