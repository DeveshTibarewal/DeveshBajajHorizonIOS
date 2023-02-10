//
//  ModelVideo.swift
//  Horizon
//
//  Created by Devesh Tibarewal on 10/02/23.
//

import Foundation

struct ModelVideo: Codable {
    let page: Int?
    let per_page: Int?
    let videos: [Video]?
    let total_results: Int?
    let next_page: String?
}

struct Video: Codable {
    let id: Int?
    let photographer: String?
    let user: User?
    let image: String?
    let video_files: [VideoSource]?
}

struct VideoSource: Codable {
    let id: Int?
    let quality: String?
    let file_type: String?
    let width: Int?
    let height: Int?
    let link: String?
}

struct User: Codable {
    let id: Int?
    let name: String?
    let url: String?
}
