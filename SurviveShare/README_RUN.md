# SurviveShare 실행 가이드

## ✅ 준비 완료 사항
- ✅ Java 클래스 컴파일 완료 (javax.servlet로 변경)
- ✅ web.xml 수정 완료 (Tomcat 9 호환)
- ✅ 데이터베이스 스키마 준비 완료

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




