//
//  PublicProfileViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 10/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahCoreNext
import Resolver

struct ProfileUIData {
    let avatarCharacter: Character
    let avatar: URL?
    let avatarId: UUID?
    let name: String?
    let background: URL?
    let backgroundId: UUID?
    let city: String?
    let isVerified: Bool
    let isBusiness: Bool
    let activePeriod: String
    let about: String?
}

class PublicProfileViewModel {
    @Injected private var user: WhoppahCore.LegacyUserService
    @Injected private var merchant: MerchantService
    
    let coordinator: PublicProfileCoordinator

    private var myMerchant: LegacyMerchant? {
        didSet {
            if myMerchant != nil {
                outputs.onMerchantFetched.onNext(())
            }
        }
    }

    private var otherMerchant: LegacyMerchantOther? {
        didSet {
            if otherMerchant != nil {
                outputs.onMerchantFetched.onNext(())
            }
        }
    }

    private var activeMerchant: LegacyMerchantOther? {
        if myMerchant != nil { return myMerchant }
        return otherMerchant
    }

    typealias UIDataChanged = ((ProfileUIData) -> Void)
    struct Outputs {
        var uiData: Observable<ProfileUIData?> {
            _uiData.asObservable()
        }

        fileprivate var _uiData = BehaviorSubject<ProfileUIData?>(value: nil)
        let error = PublishSubject<Error>()

        let onMerchantFetched = BehaviorSubject<Void?>(value: nil)
    }

    let outputs = Outputs()

    private let bag = DisposeBag()

    init(coordinator: PublicProfileCoordinator) {
        self.coordinator = coordinator
        outputs.onMerchantFetched.onNext(())

        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated), name: InAppNotifier.NotificationName.userProfileUpdated.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated), name: InAppNotifier.NotificationName.userProfileAvatarUpdated.name, object: nil)

        // We watch the main user so we automatically get changes :)
        user.active.compactMap { $0 }.subscribe(onNext: { [weak self] member in
            guard let self = self else { return }
            self.myMerchant = member.mainMerchant
            let uiData = self.getProfileUIData()
            self.outputs._uiData.onNext(uiData)
        }, onError: { [weak self] error in
            self?.outputs.error.onNext(error)
        }).disposed(by: bag)
    }

    init(coordinator: PublicProfileCoordinator,
         id: UUID) {
        self.coordinator = coordinator
        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated), name: InAppNotifier.NotificationName.userProfileUpdated.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated), name: InAppNotifier.NotificationName.userProfileAvatarUpdated.name, object: nil)

        refreshMerchant(ID: id)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func getProfileUIData() -> ProfileUIData {
        guard let merchant = activeMerchant else { fatalError("Expected linked merchant account") }
        let city = merchant.primaryAddress?.city
        let about = merchant.biography
        let avatarUrl = URL(string: merchant.avatarImage?.url ?? "")
        let coverUrl = URL(string: merchant.coverImage?.url ?? "")
        let period = merchant.created.date.activeJoinPeriodText() ?? ""
        let character = merchant.getCharacterForAvatarIcon() ?? "-"
        let name = merchant.getDisplayName()
        return ProfileUIData(avatarCharacter: character,
                             avatar: avatarUrl,
                             avatarId: merchant.avatarImage?.id,
                             name: name,
                             background: coverUrl,
                             backgroundId: merchant.coverImage?.id,
                             city: city,
                             isVerified: merchant.isVerified,
                             isBusiness: merchant.type == .business,
                             activePeriod: period,
                             about: about)
    }

    func refreshMerchant() {
        guard let id = activeMerchant?.id else { return }
        refreshMerchant(ID: id)
    }

    func refreshMerchant(ID: UUID) {
        if ID == user.current?.merchantId {
            // We watch the main user so we automatically get changes :)
            user.active.compactMap { $0 }.subscribe(onNext: { [weak self] member in
                guard let self = self else { return }
                self.myMerchant = member.mainMerchant
                let uiData = self.getProfileUIData()
                self.outputs._uiData.onNext(uiData)
            }, onError: { [weak self] error in
                self?.outputs.error.onNext(error)
            }).disposed(by: bag)
        } else {
            merchant.get(id: ID)
                .subscribe(onNext: { [weak self] merchant in
                    guard let self = self else { return }
                    self.otherMerchant = merchant
                    let uiData = self.getProfileUIData()
                    self.outputs._uiData.onNext(uiData)
                }, onError: { [weak self] error in
                    self?.outputs.error.onNext(error)
                }).disposed(by: bag)
        }
    }

    func showEditControls() -> Bool {
        activeMerchant?.id == user.current?.merchantId
    }

    func uploadBackgroundImage(image: Data, _ completion: @escaping ((Result<UUID, Error>) -> Void)) {
        guard let id = myMerchant?.id else { return }
        merchant.setCover(id: id, data: image, existing: myMerchant?.coverImage?.id).subscribe(onNext: { [weak self] id in
            DispatchQueue.main.async {
                completion(.success(id))
            }
            self?.user.getActive()
        }, onError: { error in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }).disposed(by: bag)
    }

    func uploadAvatarImage(image: Data, _ completion: @escaping ((Result<UUID, Error>) -> Void)) {
        guard let id = myMerchant?.id else { return }
        merchant.setAvatar(id: id, data: image, existing: myMerchant?.avatarImage?.id).subscribe(onNext: { [weak self] id in
            DispatchQueue.main.async {
                completion(.success(id))
            }
            self?.user.getActive()
        }, onError: { error in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }).disposed(by: bag)
    }

    // MARK: Navigation

    func setupProfileCoordinator(coordinator: ProfileAdListCoordinator,
                                 delegate: ProfileAdListDelegate,
                                 listType: ProfileAdListViewModel.ListType) {
        guard let merchant = activeMerchant else {
            return
        }
        coordinator.start(merchant: merchant, listType: listType, delegate: delegate)
    }

    func editProfile() {
        guard let merchant = myMerchant else { return }
        coordinator.editProfile(merchant: merchant)
    }

    func showReportMenu() {
        guard let merchant = activeMerchant else { return }
        coordinator.showReportMenu(merchantId: merchant.id)
    }

    @objc func profileUpdated(_: Notification) {
        if showEditControls() {
            refreshMerchant()
        }
    }
}
