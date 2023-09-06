//
//  ResponseBuffer.swift
//  Primal
//
//  Created by Nikola Lukovic on 1.6.23..
//

import Foundation
import GenericJSON

class PostRequestResult {
    var posts: [NostrContent] = []
    var mentions: [NostrContent] = []
    var reposts: [NostrRepost] = []
    var mediaMetadata: [MediaMetadata] = []
    var webPreviews: [WebPreviews] = []
    
    var order: [String] = []
    
    var users: [String: PrimalUser] = [:]
    var stats: [String: NostrContentStats] = [:]
    var userScore: [String: Int] = [:]
    
    var timestamps: [Date] = []
    
    var popularHashtags: [PopularHashtag] = []
    var notifications: [PrimalNotification] = []
    
    var encryptedMessages: [String] = []
    
    var isFollowingUser: Bool?
}

struct NostrRepost {
    let pubkey: String
    let post: NostrContent
    let date: Date
}

struct PopularHashtag {
    var title: String
    var apperances: Double
}
