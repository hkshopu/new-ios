//
//  LanguagePack.swift
//  HKShopU_ShopFlow
//
//  Created by 林亮宇 on 2021/4/9.
//

import Foundation

struct LanguagePack{
    
    let CHT: [String : String] = [
        "Save":"儲存",
        "Continue" : "繼續",
        "ForgetPassword" : "忘記密碼？",
        "Confirm": "確定",
        "Cancel": "取消",
        "FirstAddShop_1" : "新增店舖",
        "FirstAddShop_2" : "決定要接下創業的挑戰並新增店舖嗎？",
        "FirstAddShop_3" : "＋ 新增店鋪",
        "ShopSelectView_1" : "編輯",
        "ShopSelectView_2" : "我的商品：",
        "ShopSelectView_3" : "關注：",
        "ShopSelectView_4" : "進帳：",
        "ShopSelectView_5" : "＋ 新增店鋪",
        "AddShopFlowControlView_1":"新增店舖",
        "AddShopFlowControlView_2":"請選擇店鋪照片",
        "AddShopFlowControlView_3":"點選下方店鋪頭貼並至手機相簿選擇喜歡的logo或照片。",
        "AddShopFlowControlView_4":"請編輯店鋪名稱",
        "AddShopFlowControlView_5":"點選下方的文字框並填寫喜歡的店鋪名稱。",
        "AddShopFlowControlView_6":"請選擇店鋪分類",
        "AddShopFlowControlView_7":"進入店鋪分類，選擇適合的類別設置分類。",
        "AddShopFlowControlView_8":"店舖分類",
        "AddShopFlowControlView_9":"更多",
        "AddShopFlowControlView_10":"確認新增店鋪",
        "AddShopFlowControlView_11":"＋ 新增店鋪",
        "ShopNameEditView_1" : "編輯店鋪名稱",
        "ShopNameEditView_2" : "30天內只能更改一次店鋪名稱",
        "ShopNameEditViewPopup_1" : "確定要編輯店鋪名稱嗎?",
        "ShopNameEditViewPopup_2" : "30天內只有一次更改店鋪名稱的權限。",
        "ShopDescriptionEditView_1" : "新增店鋪簡介...",
        "ShopDescriptionEditView_2" : "聯絡資訊",
        "ShopDetailPhoneView_1" : "電話號碼",
        "ShopDetailPhoneView_2" : "請輸入手機電話號碼",
        "ShopDetailPhoneView_3" : "顯示在店鋪簡介",
        "ShopDetailMailCheckView_1" : "Email",
        "ShopDetailMailCheckView_2" : "為了保護你的帳戶安全。請再次輸入密碼已進行下一步",
        "ShopDetailMailCheckView_3" : "現在的密碼",
        "ShopDetailMailEditView_1" : "新增Email",
        "ShopDetailMailEditView_2" : "輸入電子郵件",
        "ShopDetailMailEditView_3" : "顯示在店鋪簡介",
        "ShopDetailSocialSettingView_1" : "社群帳號設定",
        "ShopDetailSocialSettingView_2" : "連結 Facebook 帳號",
        "ShopDetailSocialSettingView_3" : "連結 Instagram 帳號",
        "PublicShopView_1" : "了解更多",
        "PublicShopSelectElement_1" : "綜合排名",
        "PublicShopSelectElement_2" : "最新",
        "PublicShopSelectElement_3" : "最熱銷",
        "PublicShopSelectElement_4" : "最低價",
        "PublicShopSelectElement_5" : "最高價",
        "AddBankAccount_1" : "新增銀行帳號",
        "AddBankAccount_2" : "請輸入銀行代碼",
        "AddBankAccount_3" : "請輸入銀行名稱",
        "AddBankAccount_4" : "請輸入銀行戶名",
        "AddBankAccount_5" : "請輸入銀行帳號",
        "AddBankAccount_6" : "為確保您的權利，請反覆確認銀行資訊是否正確，若交易流程出現問題，店匯在此已敬提醒之責。",
        "AddBankAccountBottom_1" : "新增銀行帳號",
        "AddBankAccountBottom_2" : "請輸入銀行帳戶資訊，並再三檢查。若交易流程出現問題，店匯在此已盡提醒之責。",
        "AddShopAddress_1" : "新增店舖地址",
        "AddShopAddress_2" : "姓名 / 公司名稱",
        "AddShopAddress_3" : "輸入姓名或公司名稱",
        "AddShopAddress_4" : "電話號碼",
        "AddShopAddress_5" : "請輸入電話號碼",
        "AddShopAddress_6" : "請輸入您的郵寄地址",
        "AddShopAddress_7" : "地域",
        "AddShopAddress_8" : "地區",
        "AddShopAddress_9" : "街道名稱",
        "AddShopAddress_10" : "街道門牌",
        "AddShopAddress_11" : "其他地址",
        "AddShopAddress_12" : "樓層",
        "AddShopAddress_13" : "室",
        "AddShopAddress_14" : "國碼",
        "AddBankAccountBottom_3" : "前往新增店鋪地址",
        "AddBankAddressBottom_1" : "新增店鋪地址",
        "AddBankAddressBottom_2" : "請輸入店鋪資料與郵寄地址，以確保交易流程順利。",
        "AddBankAddressBottom_3" : "完成開店囉！",
        
    ]
}


class SystemLanguage: ObservableObject{
    @Published var content: [String: String]
    init(){
        content = LanguagePack().CHT
    }
}
