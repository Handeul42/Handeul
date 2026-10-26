//
//  constant+UIscreenSize.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/15.
//

import SwiftUI

/// 화면 크기에 따라 달라지는 레이아웃 값.
/// 실행 시점의 UIScreen 대신 현재 뷰 크기로 계산해서, iPhone Duo처럼 화면이 바뀌는 기기에서도 다시 계산된다.
struct LayoutMetrics {
    /// 게임 화면이 차지하는 폭. 높이가 부족한 화면(iPhone Duo 등)에서는 화면 폭보다 좁아지고 가운데 정렬된다.
    let contentWidth: CGFloat
    /// 안전 영역을 포함한 전체 화면 크기
    let screenSize: CGSize

    init(contentWidth: CGFloat, screenSize: CGSize) {
        self.contentWidth = contentWidth
        self.screenSize = screenSize
    }

    init(size: CGSize, safeAreaInsets: EdgeInsets) {
        let screenSize = CGSize(width: size.width + safeAreaInsets.leading + safeAreaInsets.trailing,
                                height: size.height + safeAreaInsets.top + safeAreaInsets.bottom)
        var availableHeight = size.height
        let fullWidthMetrics = LayoutMetrics(contentWidth: size.width, screenSize: screenSize)
        if fullWidthMetrics.showsTitle {
            availableHeight -= fullWidthMetrics.titleHeight
        }
        self.init(contentWidth: min(size.width, Self.maxContentWidth(fittingHeight: availableHeight)),
                  screenSize: screenSize)
    }

    var answerBlockSize: CGFloat { (contentWidth - 40) / 6 }
    var horlineWidth: CGFloat { contentWidth - 40 }
    var keyboardButtonSize: CGSize {
        let width = Double(contentWidth - 88) / 9.44
        return CGSize(width: width, height: width / 8 * 11)
    }
    var keyboardExtraButtonSize: CGSize {
        CGSize(width: keyboardButtonSize.width * 1.44, height: keyboardButtonSize.height)
    }

    var screenRatio: CGFloat { (screenSize.width * screenSize.height) / (390 * 844) }
    var heightRatio: CGFloat { screenSize.height / 844 }

    var showsTitle: Bool {
        round(screenSize.height / screenSize.width * 10) > round(16 / 9 * 10)
    }
    /// TitleView와 위아래 여백 높이
    var titleHeight: CGFloat { 20 * screenRatio + 35 * screenRatio * 1.2 + 8 * heightRatio }

    /// 메인 화면(메뉴바, 정답판, 라이프, 키보드)이 주어진 높이에 들어가는 최대 폭.
    /// 높이 = 메뉴바 48 + 정답판 (6 * 블록 + 39) + 라이프 64 + 키보드 (3 * 키 높이 + 16)
    private static func maxContentWidth(fittingHeight height: CGFloat) -> CGFloat {
        let keyHeightPerWidth = 11.0 / 8 / 9.44
        // height = 48 + (w - 40) + 39 + 64 + 3 * keyHeightPerWidth * (w - 88) + 16
        let fixed = 48 - 40 + 39 + 64 + 16 - 3 * keyHeightPerWidth * 88
        return (height - fixed) / (1 + 3 * keyHeightPerWidth)
    }
}

private struct LayoutMetricsKey: EnvironmentKey {
    static let defaultValue = LayoutMetrics(contentWidth: 390, screenSize: CGSize(width: 390, height: 844))
}

extension EnvironmentValues {
    var layout: LayoutMetrics {
        get { self[LayoutMetricsKey.self] }
        set { self[LayoutMetricsKey.self] = newValue }
    }
}
