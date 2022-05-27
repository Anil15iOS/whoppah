//
//  HowWhoppahWorks+Localization.swift
//  Whoppah
//
//  Created by Dennis Ippel on 15/11/2021.
//  Copyright © 2021 Whoppah. All rights reserved.
//

import WhoppahUI
import ComposableArchitecture
import Lokalise
import WhoppahLocalization

extension HowWhoppahWorks.Model: StaticContentLocalizable {
    public static var localized: Self {
        typealias l = R.string.localizable
        
        let pages = [
        Page(pageId: "payments",
             overviewTitle: l.navPayment(),
             headerTitle: l.navPayment(),
             longTitle: l.paymentPageTitle(),
             overviewIconName: "payments_pink_icon",
             iconName: "security_green_icon",
             sectionBackgroundColor: WhoppahTheme.Color.support2,
             sectionForegroundColor: WhoppahTheme.Color.primary2,
             sections: [
                Section(headerIconName: "large_1",
                        title: l.buyersPaySafelyTitle(),
                        description: l.buyersPaySafelyDescription(),
                        additionalContent: PaymentAdditionalContent(
                            heroLogoName: "stripe_logo",
                            paymentLogoNames: [
                                "ideal_logo",
                                "bancontact_logo",
                                "visa_logo",
                                "mastercard_logo",
                                "maestro_logo",
                                "american_express_logo",
                                "apple_pay_logo"
                            ]
                            )
                        ),
                Section(headerIconName: "large_2",
                        title: l.moneySafeTitle(),
                        description: l.moneySafeDescription()),
                Section(headerIconName: "large_3",
                        title: l.buyersConfirmTitle(),
                        description: l.buyersConfirmDescription()),
                Section(headerIconName: "large_4",
                        title: l.sellersGetPaidTitle(),
                        description: l.sellersGetPaidDescription())
             ]),
        Page(pageId: "shipping_delivery",
             overviewTitle: l.navShipping(),
             headerTitle: l.navShipping(),
             longTitle: l.navShipping(),
             overviewIconName: "shipping_pink_icon",
             iconName: "shipping_blue_icon",
             sectionBackgroundColor: WhoppahTheme.Color.support4,
             sectionForegroundColor: WhoppahTheme.Color.alert3,
             sections: [
                Section(headerIconName: "courier_icon",
                        title: l.whoppahCourierTitle(),
                        description: l.whoppahCourierDescription(),
                        additionalContent: CourierAdditionalContent(
                            foregroundColor: WhoppahTheme.Color.alert3,
                            backgroundColor: WhoppahTheme.Color.base4,
                            costLabelColor: WhoppahTheme.Color.base1,
                            courierOptions: [
                                CourierAdditionalContent.CourierOption(
                                    iconName: "shipping_nofill_icon",
                                                                       
                                    title: l.deliveryMethodsPageDistanceTo2Title(),
                                                                       
                                    cost: l.deliveryMethodsPageDistanceTo2Cost()),
                                CourierAdditionalContent.CourierOption(
                                    iconName: "shipping_nofill_icon",
                                    title: l.deliveryMethodsPageDistanceFrom2Title(),
                                    cost: l.deliveryMethodsPageDistanceFrom2Cost()),
                                CourierAdditionalContent.CourierOption(
                                    iconName: "shipping_nofill_icon",
                                    title: l.deliveryMethodsPageDistanceToBelgiumTitle(),
                                    cost: l.deliveryMethodsPageDistanceToBelgiumCost())
                            ],
                            callToAction: CourierAdditionalContent.CallToAction(
                                iconName: "spark_white",
                                backgroundColor: WhoppahTheme.Color.alert3,
                                foregroundColor: WhoppahTheme.Color.base4,
                                title: l.bookCourierNow()))),
                Section(headerIconName: "parcel_icon",
                        title: l.postPackageTitle(),
                        description: l.postPackageDescription(),
                        additionalContent: CourierAdditionalContent(
                            foregroundColor: WhoppahTheme.Color.alert3,
                            backgroundColor: WhoppahTheme.Color.base4,
                            costLabelColor: WhoppahTheme.Color.base1,
                            courierOptions: [
                                CourierAdditionalContent.CourierOption(
                                    iconName: "parcel_nofill_icon",
                                    title: l.deliveryMethodsPageMethodPackageTitle(),
                                    cost: l.deliveryMethodsPageMethodPackageDimensions()),
                                CourierAdditionalContent.CourierOption(
                                    iconName: "parcel_nofill_icon",
                                    title: l.deliveryMethodsPageMethodRegisteredTitle(),
                                    cost: l.deliveryMethodsPageMethodRegisteredDimensions())
                            ])),
                Section(headerIconName: "home_icon",
                        title: l.pickUpTitle(),
                        description: l.pickUpDescription()),
                Section(headerIconName: "globe_icon",
                        title: l.internationalShippingTitle(),
                        description: l.internationalShippingDescription())
             ]),
        Page(pageId: "bidding",
             overviewTitle: l.biddingPageTitle(),
             headerTitle: l.biddingPageTitle(),
             longTitle: l.biddingPageTitle(),
             overviewIconName: "bidding_pink_icon",
             iconName: "bidding_yellow_icon",
             sectionBackgroundColor: WhoppahTheme.Color.support6,
             sectionForegroundColor: WhoppahTheme.Color.primary3,
             sections: [
                Section(headerIconName: "large_1",
                        title: l.placeBidTitle(),
                        description: l.placeBidDescription()),
                Section(headerIconName: "large_2",
                        title: l.hoursValidTitle(),
                        description: l.hoursValidDescription()),
                Section(headerIconName: "large_3",
                        title: l.counterbidTitle(),
                        description: l.counterbidDescription()),
                Section(headerIconName: "large_4",
                        title: l.dealIsDealTitle(),
                        description: l.dealIsDealDescription())
             ]),
        Page(pageId: "curation",
             overviewTitle: l.curationPageTitle(),
             headerTitle: l.curationPageTitle(),
             longTitle: l.curationPageTitle(),
             overviewIconName: "curation_pink_icon",
             iconName: "curation_pink_icon",
             sectionBackgroundColor: WhoppahTheme.Color.support1,
             sectionForegroundColor: WhoppahTheme.Color.primary1,
             sections: [
                Section(headerIconName: "large_1",
                        title: l.designOrUniqueVintageTitle(),
                        description: l.designOrUniqueVintageDescription()),
                Section(headerIconName: "large_2",
                        title: l.photographyTitle(),
                        description: l.photographyDescription()),
                Section(headerIconName: "large_3",
                        title: l.goodConditionTitle(),
                        description: l.goodConditionDescription()),
                Section(headerIconName: "large_4",
                        title: l.fullDescriptionTitle(),
                        description: l.fullDescriptionDescription()),
                Section(headerIconName: "large_5",
                        title: l.demandVintageTitle(),
                        description: l.demandVintageDescription()),
                Section(headerIconName: "large_6",
                        title: l.appropriatePriceTitle(),
                        description: l.appropriatePriceDescription())
             ]),
        Page(pageId: "faqs",
             overviewTitle: l.navFaq(),
             headerTitle: l.navFaq(),
             longTitle: l.navFaq(),
             overviewIconName: "faq_pink_icon",
             iconName: "faq_yellow_icon",
             sectionBackgroundColor: WhoppahTheme.Color.base4,
             sectionForegroundColor: WhoppahTheme.Color.base1,
             sections: [
                Section(
                    additionalContent: FAQAdditionalContent(
                        searchBoxPlaceholderText: l.howCanWeHelp(),
                        questionsAndAnswers: [
                            FAQAdditionalContent.QuestionAndAnswer(
                                question: l.faqOfferTitle(),
                                answer: l.faqOfferDescription()),
                            FAQAdditionalContent.QuestionAndAnswer(
                                question: l.faqBuyingTitle(),
                                answer: l.faqBuyingDescription()),
                            FAQAdditionalContent.QuestionAndAnswer(
                                question: l.faqBiddingTitle(),
                                answer: l.faqBiddingDescription()),
                            FAQAdditionalContent.QuestionAndAnswer(
                                question: l.faqSellingTitle(),
                                answer: l.faqSellingDescription()),
                            FAQAdditionalContent.QuestionAndAnswer(
                                question: l.faqSafeshoppingTitle(),
                                answer: l.faqSafeshoppingDescription()),
                            FAQAdditionalContent.QuestionAndAnswer(
                                question: l.faqCreateAdTitle(),
                                answer: l.faqCreateAdDescription()),
                            FAQAdditionalContent.QuestionAndAnswer(
                                question: l.faqShippingTitle(),
                                answer: l.faqShippingDescription()),
                            FAQAdditionalContent.QuestionAndAnswer(
                                question: l.faqFeesTitle(),
                                answer: l.faqFeesDescription()),
                            FAQAdditionalContent.QuestionAndAnswer(
                                question: l.faqMyAccountTitle(),
                                answer: l.faqMyAccountDescription())
                         ],
                        contactTitle: l.faqContactTitle(),
                         emailIconName: "contact_email_icon",
                        emailDescription: l.hwwContactDescription(),
                         phoneIconName: "contact_phone_icon",
                        phoneDescription: l.faqTopicAnswerText()),
                    ignorePadding: true
                )
             ]
         )
    ]
        return Self(title: l.howWhoppahWorksTitle(),
                pages: pages)
    }
}
