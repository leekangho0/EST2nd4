<p align="center">
  <img width="8096" alt="appImage" src="https://github.com/user-attachments/assets/816e2115-88e1-4301-a797-307e643e1499" />
</p>





## 🏝️ 제멋대로란?
**제멋대로**는 사용자가 여행 일정을 위치 추적과 지도 기능을 통해 날짜별&장소별로 계획하고, 여행 정보 기록 또한 가능해 마치 **디지털 여행 다이어리**처럼 사용할 수 있는 **iOS 다이어리 앱**입니다.





## 💡 주요 기능
- 🧳 여행 일정 조회, 등록, 수정 및 삭제
- ✈️ 항공편 조회, 등록, 수정 및 삭제
- 🏔️ 장소 추천(위치/카테고리별), 검색, 상세보기 및 여행 정보 기록(도착시간/메모)
- 📍 위치&지도 기반으로 교통수단별 길찾기
- 📱 iPhone(세로), iPad(가로/세로) 지원 및 다크모드 대응





## 📌 요구사항

### 기능 요구사항(Functional Requirements)

| 화면 | 요구사항 |
| :--: | ----- |
| 공통 | - 화면 간 이동에 문제 발생하지 않음<br> - 네비게이션 바 정상 작동 |
| 홈 | - 사용자가 여행 일정을 등록, 조회, 수정 및 삭제<br>- 여행 일정 리스트를 예정된/지나간 여행으로 구분<br>- 커스텀 사용자명 설정 및 저장 |
| 일정 날짜 등록 | - 달력에서 여행 시작일과 종료일 선택 |
| 항공편 등록 | - 항공편 등록, 조회, 수정 및 삭제<br>- 가는 날, 오는 날 항공편 선택 가능<br>- 항공편 정보(출발&도착 시간, 출발&도착 공항, 항공편명) 입력 가능 |
| 여행 일정 | - 장소 등록, 조회(리스트&지도), 수정 및 삭제<br>- 항공편 등록<br>- 장소에 상세 정보(도착시간/메모) 등록, 조회, 수정 및 저장<br>- 해당 장소 길찾기<br>- 여행 일정 내용(제목, 날짜) 수정 및 여행 일정 삭제 |
| 장소 추가 | - 여행 일정에 장소 등록<br>- 위치/카테고리별 장소 추천<br>- 장소 검색(자동완성 기능 지원) |
| 길찾기 | - 현위치/특정 위치에서 길찾기<br>- 자동차/대중교통/도보별 경로, 소요시간, 요금 정보 제공 |
| 지도 | - 등록한 장소를 날짜별로 조회<br>- 장소 상세 정보(장소명/카테고리/별점/주소/도착 시간/메모) 조회<br>- 등록한 장소를 지도에 마커 표시<br>- 지도 확대/축소 가능 |

### 비기능 요구사항(Non-Functional Requirements)

| 항목 | 요구사항 |
| :--: | ----- |
| 디자인 및 UI/UX | - UIKit + Storyboard + AutoLayout 구현<br>- iPhone(세로), iPad(가로/세로) 지원<br>- 다크모드 지원 |
| 성능 안정성 | - Crash, UI/기능 버그 방지<br>- 메모리 누수 방지 및 옵션 처리 시 예외 상황 대응 |
| 데이터 저장 방식 | - 모델 정의 및 영구적인 데이터 저장<br>- CoreData, UserDefaults, 바이너리 파일 사용 |
| 접근성 및 사용자 경험 | - 버튼 색상 등 시각적 피드백 적용 |
| 위치 기반 서비스 | - 위치 정보 권한 및 원활한 API 호출 |





## ⚙️ 기술 스택
- UIKit, Storyboard
- CoreData, UserDefaults, 바이너리 파일
- CoreLocation
- Google API, Odsay API, Tmap API





## 📁 폴더 구조

```swift
EST_Trip
├── App                     
│   ├── Resource
│   │   ├── Assets
│   │   └── Secrets             
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── FeatureFactory.swift

├── Core                  
│   ├── Local              
│   │   └── CoreDataManager.swift
│   └── Network           
│       ├── APIKey.swift
│       └── NetworkError.swift

├── Data                   
│   ├── API                
│   │   ├── Google         
│   │   │   ├── PlaceAPI.swift
│   │   │   └── PlaceAPIProvider.swift
│   │   └── Odsay          
│   │       ├── OdsayAPI.swift
│   │       ├── OdsayProvider.swift
│   │       └── DTO        
│   │           ├── OdsayDTO.swift
│   │           ├── OdsayErrorDTO.swift
│   │           └── OdsayResponse.swift
│   ├── DTOs              
│   │   ├── DTO+Apply.swift
│   │   ├── GooglePlaceDTO.swift
│   │   └── TravelDTO.swift
│   ├── Model
│   │   ├── Models
│   │   ├── PlaceEntity+Util.swift
│   │   ├── ScheduleEntity+Util.swift
│   │   └── TravelEntity+Util.swift
│   └── Service           
│       ├── RemotePlaceService.swift
│       ├── ScheduleProvider.swift
│       └── TravelProvider.swift

├── Feature                
│   ├── Calendar
│   ├── FlightAdd
│   ├── Main
│   ├── Map
│   ├── RouteFinding
│   ├── Schedule
│   ├── ScheduleDetail
│   └── Search

├── Util                   
│   ├── Date+Util.swift
│   ├── GMSMarker+Image.swift
│   ├── GMSMarker+Util.swift
│   ├── Reusable.swift
│   └── UIStoryboard+Util.swift

├── EST_TripTests          
└── Frameworks             
```

## 🖥️ 주요 화면

| 홈 | 일정 날짜 등록 | 항공편 등록 |
| :--: | :--: | :--: |
| <img src= "https://github.com/user-attachments/assets/93a4efff-259d-44fc-8bc4-90c2e039fa7a" width="200"/> | <img src= "https://github.com/user-attachments/assets/c97cbcef-f9ba-48ca-b24d-994a554d03ed" width="200"/> | <img src= "https://github.com/user-attachments/assets/dcceb34b-1be0-42c7-bbe1-4264c361ab19" width="200"/> |



| 여행 일정 | 장소 추가 | 길찾기 | 지도 |
| :--: | :--: | :--: | :--: |
| <img src= "https://github.com/user-attachments/assets/3d6db23d-eb0e-4d48-b2aa-7bc2b587630d" width="200"/> | <img src= "https://github.com/user-attachments/assets/742cc28a-6d54-4b40-962d-633824ca2244" width="200"/> | <img src= "https://github.com/user-attachments/assets/3dfd4c88-089d-4823-ad95-1c02f8230f9b" width="200"/> | <img src= "https://github.com/user-attachments/assets/1d3c168d-43f6-44c3-a7af-2f394d318a64" width="200"/> |





## 🧑🏻‍💻👩🏻‍💻 팀원
| ![Profile](https://github.com/yourusername.png?size=50) | ![Profile](https://github.com/yourusername.png?size=50) | ![Profile](https://github.com/yourusername.png?size=50) | ![Profile](https://github.com/yourusername.png?size=50) | ![Profile](https://github.com/yourusername.png?size=50) | ![Profile](https://github.com/yourusername.png?size=50) |
| :---: | :---: | :---: | :---: | :---: | :---: |
| [고재현](https://github.com/JaeHyun9802) | [권도현](https://github.com/JaeHyun9802) | [박현준](https://github.com/morgan4563) | [이강호](https://github.com/leekangho0) | [정소이](https://github.com/SoyiJeong) | [홍승아](https://github.com/8zipcore) |

