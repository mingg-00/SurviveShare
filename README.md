# <div> 🪽 초간단 나눔 플랫폼, 서바이브쉐어 </div>
<div>
  <p>지능웹설계 2025-2 프로젝트</p>
  <br>
  <h3>🎯 주제</h3>
  <p>초간단 나눔 플랫폼</p>
  <br>
  <h3>🎉 서비스 내용</h3>
  <p>
    재난·어려움 상황에서도 쉽게 생필품·레시피·생활 팁을 공유할 수 있는 초간단 나눔 플랫폼입니다.<br>
    모든 페이지에 동일한 헤더와 다국어 드롭다운을 제공해 고령층 및 디지털 취약계층도 간단하게 이용하도록 설계했습니다.<br>
    물품 나눔 요청, 꿀팁/레시피 등록, 생활난이도 챌린지 등 커뮤니티 기반 상호 지원 기능을 구현했습니다.
  </p>
  <br>
</div>

# <div> 😎 만든 사람 소개 </div>
<table style="width:100%; text-align:center; table-layout:fixed; border-collapse:collapse;">
  <thead>
    <tr>
      <th>김민지</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><img width="200" height="230" alt="김민지" src="https://github.com/user-attachments/assets/a1866fc5-17a3-4383-b422-652b3ce53f00" /></td>
    </tr>
    <tr>
      <td>
        서비스 아키텍처<br>
        물품·레시피·팁 공유 기능 개발<br>
        챌린지/랭킹 모듈 및 i18n 구축<br>
      </td>
    </tr>
  </tbody>
</table>

# <div>📚 Tech Stack 📚</div>
<div>
  FrontEnd :
  <img src="https://img.shields.io/badge/html5-E34F26?style=for-the-badge&logo=html5&logoColor=white"> 
  <img src="https://img.shields.io/badge/css-1572B6?style=for-the-badge&logo=css3&logoColor=white"> 
  <img src="https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black">
  <img src="https://img.shields.io/badge/bootstrap-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white">
  <br>
  BackEnd :
  JSP/Servlet
  <br>
  DB :
  <img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white"> 
  <br>
  Infra :
  <img src="https://img.shields.io/badge/apache tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=white">
  <br>
</div>

# <div>📚 🛠 Tools 🛠 📚</div>
<div>
  <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white">
</div>

<br><br>

## 🚧 프로젝트 구조 (대표 폴더)

```plaintext
SurviveShare/
├── index.jsp
├── items/
│   ├── list.jsp
│   ├── upload.jsp
│   ├── detail.jsp
│   ├── manage_owner.jsp
│   └── manage_requests.jsp
├── tips/
│   ├── list.jsp
│   ├── write.jsp
│   └── detail.jsp
├── recipes/
│   ├── list.jsp
│   ├── write.jsp
│   └── detail.jsp
├── challenge/
│   ├── ranking.jsp
│   └── today.jsp
├── includes/
│   ├── header.jspf
│   └── footer.jspf
├── assets/
│   ├── css/style.css
│   └── js/validation.js
├── WEB-INF/
│   ├── web.xml
│   └── classes/com/surviveshare/...
│       ├── servlet (ItemServlet, TipServlet, RecipeServlet ...)
│       ├── dao (ItemDAO, RentalDAO, TipDAO ...)
│       └── model (Item, Rental, Tip ...)
└── database/
    ├── schema.sql
    └── sample_data.sql


---

## 📌 핵심 기능 요약

| 구분 | 주요 내용 |
| ---- | -------- |
| 물품 공유 | 물품 등록/조회/상세/나눔 요청, 만남 시간·장소 관리, 요청자 관리 |
| 꿀팁·레시피 | 꿀팁/레시피 등록, 이미지 업로드, 다국어 제목/본문 출력 |
| 챌린지 | 생활 난이도 챌린지 참여, 랭킹 페이지, 수락/거절 버튼 UI |
| 국제화 | JSTL `<fmt:message>`와 `messages_ko/en/jp.properties` 기반 다국어 |
| 세션/레벨 | 세션별 활동량을 합산해 레벨 게이지/아이콘 표시 |
| 관리자 뷰 | 받은 요청/내 요청 페이지에서 상태 변경(수락/거절) 및 안내 메시지 |

---

# SurviveShare 실행 가이드

## ✅ 준비 완료 사항
-  Java 클래스 컴파일 완료 (javax.servlet로 변경)
-  web.xml 수정 완료 (Tomcat 9 호환)
-  데이터베이스 스키마 준비 완료

## 🚀 실행 방법

### 방법 1: 스크립트 실행 (권장)
```bash
cd /Users/gimminji/Desktop/지웹플젝/SurviveShare
./start-tomcat.sh
```

### 방법 2: 수동 실행
```bash
# 1. 프로젝트를 Tomcat에 배포
cp -r /Users/gimminji/Desktop/지웹플젝/SurviveShare \
  /Users/gimminji/Downloads/apache-tomcat-9.0.109/webapps/

# 2. Tomcat 시작
cd /Users/gimminji/Downloads/apache-tomcat-9.0.109/bin
./catalina.sh run
```

### 방법 3: Eclipse에서 실행
1. Eclipse에서 Servers 탭 열기
2. Tomcat 서버 우클릭 → **Clean...**
3. **Add and Remove...** → SurviveShare 추가 확인
4. 서버 **Start**

## 🌐 접속 URL
서버 시작 후 브라우저에서:
```
http://localhost:8085/SurviveShare/
```

## 📋 주요 기능 테스트
1. **회원가입**: `/register.jsp`
2. **로그인**: `/login.jsp`
3. **물품 목록**: `/items/list.jsp`
4. **꿀팁 목록**: `/tips/list.jsp`
5. **마이페이지**: `/user/mypage.jsp` (로그인 필요)

## ⚠️ 문제 해결

### 포트 충돌
포트 8085가 사용 중이면:
```bash
lsof -ti:8085 | xargs kill -9
```

### 데이터베이스 연결 오류
`DBConnection.java`에서 MySQL 계정 정보 확인:
- URL: `jdbc:mysql://localhost:3306/surviveshare`
- USER: `root`
- PASSWORD: `Kmj040611`

### 클래스 파일 누락
다시 컴파일:
```bash
cd /Users/gimminji/Desktop/지웹플젝/SurviveShare/WEB-INF/classes
javac -cp "../../lib/*:/Users/gimminji/Downloads/apache-tomcat-9.0.109/lib/servlet-api.jar" \
  com/surviveshare/**/*.java
```
