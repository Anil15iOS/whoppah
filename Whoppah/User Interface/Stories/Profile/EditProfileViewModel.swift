//
//  EditProfileViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 10/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import Foundation
import RxSwift
import WhoppahCore
import Resolver

struct EditProfileUIData {
    let name: String
    let about: String
}

class EditProfileViewModel {
    @Injected private var merchantService: MerchantService
    
    private var merchant: LegacyMerchant
    private let coordinator: EditProfileCoordinator

    init(coordinator: EditProfileCoordinator,
         merchant: LegacyMerchant) {
        self.merchant = merchant
        self.coordinator = coordinator
    }

    func getUIData() -> EditProfileUIData {
        EditProfileUIData(name: merchant.name,
                          about: merchant.biography ?? "")
    }

    func save(profileData: EditProfileUIData) -> Observable<UUID> {
        var memberInput = LegacyMerchantInput(merchant: merchant)
        memberInput.name = profileData.name
        memberInput.biography = profileData.about
        return merchantService.update(memberInput)
    }
}
