# SurviveShare JSP Project

SurviveShare는 자취생 생존 도구와 생활 꿀팁을 공유·대여할 수 있는 JSP 기반 커뮤니티입니다. JSP 기본 평가 요소(디렉티브, 스크립틀릿, 액션, 폼, 내장 객체)와 고급 요소(파일 업로드, 다국어, 세션, 쿠키, DB 연동)를 모두 포함합니다.

## 주요 기능
- 회원가입/로그인, 세션 유지, 마이페이지
- 자취 꿀팁 게시판 CRUD
- 물품 등록/사진 업로드/대여 요청
- 대여 요청 승인·거절 및 히스토리 관리
- 생활 난이도 게이지(활동 기반 점수)
- 최근 본 물품 쿠키 지원

## 실행 방법 개요
1. `database/schema.sql`로 DB 생성 후 `WEB-INF/classes/com/surviveshare/config/DBConnection.java`의 접속 정보 수정
2. Apache Tomcat 등에 `SurviveShare` 디렉터리를 배포
3. `WEB-INF/lib`에 JSTL, commons-fileupload, commons-io 라이브러리 배치

자세한 설명은 각 소스 파일 내 주석을 참고하세요.
