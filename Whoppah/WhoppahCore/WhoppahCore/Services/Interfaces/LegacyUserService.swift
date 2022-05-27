//
//  LegacyUserService.swift
//  Whoppah
//
//  Created by Eddie Long on 27/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import WhoppahModel
import WhoppahDataStore

public protocol LegacyUserService {
    /// The current logged in member
    var current: LegacyMember? { get }
    /// The current logged in member, as an observable
    var active: BehaviorSubject<LegacyMember?> { get }

    // Whether there is a user logged in
    // NOTE: A user being logged does not mean that there is definitely a member
    //       Being logged in merely means you're authorized, i.e. have a valid access token
    var isLoggedIn: Bool { get }

    // Whether the user should log out or just clear the token
    // This is caused by the backend not requiring certain token types to log out
    // Such as Bearer
    var requiresLogout: Bool { get }
    
    /// Fetch the current active user. This will refresh data from the backend
    func getActive()

    /// Updates the member data for the logged in user
    ///
    /// - Parameter id The id of the member to update. NOTE: Must be the current logged in user
    /// - Parameter merchant The updated member data
    /// - Returns: An observable with the updated member uuid
    func update(id: UUID, member: LegacyMemberInput) -> Observable<UUID>

    /// Gets the current notification settings for the logged in user
    ///
    /// - Parameter completion A Result object that contains the notification settings object on success, Error on failure
    func getNotificationSettings(completion handler: @escaping (Swift.Result<NotificationSettings, Error>) -> Void)

    /// Updates the notification settings for the current logged in user
    ///
    /// - Parameter settings The updated notification settings
    /// - Parameter completion A Result object that contains the notification settings object on success, Error on failure
    func updateNotificationSettings(settings: NotificationSettings, completion handler: @escaping (Swift.Result<NotificationSettings, Error>) -> Void)

    /// Fetches the list of saved search items from the server
    ///
    /// - Returns: An observable with the list of saved searches
    func getMySearches() -> Observable<[GraphQL.SavedSearchesQuery.Data.SavedSearch.Item]>

    /// Saves a given search
    ///
    /// - Parameter search The search data to save
    /// - Returns: An observable with the newly created search identifier
    func saveSearch(search: GraphQL.SavedSearchInput) -> Observable<UUID?>

    /// Deletes a saved search
    ///
    /// - Parameter id The identifier of the search to delete
    /// - Returns: An observable with no data returned
    func deleteSearch(id: UUID) -> Observable<Void>

    /// Sends the given text to the backend as a support request
    ///
    /// - Parameter text The text to send to the backend from the user
    /// - Returns: An observable with no data returned
    func sendQuestionForSupport(text: String) -> Observable<Void>
}
