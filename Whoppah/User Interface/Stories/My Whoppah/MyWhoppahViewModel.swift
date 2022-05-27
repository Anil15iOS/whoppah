//
//  MyWhoppahViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 16/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver
import Combine
import WhoppahDataStore

struct MyWhoppahUIData {
    let avatarCharacter: Character
    let avatarUrl: URL?
    let avatarId: UUID?
    let name: String
    let city: String?
    let isVerified: Bool
}

class MyWhoppahViewModel {
    private var user: LegacyMember?
    @LazyInjected private var userProvider: UserProviding
    @Injected private var merchantService: MerchantService
    @Injected private var adService: ADsService
    @Injected private var eventTracking: EventTrackingService
    private let coordinator: MyWhoppahCoordinator

    struct Outputs {
        var uiData: Observable<MyWhoppahUIData?> {
            _uiData.asObservable()
        }

        fileprivate var _uiData = BehaviorRelay<MyWhoppahUIData?>(value: nil)
    }

    let outputs = Outputs()

    private let bag = DisposeBag()
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: MyWhoppahCoordinator) {
        self.coordinator = coordinator

        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated), name: InAppNotifier.NotificationName.userProfileUpdated.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated), name: InAppNotifier.NotificationName.userProfileAvatarUpdated.name, object: nil)

        userProvider.currentUserPublisher?.sink(receiveValue: { [weak self] member in
            guard let self = self,
                  let legacyMember = member?.rawObject as? GraphQL.GetMeQuery.Data.Me
            else { return }
            
            self.user = legacyMember
            self.outputs._uiData.accept(self.getUIData())
        })
            .store(in: &cancellables)
    }

    func loadUser() {
        userProvider.fetchActiveUser()
    }

    func getUIData() -> MyWhoppahUIData {
        guard let merchant = user?.mainMerchant else {
            fatalError("Expected associated merchant")
        }
        let city = merchant.address.first?.city
        let avatar = URL(string: merchant.avatarImage?.url ?? "")
        let character = merchant.getCharacterForAvatarIcon() ?? "-"
        let name = merchant.name
        let isVerified = merchant.isVerified
        return MyWhoppahUIData(avatarCharacter: character,
                               avatarUrl: avatar,
                               avatarId: merchant.avatarImage?.id,
                               name: name,
                               city: city,
                               isVerified: isVerified)
    }

    func showPublicProfile() {
        coordinator.showPublicProfile()
    }

    func editProfile() {
        guard let user = user else { return }
        coordinator.showEditProfile(merchant: user.mainMerchant)
    }

    @objc func profileUpdated(_: Notification) {
        loadUser()
    }
}
