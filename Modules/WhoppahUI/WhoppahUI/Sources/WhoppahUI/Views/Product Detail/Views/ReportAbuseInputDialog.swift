//
//  ReportAbuseInputDialog.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 04/05/2022.
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct ReportAbuseInputDialog: View {
    @Binding private var abuseReportType: WhoppahModel.AbuseReportType
    
    @State private var isDescriptionValid: Bool = false
    @State private var descriptionValue: String = ""
    @State private var selectedReason: AbuseReportReason = .violatingContent
    @State private var buttonIsShowingProgress: Bool = false
    
    private let viewStore: ViewStore<ProductDetailView.ViewState, ProductDetailView.Action>
    private let model: ProductDetailView.Model.HeroImageComponent
    private let product: WhoppahModel.Product
    
    let cancelButtonAction: () -> Void
    
    var title: String {
        abuseReportType == .product ? model.reportAdButtonTitle : model.reportUserButtonTitle
    }
    
    var description: String {
        abuseReportType == .product ? model.reportAdDescription : model.reportUserDescription
    }
    
    var allReasons: [AbuseReportReason] {
        var reasons = AbuseReportReason.allCases
        reasons.removeAll(where: { $0 == .unknown })
        return reasons
    }
    
    public init(viewStore: ViewStore<ProductDetailView.ViewState, ProductDetailView.Action>,
                abuseReportType: Binding<WhoppahModel.AbuseReportType>,
                product: WhoppahModel.Product,
                cancelButtonAction: @escaping () -> Void)
    {
        self.viewStore = viewStore
        self.product = product
        self._abuseReportType = abuseReportType
        self.cancelButtonAction = cancelButtonAction
        self.model = viewStore.model.heroImageComponent
    }
    
    var body: some View {
        KeyboardEnabledView(doneButtonTitle: model.doneButtonTitle) {
            ModalDialog(title: title,
                        description: description)
            {
                cancelButtonAction()
            } content: {
            
                VStack {
                    
                    ///
                    /// ✔ Reason
                    ///
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: WhoppahTheme.Size.CTA.cornerRadius)
                            .fill(Color.white)
                        RoundedRectangle(cornerRadius: WhoppahTheme.Size.Radius.small)
                            .stroke(WhoppahTheme.Color.base10, lineWidth: 1)
                        HStack(spacing: 0) {
                            Text("\(model.reportReason): ")
                                .font(WhoppahTheme.Font.subtitle)
                                .foregroundColor(WhoppahTheme.Color.base2)
                                .padding(.vertical, WhoppahTheme.Size.Padding.mediumSmall)
                                .padding(.leading, WhoppahTheme.Size.Padding.mediumSmall)
                                .padding(.trailing, 0)

                            ZStack(alignment: .center) {
                                HStack {
                                    Spacer()
                                    Image("dropdown", bundle: .module)
                                        .padding(.trailing, WhoppahTheme.Size.Padding.mediumSmall)
                                }
                                
                                Menu {
                                    ForEach(allReasons, id: \.self) { reason in
                                        Button {
                                            selectedReason = reason
                                        } label: {
                                            Text(reason.localized)
                                                .font(WhoppahTheme.Font.body)
                                                .foregroundColor(WhoppahTheme.Color.base1)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding(.all, 0)
                                        .frame(maxWidth: .infinity,
                                               maxHeight: .infinity)
                                    }
                                } label: {
                                    Text(selectedReason.localized)
                                        .frame(maxWidth: .infinity,
                                               maxHeight: .infinity,
                                               alignment: .leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .accentColor(WhoppahTheme.Color.base1)
                            }
                        }
                    }
                    .frame(height: WhoppahTheme.Size.TextInput.height)
                    
                    ///
                    /// 🔤 Description
                    ///
                    
                    TextInputWithValidation(foregroundColor: WhoppahTheme.Color.base5,
                                            placeholderText: model.reportDescriptionPlaceholder,
                                            disableAutoCorrection: false,
                                            disableAutoCapitalization: false,
                                            validateOnChange: true,
                                            validators: [],
                                            isInputValid: $isDescriptionValid,
                                            inputValue: $descriptionValue)
                    
                    ///
                    /// 📨 Send button
                    ///

                    CallToAction(backgroundColor: WhoppahTheme.Color.alert3,
                                 foregroundColor: WhoppahTheme.Color.base4,
                                 title: model.sendButtonTitle,
                                 showBorder: false,
                                 showingProgress: $buttonIsShowingProgress)
                    {
                        buttonIsShowingProgress = viewStore.state.reportAbuseState == .loading
                        viewStore.send(.reportAbuse(product: product,
                                                    type: abuseReportType,
                                                    reason: selectedReason,
                                                    description: descriptionValue))
                    }
                    .disabled(buttonIsShowingProgress)
                }
            }
        }
    }
}
