### 🏬 오픈 마켓
프로젝트 기간: 2022.01.03 ~ 2022.01.28

    
## 🗂 목차

- [📱 구현 화면] (#-구현-화면)
- [📃 구현내용](#-구현-내용)
- [🚀 Trouble Shooting](#-Trouble-Shooting)
- [🤔 고민한 점](#-고민한-점)
- [⌨️ 키워드](#-키워드)

## 📱 구현 화면
| 상품 화면( 리스트) | 상품 화면 (그리드) | 상품 상세 화면 |
| :---: | :---: | :---: |
|![image](https://user-images.githubusercontent.com/90945013/162007196-fdb33d8c-93ae-49a0-b13c-89dd4310a9ad.png)| ![image](https://user-images.githubusercontent.com/90945013/162007463-4e4683f8-55b9-4efd-a48d-eb3e55715df4.png)  |  ![image](https://user-images.githubusercontent.com/90945013/162007379-296a523f-a95e-4aa4-9726-1117e383df9a.png) |
| 상품 추가 화면 | 상품 추가 화면 | 이미지 상세 화면 | 
| ![image](https://user-images.githubusercontent.com/90945013/162007799-2dacaaaa-88a9-46b1-831b-bb28b175070e.png) | ![image](https://user-images.githubusercontent.com/90945013/162007743-ecf202b5-19da-49c9-8d0a-65cfbc6bdabc.png) | ![image](https://user-images.githubusercontent.com/90945013/162008172-b94dcd35-3752-402f-b609-387a75d279e1.png) |

## 📃 구현내용

### View
- 처음 목록을 로드할 때, 사용자에게 로드중임을 알 수 있도록 Indicator 사용
- Segmented Control을 활용하여 List 형태와 Grid형태 두 가지를 선택할 수 있도록 구현
- CollectionView를 사용하여 List 형태와 Grid형태 두 가지로 상품 리스트를 보여줄 수 있도록 구현
- 상품 상세 보기 화면에서 이미지 클릭시 이미지를 자세히 볼 수 있도록 구현
- 하나의 뷰로 상품 등록 화면과 상세보기 화면을 사용할 수 있도록 구현
- UIPageControl을 사용하여 여러개의 이미지를 보여줄 수 있도록 구현
- NSAttributedString을 통해 사용자에게 보여주는 폰트를 변경할 수 있도록 구현
- ActionSheet을 사용하여 (카메라, 사진), (수정, 삭제) 등 선택을 받을 수 있도록 한다.

### 비동기 통신
- URLSession을 통해 비동기 통신을 하여 서버에서 데이터를 주고 받을 수 있도록 구현
- CodingKeys 프로토콜을 사용하여 API 명세서에 맞도록 타입을 구현
- API 서버와 JSON을 통하여 통신 할 수 있도록 적절히 JSONDecoder, JSONEncoder 사용
- URLProtocol을 사용해 서버와 실제로 통신하지 않고 Unit Test를 할 수 있도록 테스트 코드 구현

### 기능구현
- 리스트를 위에서 아래로 당길 시 RefreshControl를 사용하여 새로고침 하도록 구현
- Pinch 제스처를 통해 이미지를 확대할 수 있도록 구현
- UIImagePickerController을 사용하여 사용자의 사진, 카메라에 접근하여 사진을 가져올 수 있도록 함
- 상품의 상세정보 입력 시 1000자의 제한을 두었으며, TextViewDelegate를 통해 몇글자를 입력했는지 알 수 있도록 구현

### 기타 구현
- 한번에 필요한 데이터만 가져올 수 있도록 Pagination을 구현
- 이미지 캐싱을 통해 이미지 로드의 성능을 높힘
- 서버에 업로드를 할 때 이미지를 resizing 하여 크기를 300KB 이하로 제한하도록 구현

## 🚀 Trouble Shooting

### 1. 스크롤을 내릴 때 마다 상품목록을 계속 가져오지 않는다.
#### 문제점
상품 목록 화면에서 처음에 상품들이 보이고 스크롤을 내려도 정해진 20개의 상품만이 보이고 더 이상 보이지 않았다.

#### 원인
스크롤을 내릴 때마다 서버에 등록된 상품을 더 가져오도록 하지 않았다.

#### 해결방안
서버 API에 상품 정보를 몇개씩 가져올 수 있도록 하는 옵션이 있어 한 번에 20개씩 가져올 수 있도록 수정하였다.
그리고 CollectionViewDelegate의 willDisplay메서드를 사용하여 스크롤을 내릴 때마다 서버에 등록된 상품을 한 페이지(20개)씩 append 하도록 코드를 수정하였다.

```swift
func collectionView(
  _ collectionView: UICollectionView,
  willDisplay cell: UICollectionViewCell,
  forItemAt indexPath: IndexPath
) {
  if products.count - 1 == indexPath.item, productsPage?.hasNext == true {
    currentPage += 1
    fetchProducts(pageNumber: currentPage, cellType: currentCellType())
  }
}
```
### 2. LIST와 GRID로 서로 전환할 때 약간의 딜레이가 발생

#### 문제점
LIST와 GRID로 전환할 수 있도록 Segment Control을 사용하였다.
그런데 전환할 때마다 약간의 딜레이가 발생하는 문제를 발견했다.

#### 원인
이미지를 URL을 통해 가져오는 Data(contentsOf:) 메서드를 사용하여 가져오고 있어서 이미지를 비동기로 가져오지 않고 동기로 가져오고 있지 않아 이미지를 다 불러온 후에 뷰를 띄워주도록 되어 있었다.

![](https://user-images.githubusercontent.com/69730931/149663537-dbefb6a5-8cb8-4a25-9e8d-213b2e385bd5.png)

#### 해결방안
아래의 메서드를 사용하여 이미지를 비동기로 가져오도록 메서드를 추가 했다.

```swift 
func requestProductImage(
  url: String,
  completion: @escaping (Result<Data, NetworkError>) -> Void
) {
  guard let imageUrl = URL(string: url) else {
    return
  }
  let request = URLRequest(url: imageUrl)
  let dataTask = urlSession.dataTask(request) { response in
    switch response {
    case .success(let data):
      completion(.success(data))
    case .failure(let error):
      completion(.failure(error))
    }
  }
  dataTask.resume()
}
```


### 3. 이미지가 빠르게 보여지지 않는 문제

#### 문제점
이미지를 비동기로 가져오도록 수정했음에도 상품 목록 화면에서 스크롤을 빠르게 내리면 이미지를 원하는 만큼 빠르게 가져오지 못하는 현상

#### 원인
이미지의 용량이 커 네트워크를 통해 가져오는데에 시간이 오래 걸렸다.

#### 해결방안
용량이 큰 이미지의 경우 메모리 로컬 캐싱을 통해 로컬 캐시에 이미지를 저장하여 이미지를 가져올 때 캐시에 저장된 이미지를 먼저 가져오도록 하고 캐시에 이미지가 없을 때 서버에서 이미지를 가져오도록 구현한다.

캐시를 싱글톤으로 구현하여 어디서든 접근할 수 있도록 구현하였다.

```swfit
class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
```

UIImageView의 extension으로 메서드를 구현하였다.   
- 캐시에 저장된 이미지를 먼저 가져오도록 하고 캐시에 이미지가 없을 때 서버에서 이미지를 가져오도록 구현


```swift
extension UIImageView {
  func setImage(url: String) {
    let api = APIManager(urlSession: URLSession(configuration: .default), jsonParser: JSONParser())
    
    let cacheKey = NSString(string: url)
    if let cacheImage = ImageCacheManager.shared.object(forKey: cacheKey) {
      self.image = cacheImage
      return
    }
    
    api.requestProductImage(url: url) { [weak self] response in
      switch response {
      case .success(let data):
        guard let image = UIImage(data: data) else {
          return
        }
        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
        DispatchQueue.main.async {
          self?.image = image
        }
      case .failure(let error):
        print(error)
      }
    }
  }
}
```

## 🤔 고민한 점

### 1. JSON 파싱에 대한 객체 생성
이번 프로젝트에서는 JSON관련 Encoding, Decoding이 빈번히 사용된다고 분석했다.    
그래서 중복적인 작업을 피하기 위해 JSONParser 타입을 만들어 JSONParser를 사용할 객체는 JSONParser를 주입 뱓아 사용할 수 있도록 구현했다.

### 2. escaping 클로저의 활용
URLsession.dataTask메서드는 비동기 방식 이기 때문에 escaping 클로저를 사용하여 request를 하고 나서 response가 올 때까지 기다렸다가 response가 오면 해당 escaping클로저를 실행하도록 구현했다.

### 3. URLComponents를 사용
처음에는 URL 타입의 String 타입을 통한 이니셜라이저를 통해서 URL을 만들었다.
그런데 URLComponents가 있다는 것을 알게 되어 URLComponents를 사용하여 URL 포맷을 만들고 URL을 생성하는 타입을 만들었다.

### 4. 비동기 통신에서의 오류처리
비동기 작업에서 일어나는 오류에 대해서 3가지 방법을 고민했다.   
1. nil 반환
2. do-try-catch를 통한 Error Handling
3. Result 타입

1번은 우선 어떠한 에러인지 확인하기가 힘들어 베재했다.
2번의 단점은 throw 형식의 함수는 throws 키워드가 어떤 Error를 던질것인지 특정하지 않는다.  do - catch 문에서는 더 알기가 어렵다.   
하지만 Result 타입을 쓰게 되면 던질 때 어떠한 오류인지 Error형식이 특정되어 보기가 쉽다. 그래서 성공과 실패가 더 명확해져 가독성 측면에서 더 좋다고 생각하여 Result를 통해 에러처리를 하였다.

### 5. CondingKeys (feat. 네이밍)
API의 프로퍼티와 해당 앱의 프로퍼티가 간단하게 camelCase와 snake_case를 오가는것이라면 JSONDecoder, JSONEncoder의 keyDecodingStrategy, keyEncodingStrategy로 해결할 수 있지만 API의 네이밍을 그래도 camelCase로 가져오게 된다면 [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)에서 지향하는 네이밍에 맞지 않아 CodingKeys 프로토콜을 사용하여 네이밍을 바꾸었다.

### 6. 네트워크를 사용하는 기능에 대한 Unit Test
네트워크를 사용하는 기능에 대한 테스트는 네트워크의 상태에 따른 결과(성공, 실패)에 따라 달라질 수 있고 테스트 하는 과정에서 실제 서버에 접근하는 것은 위험하다고 판단이 들었다.
그래서 네트워크를 실제로 통신하지 않고 가짜 통신을 통해서 테스트를 할 수 있도록 URLProtocol 프로토콜을 사용해 Mock URLSession을 만들고 Mock 데이터를 만들어 테스트를 진행했다.

Mock URLSession을 통해 테스트를 하기 위해서 APIManager 타입에서 URLSession을 외부에서 주입 받을 수 있도록 설계 했다. 그렇게 함으로서, 객체지향설계 5대 원칙인 SOLID 중 하나인 Dependency Inversion Principle (의존성 역전 원칙)을 지킬 수 있도록 설계할 수 있었고 테스트 또한 수월하게 진행할 수 있었다.

### 7. DiffableDataSource 사용
기존의 UICollectionViewDataSource보다 편리하고 향샹된 DiffableDataSource를 사용했다.
DiffableDataSource를 사용하면 아래와 같은 이점이 있다.
- iOS13 버전 이상부터 사용 가능
- apply()를 통해 간단하게 처리 가능 (크래시나 복잡성 등이 없음)
- Hash 개념을 사용하여 빠른속도를 보장, 간결성

### 8. NumberFormatter를 Static으로 선언
서버에서 받아온 상품의 가격, 수량 등 숫자 관련 부분에 콤마(,)처리를 진행하기 위해 NumberFormatter를 사용했다.
그런데 NumberFormatter를 사용하는 부분이 상당히 많아서 고민을 했다.
사용할 때마다 인스턴스를 만들때 마다 생성하고 삭제하는 것이 너무 비효율적이라고 생각이 들었다.    
그래서 NumberFormatter를 static으로 생성하여 하나의 인스턴스만 만들어서 사용하도록 구현함으로서 인스턴스를 생성하고 삭제하는 비용을 줄일 수 있었다.

### 9. identifier, NibName, StoryBoard 관리
CollectionView를 사용할 때 idenfier를 사용하고 Xib파일을 사용할 때 NibName을 사용하며 뷰를 이동하기 위해 present할 때 StoryBoard의 이름이 필요했다. 
이것들을 따로따로 String으로 관리 하게 되면 너무 불편하고 실수도 많이 발생할 것 같았다.
그래서 프로토콜의 기본구현을 사용하여 해당 요소들을 관리 하도록 구현했다.

```swift
protocol ReuseIdentifying {
  static var reuseIdentifier: String { get }
  static var nibName: String { get }
  static var stroyBoardName: String { get }
}

extension ReuseIdentifying {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  static var nibName: String {
    return String(describing: self)
  }
  
  static var stroyBoardName: String {
    let ViewControllerName = String(describing: self)
    let storyBoardName = ViewControllerName.replacingOccurrences(of: "ViewController", with: "")
    return storyBoardName
  }
}
```

### 10. Indicator를 어느 ViewController에서도 불러서 사용할 수 있지 않을까?
Indicator는 여러 곳에서 자주 사용하게 된다. 그래서 어떤 ViewController에서도 불러서 사용하도록 하기 위해서 고민을 했다.
Indicator를 관리 하는 클래스를 만들고 메서드를 static으로 선언하였다. Indicator를 보여주는 메서드는 최상위 뷰를 찾아서 Indicator를 띄워주도록 하였다.  Indicator를 삭제하는 메서드는 뷰 중에 Indicator인 것을 모두 찾아 지우도록 구현했다.

```swift
class LoadingIndicator {
  static func showLoading() {
    DispatchQueue.main.async {
      guard let window = UIApplication.shared.windows.last else {
        return
      }
      let loadingIndicatorView: UIActivityIndicatorView
        
      if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
        loadingIndicatorView = existedView
      } else {
        loadingIndicatorView = UIActivityIndicatorView(style: .large)
        loadingIndicatorView.frame = window.frame
        window.addSubview(loadingIndicatorView)
      }
      loadingIndicatorView.startAnimating()
    }
  }
  
  static func hideLoading() {
    DispatchQueue.main.async {
      guard let window = UIApplication.shared.windows.last else {
        return
      }
      window.subviews
            .filter { $0 is UIActivityIndicatorView }
            .forEach { $0.removeFromSuperview() }
    }
  }
}
```

### 11. TextFieldDelegate, TextViewDelegate 사용
- TextView의 Inset을 조정해 키보드가 컨텐츠를 가리지 않도록 구현했다.
- TextView의 글자수 제한을 사용자에게 알리기 위해 TextView아래 글자수/1000 를 실시간으로 보여줄 수 있도록 구현했다.
- NumberFormatter를 통해 가격, 수량 등 숫자를 입력하는 도중에도 콤마(,)로 수를 구분할 수 있도록 하여 사용자의 가독성을 높이기 위해 노력했다.

### 12. 이미지 확대 화면
- 상품 상세 화면에서 이미지를 클릭시 모달로 새로운 이미지를 보여주도록 함
- 이미지를 최대 몇 배까지 확대할 것인지 설정할 수 있도록 구현
- 화면을 아래로 쓸어 내릴 시 화면이 없어지도록 구현

### 13. List뷰셀과 Grid뷰 셀을 하나의 타입으로 추상화
DataSouce를 통해 정보를 보여주는 과정에서 List뷰셀과 Grid뷰셀의 타입이 다르지만  모양만 다를뿐 필요한 정보는 같았다. 그래서 공통된 것들을 프로토콜로 추상화 하여 하나의 타입으로 사용할 수 있도록 하였다.
그래서 하나의 DataSouce 관련한 메서드로 관리할 수 있게 구현했다.


## ⌨️  키워드
- `JSON`
	- `Encodable`, `Decodable`
- `URL Session`
	- `Multipart-form`, `POST`, `GET`, `PATCH`,`DELETE`
- `API`
- `CodingKeys`
- `Unit Test`
	- `URLProtocol`, `XCTestExpectation`
- `Safe Area`
- `UIScrollView`
- `Collection View`
	- `Mordern Collection View`, `CollectionView Delegate`
-` UICollectionViewDiffableDataSource`
- `Local Cache`
	- `NSCache`
- `Auto Layout`
- `Protocol`
- `Keyboard Type`
- `UIAlertController`
	- `ActionSheet`, `Alert`
- `UIImagePickerController`
- `Segmented Control`
- `Xib`
- `UIActivityIndicatorView`
- `NSAttributedString`
- `Image resizing`
- `TextField`
	- `TextFieldDelegate`
- `TextView`
	- `TextViewDelegate`
- `Delegate`
- `NumberFormatter`
- `reuseIdentifier`
- `Gesture`
	- `PanGesture`, `PinchGesture`
- `UIPageControl`
- `pagination`
- `Error Handling`
