//
//  NewVersionAlert.swift
//  한들
//
//  Created by Jaemoo Jung on 2023/03/17.
//

import SwiftUI

func NewVersionAlert() -> Alert {
    return Alert(title: Text("업데이트"),
                 message: Text("새 버전이 업데이트 되었습니다."),
                 primaryButton: .default(Text("업데이트"),
                                         action: { openAppStore() }),
                 secondaryButton: .destructive(Text("나중에"))
    )
}
