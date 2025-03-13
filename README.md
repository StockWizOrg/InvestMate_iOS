<table>
    <tr>
        <td>
            <img src="https://github.com/user-attachments/assets/97aa582b-cdbe-4aa4-a2f7-f598831c5d36" width="150"/>
        </td>
        <td style="padding-left: 20px;">
            <h1>InvestMate - 주식, 코인 계산기</h1>
        </td>
    </tr>
</table>

<table align="center">
    <tr>
        <td><img src="https://github.com/user-attachments/assets/7441ac61-5269-4e0e-814c-993ccd2c1650" width="180"/></td>
        <td><img src="https://github.com/user-attachments/assets/13a79264-8d36-43f4-955f-4c04d5b9fe0e" width="180"/></td>
        <td><img src="https://github.com/user-attachments/assets/b4814914-6ea5-433a-afe8-c02b9cbbf2d7" width="180"/></td>
        <td><img src="https://github.com/user-attachments/assets/c44feb54-debf-4a18-88b9-b43c7b0d8496" width="180"/></td>
        <td><img src="https://github.com/user-attachments/assets/1ff492b5-9d30-4baf-85bc-b89e7b2d9098" width="180"/></td>
    </tr>
</table>

--- 

<a href="https://apps.apple.com/kr/app/investmate-%EC%A3%BC%EC%8B%9D-%EC%BD%94%EC%9D%B8-%EA%B3%84%EC%82%B0%EA%B8%B0/id6741756312" target="_blank">
    <img src="https://github.com/user-attachments/assets/b68238d2-d0ef-4dac-bdb1-2110ae8b6f7e" alt="Download on the App Store" width="200"/>
</a>

<br>
<br>
<br>

# 요구사항
- `iOS 17.5+`
- `Xcode 16.0+`
- `Tuist 4.21.2+`

<br>
<br>

# 설치 및 실행

해당 프로젝트는 Tuist를 이용하여 빌드 및 관리를 합니다. 


### 1.프로젝트 클론
```
$ git clone https://github.com/StockWizOrg/InvestMate.git
$ cd InvestMate
```

### 2. Tuist 설치
Tuist가 설치되어 있지 않다면 다음 명령어로 설치하세요.

```
$ brew tap tuist/tuist
$ tuist version
```

### 3. 프로젝트 설정
```
$ cd InvestMate
$ tuist install
$ tuist generate
$ open InvestMateWorkspace.xcworkspace
```

<br>
<br>

# 주요 기능
- 보유 주식 관리 (추가, 수정, 삭제)
- 투자 수익 계산기 (총 수익 및 수익률)
- 추가 매수 시 평균 단가 계산
- 소수점 자릿수 설정 가능

<br>
<br>
  

# 기술 스택

| 기술 | 설명 |
|------|----------|
| ![SwiftData](https://img.shields.io/badge/SwiftData-orange) | 로컬 데이터베이스 |
| ![Tuist](https://img.shields.io/badge/Tuist-4.43.2-purple) | 프로젝트 관리 |
| ![RxSwift](https://img.shields.io/badge/RxSwift-6.8.x-blue) | 반응형 프로그래밍 |
| ![ReactorKit](https://img.shields.io/badge/ReactorKit-3.0.x-yellow) | 단방향 데이터 흐름 아키텍처 |

<br>
<br>

# 구조
MVVM + Clean Architecture 기반으로 구성되었습니다.<br>
MVVM 처럼 개발자, 회사마다 모두 달라 규격화된 것이 없어,<br>
ReactorKit을 도입해 일관성 있는 구조를 유지하도록 설계했습니다.<br>

<br>

<img width="752" alt="스크린샷 2025-03-13 오후 10 37 18" src="https://github.com/user-attachments/assets/43e25de2-8fda-409a-962d-19390295ec57" />

<br>
<br>

# Foldering Strategy

```
📂 InvestMate
├── 📦 InvestMate          
│   ├── Resources         
│   └── Sources
│       ├── AppDelegate.swift
│       └── SceneDelegate.swift
│
├── 📦 Presentation       
│   ├── Literals          
│   ├── Utils             
│   │   ├── Components   
│   │   ├── Extensions   
│   │   └── Protocols    
│   ├── Views             
│   │   ├── AdditionalPurchase    
│   │   ├── MoreMenu             
│   │   ├── Profit                
│   │   └── StockManagement       
│   └── Resources         
│
├── 📦 Domain             
│   ├── Entities         
│   ├── Repositories     
│   ├── UseCases         
│   │   ├── Mock         
│   │   ├── Protocols    
│   │   └── Impl         
│   └── Tests           
│
├── 📦 Data               
│   ├── 📄 Models           
│   └── 📂 Repositories     
```

