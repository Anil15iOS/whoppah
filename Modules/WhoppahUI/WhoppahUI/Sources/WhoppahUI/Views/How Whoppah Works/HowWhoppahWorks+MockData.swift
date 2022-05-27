//
//  HowWhoppahWorks+MockData.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 10/11/2021.
//

import Foundation

public extension HowWhoppahWorks.Model {
    static var mock: Self {
        let pages = [
            Page(pageId: "payments",
                 overviewTitle: "Payments",
                 headerTitle: "About Payments",
                 longTitle: "All about Payments on Whoppah",
                 overviewIconName: "payments_pink_icon",
                 iconName: "security_green_icon",
                 sectionBackgroundColor: WhoppahTheme.Color.support2,
                 sectionForegroundColor: WhoppahTheme.Color.primary2,
                 sections: [
                    Section(headerIconName: "large_1",
                            title: "Buyer pays safely",
                            description: Lipsum.randomParagraph,
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
                            title: "Money is safe at Whoppah",
                            description: Lipsum.randomParagraph),
                    Section(headerIconName: "large_3",
                            title: "Buyers confirm item received",
                            description: Lipsum.random(numberOfParagraphs: 2)),
                    Section(headerIconName: "large_4",
                            title: "Seller gets paid",
                            description: Lipsum.randomParagraph),
                    Section(headerIconName: "stripe_logo",
                            description: Lipsum.random(numberOfParagraphs: 4))
                 ]),
            Page(pageId: "shipping_delivery",
                 overviewTitle: "Shipping & Delivery",
                 headerTitle: "About Shipping & Delivery",
                 longTitle: "All about Shipping & Delivery on Whoppah",
                 overviewIconName: "shipping_pink_icon",
                 iconName: "shipping_blue_icon",
                 sectionBackgroundColor: WhoppahTheme.Color.support4,
                 sectionForegroundColor: WhoppahTheme.Color.alert3,
                 sections: [
                    Section(headerIconName: "courier_icon",
                            title: "Whoppah courier",
                            description: Lipsum.random(numberOfParagraphs: 2),
                            additionalContent: CourierAdditionalContent(
                                foregroundColor: WhoppahTheme.Color.alert3,
                                backgroundColor: WhoppahTheme.Color.base4,
                                costLabelColor: WhoppahTheme.Color.base1,
                                courierOptions: [
                                    CourierAdditionalContent.CourierOption(iconName: "shipping_nofill_icon", title: "Up to 2 meters", cost: "€ 79"),
                                    CourierAdditionalContent.CourierOption(iconName: "shipping_nofill_icon", title: "From 2 meters", cost: "€ 99"),
                                    CourierAdditionalContent.CourierOption(iconName: "shipping_nofill_icon", title: "Netherlands - Belgium", cost: "€ 129")
                                ],
                                callToAction: CourierAdditionalContent.CallToAction(
                                    iconName: "spark_white",
                                    backgroundColor: WhoppahTheme.Color.alert3,
                                    foregroundColor: WhoppahTheme.Color.base4,
                                    title: "Book the courier"))),
                    Section(headerIconName: "parcel_icon",
                            title: "Parcel post",
                            description: Lipsum.randomParagraph,
                            additionalContent: CourierAdditionalContent(
                                foregroundColor: WhoppahTheme.Color.alert3,
                                backgroundColor: WhoppahTheme.Color.base4,
                                costLabelColor: WhoppahTheme.Color.base1,
                                courierOptions: [
                                    CourierAdditionalContent.CourierOption(iconName: "parcel_nofill_icon", title: "Postal package €7,25", cost: "Max 100x50x50 cm and 0-10 kg"),
                                    CourierAdditionalContent.CourierOption(iconName: "parcel_nofill_icon", title: "Registered package €10", cost: "Max 176x78x78 cm and 10-23 kg")
                                ])),
                    Section(headerIconName: "home_icon",
                            title: "Pick it up yourself",
                            description: Lipsum.random(numberOfParagraphs: 2)),
                    Section(headerIconName: "globe_icon",
                            title: "International shipping",
                            description: Lipsum.randomParagraph)
                 ]),
            Page(pageId: "bidding",
                 overviewTitle: "How bidding works",
                 headerTitle: "About Bidding",
                 longTitle: "All about Bidding on Whoppah",
                 overviewIconName: "bidding_pink_icon",
                 iconName: "bidding_yellow_icon",
                 sectionBackgroundColor: WhoppahTheme.Color.support6,
                 sectionForegroundColor: WhoppahTheme.Color.primary3,
                 sections: [
                    Section(headerIconName: "large_1",
                            title: "Place a bid",
                            description: Lipsum.random(numberOfParagraphs: 2)),
                    Section(headerIconName: "large_2",
                            title: "48 hours valid",
                            description: Lipsum.randomParagraph),
                    Section(headerIconName: "large_3",
                            title: "Counter offer",
                            description: Lipsum.randomParagraph),
                    Section(headerIconName: "large_4",
                            title: "Deal = deal",
                            description: Lipsum.randomParagraph)
                 ]),
            Page(pageId: "curation",
                 overviewTitle: "Curation rules",
                 headerTitle: "About Curation",
                 longTitle: "All about Curation on Whoppah",
                 overviewIconName: "curation_pink_icon",
                 iconName: "curation_pink_icon",
                 sectionBackgroundColor: WhoppahTheme.Color.support1,
                 sectionForegroundColor: WhoppahTheme.Color.primary1,
                 sections: [
                    Section(headerIconName: "large_1",
                            title: "Design or unique vintage",
                            description: Lipsum.randomParagraph),
                    Section(headerIconName: "large_2",
                            title: "Good quality photos",
                            description: Lipsum.randomParagraph,
                            additionalContent: PhotoQualityAdditionalContent(
                                ctaIconName: "camera_icon",
                                ctaBackgroundColor: WhoppahTheme.Color.primary1,
                                ctaForegroundColor: WhoppahTheme.Color.base4,
                                ctaTitle: "Read our photo guide")),
                    Section(headerIconName: "large_3",
                            title: "Minimal good condition",
                            description: Lipsum.randomParagraph),
                    Section(headerIconName: "large_4",
                            title: "Provide a full description",
                            description: Lipsum.randomParagraph),
                    Section(headerIconName: "large_5",
                            title: "Selling opportunity",
                            description: Lipsum.randomParagraph),
                    Section(headerIconName: "large_6",
                            title: "An appropriate price",
                            description: Lipsum.randomParagraph)
                 ]),
            Page(pageId: "faqs",
                 overviewTitle: "Frequently asked questions",
                 headerTitle: "Frequently Asked Questions",
                 longTitle: "Frequently asked questions",
                 overviewIconName: "faq_pink_icon",
                 iconName: "faq_yellow_icon",
                 sectionBackgroundColor: WhoppahTheme.Color.base4,
                 sectionForegroundColor: WhoppahTheme.Color.base1,
                 sections: [
                    Section(
                        additionalContent: FAQAdditionalContent(
                            searchBoxPlaceholderText: "We are here to help :)",
                            questionsAndAnswers: [
                                FAQAdditionalContent.QuestionAndAnswer(question: "Question 1", answer: Lipsum.randomParagraph),
                                FAQAdditionalContent.QuestionAndAnswer(question: "Question 2", answer: Lipsum.randomParagraph),
                                FAQAdditionalContent.QuestionAndAnswer(question: "Question 3", answer: Lipsum.randomParagraph),
                                FAQAdditionalContent.QuestionAndAnswer(question: "Question 4", answer: Lipsum.randomParagraph),
                                FAQAdditionalContent.QuestionAndAnswer(question: "Question 5", answer: Lipsum.randomParagraph),
                                FAQAdditionalContent.QuestionAndAnswer(question: "Question 6", answer: Lipsum.randomParagraph)
                             ],
                             contactTitle: "We are here to help",
                             emailIconName: "contact_email_icon",
                             emailDescription: "Do you have a question? Send an email to the Whoppah Support team and we will get back to you as soon as possible: support@whoppah.com",
                             phoneIconName: "contact_phone_icon",
                             phoneDescription: "Whoppah is available Monday to Friday during office hours on: +31 (0) 20 244 46 93."),
                        ignorePadding: true
                    )
                 ]
                 )
        ]
        return Self(title: "How Whoppah works",
                    pages: pages)
    }
}
