//
//  PostDetailDialogsOverlay.swift
//  Pickple
//
//  Created by 박윤수 on 9/11/26.
//
//  PostDetailView 본문에 그대로 박혀있던 로그인 유도/게시글 액션 확인/댓글 픽 확인
//  다이얼로그 3개를 모은 오버레이. 각 다이얼로그는 서로 다른 상태 타입(String?/
//  PostDetailConfirmAction?/Comment?)에 반응해서 뜨고, 셋 다 동시에 뜨는 일은 없다.
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct PostDetailDialogsOverlay: View {
    @Binding var loginRequiredDescription: String?
    @Binding var postActionConfirm: PostDetailConfirmAction?
    @Binding var commentToPick: Comment?
    @Binding var showsDeleteFailureToast: Bool
    let postDetailViewModel: PostDetailViewModel
    let appRequestLogin: () -> Void
    let onDeleted: () -> Void

    var body: some View {
        Group {
            if let loginRequiredDescription {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: PostDetailStrings.voteRequiredTitle,
                        description: loginRequiredDescription,
                        cancelTitle: PostDetailStrings.cancel,
                        confirmTitle: PostDetailStrings.login,
                        onCancel: { self.loginRequiredDescription = nil },
                        onConfirm: {
                            self.loginRequiredDescription = nil
                            appRequestLogin()
                        }
                    )
                }
            }

            if let postActionConfirm {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: postActionConfirm.title,
                        description: postActionConfirm.description,
                        cancelTitle: PostDetailStrings.cancel,
                        confirmTitle: postActionConfirm.confirmTitle,
                        onCancel: { self.postActionConfirm = nil },
                        onConfirm: {
                            switch postActionConfirm {
                            case .delete:
                                Task {
                                    if await postDetailViewModel.deletePost() {
                                        onDeleted()
                                    } else {
                                        showsDeleteFailureToast = true
                                    }
                                }
                            case .report:
                                break //TODO: 실제 신고 API 연동 필요
                            case .block:
                                break //TODO: 기능명세서상 차단은 확인 모달만 있고 실제 동작은 정의되어 있지 않음
                            }
                            self.postActionConfirm = nil
                        }
                    )
                }
            }

            if let comment = commentToPick {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: PostDetailStrings.pickConfirmTitle,
                        description: PostDetailStrings.pickConfirmDescription,
                        cancelTitle: PostDetailStrings.cancel,
                        confirmTitle: PostDetailStrings.pickConfirmButton,
                        onCancel: { commentToPick = nil },
                        onConfirm: {
                            Task { await postDetailViewModel.pickComment(comment.id) }
                            commentToPick = nil
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var loginRequiredDescription: String? = PostDetailStrings.voteRequiredDescription
    @Previewable @State var postActionConfirm: PostDetailConfirmAction?
    @Previewable @State var commentToPick: Comment?
    @Previewable @State var showsDeleteFailureToast = false

    PostDetailDialogsOverlay(
        loginRequiredDescription: $loginRequiredDescription,
        postActionConfirm: $postActionConfirm,
        commentToPick: $commentToPick,
        showsDeleteFailureToast: $showsDeleteFailureToast,
        postDetailViewModel: PostDetailViewModel(voteType: .text),
        appRequestLogin: {},
        onDeleted: {}
    )
}
