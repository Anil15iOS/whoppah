//
//  ReportAbuseActionSheet.swift
//  WhoppahUI
//
//  Created by Marko Stojkovic on 28.3.22..
//

import SwiftUI
import Combine
import ComposableArchitecture
import WhoppahModel

struct ReportAbuseActionSheet: View {
    @Binding private var showAbuseReportSheet: Bool
    @Binding private var abuseReportType: WhoppahModel.AbuseReportType

    private let viewStore: ViewStore<ProductDetailView.ViewState, ProductDetailView.Action>
        
    let cancelButtonAction: () -> Void
    
    public init(viewStore: ViewStore<ProductDetailView.ViewState, ProductDetailView.Action>,
                showAbuseReportSheet: Binding<Bool>,
                abuseReportType: Binding<WhoppahModel.AbuseReportType>,
                cancelButtonAction: @escaping () -> Void)
    {
        self.viewStore = viewStore
        self._showAbuseReportSheet = showAbuseReportSheet
        self._abuseReportType = abuseReportType
        self.cancelButtonAction = cancelButtonAction
    }
    
    var body: some View {
        VStack(alignment: .center,
               spacing: WhoppahTheme.Size.Padding.small) {
            Button {
                if viewStore.state.user() == nil {
                    viewStore.send(
                        .outboundAction(
                            .showLoginModal(title: viewStore.state.model.userNotSignedInTitle,
                                            description: viewStore.state.model.userNotSignedInDescription)))
                    return
                }

                withAnimation {
                    abuseReportType = .user
                    showAbuseReportSheet = true
                }
            } label: {
                Text(viewStore.model.heroImageComponent.reportUserButtonTitle)
                    .foregroundColor(WhoppahTheme.Color.alert1)
                    .font(.system(size: WhoppahTheme.Size.Padding.regularMedium,
                                  weight: .semibold))
                    .frame(height: WhoppahTheme.Size.ActionSheetButton.height)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(WhoppahTheme.Size.Radius.large)
            .padding(.horizontal, WhoppahTheme.Size.Padding.smaller)
            
            Button {
                if viewStore.state.user() == nil {
                    viewStore.send(
                        .outboundAction(
                            .showLoginModal(title: viewStore.state.model.userNotSignedInTitle,
                                            description: viewStore.state.model.userNotSignedInDescription)))
                    return
                }

                withAnimation {
                    abuseReportType = .product
                    showAbuseReportSheet = true
                }
            } label: {
                Text(viewStore.model.heroImageComponent.reportAdButtonTitle)
                    .foregroundColor(WhoppahTheme.Color.alert1)
                    .font(.system(size: WhoppahTheme.Size.Padding.regularMedium,
                                  weight: .semibold))
                    .frame(height: WhoppahTheme.Size.ActionSheetButton.height)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(WhoppahTheme.Size.Radius.large)
            .padding(.horizontal, WhoppahTheme.Size.Padding.smaller)
            
            Button {
                self.cancelButtonAction()
            } label: {
                Text(viewStore.model.heroImageComponent.cancelButtonTitle)
                    .foregroundColor(WhoppahTheme.Color.alert3)
                    .font(.system(size: WhoppahTheme.Size.Padding.regularMedium,
                                  weight: .semibold))
                    .frame(height: WhoppahTheme.Size.ActionSheetButton.height)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(WhoppahTheme.Size.Radius.large)
            .padding([.bottom, .leading, .trailing], WhoppahTheme.Size.Padding.smaller)
        }
    }
}
