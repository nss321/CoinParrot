//
//  CustomLikeButtonViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/11/25.
//

import RealmSwift
import RxSwift
import RxCocoa

final class StarButtonViewModel: ViewModel {
    
    struct Input {
        let buttonConfig: Observable<Void>
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isStarred: Driver<Bool>
        let toastMessage: Driver<String>
    }
    
    let disposeBag = DisposeBag()
    private let item: LikedCoin
    private let realm = try! Realm()
    private var data: Results<LikedCoinRealmSchema>
    
    init(item: LikedCoin) {
        self.item = item
        self.data = realm.objects(LikedCoinRealmSchema.self)
    }
    
    func transform(input: Input) -> Output {
        let itemObservable = Observable.just(item)
        let isLiked = BehaviorRelay(value: false)
        let toastMessage = PublishRelay<String>()
        
        input.buttonConfig
            .bind(with: self) { owner, _ in
                isLiked.accept(owner.loadLikeFromRealm())
            }
            .disposed(by: disposeBag)
        
        input.buttonTap
            .bind(with: self) { owner, _ in
                isLiked.accept(owner.toggleLikeFromRealm())
            }
            .disposed(by: disposeBag)
        
        input.buttonTap
            .withLatestFrom(itemObservable)
            .map {
                $0.id
            }
            .bind(with: self) { owner, text in
                print(text)
                if owner.loadLikeFromRealm() {
                    toastMessage.accept("\(text) 좋아요")
                } else {
                    toastMessage.accept("\(text) 삭제")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isStarred: isLiked.asDriver(),
            toastMessage: toastMessage.asDriver(onErrorJustReturn: "")
        )
    }
    
    private func toggleLikeFromRealm() -> Bool {
        var isLiked = false
        
        guard let targetItem = data.first(where: { $0.id == item.id }) else {

            let targetItem = LikedCoinRealmSchema(value: [
                "id": item.id
            ])
            
            do {
                try realm.write {
                    realm.add(targetItem)
                    isLiked = true
                    print("add success to realm >>>", targetItem)
                }
            } catch {
                print("failed to delete \(targetItem.id) from realm")
            }
            
            return isLiked
        }
        

        do {
            try realm.write {
                realm.delete(targetItem)
                isLiked = false
                print("delete success to realm >>>", targetItem)
            }
        } catch {
            print("failed to delete \(targetItem.id) from realm")
        }
        
        return isLiked
    }
    
    private func loadLikeFromRealm() -> Bool {
        let targetId = item.id
        let storedIds = data.map{ $0.id }
        print(#function, storedIds.contains(targetId))
        return storedIds.contains(targetId)
    }
}
