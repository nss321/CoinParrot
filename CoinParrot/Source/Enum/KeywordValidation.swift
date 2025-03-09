//
//  KeywordValidation.swift
//  CoinParrot
//
//  Created by BAE on 3/9/25.
//

/// Validate Conditions. If needs extra condtions, add case to this.
enum KeywordValidation: String {
   case empty
//        case short
   case valid
   
   var message: String {
       switch self {
       case .empty:
           return "공백은 입력할 수 없습니다."
//            case .short:
//                return "검색어는 2글자 이상 입력해주세요."
       case .valid:
           return "valid"
       }
   }
    
    static func checkValidation(text: String) -> Self {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        if trimmedText == "" {
            return KeywordValidation.empty
        }
        
        /// if you need length constration, use this.

//        if text.count < 2 {
//            return KeywordValidation.short
//        }
        
        return KeywordValidation.valid
    }
}
