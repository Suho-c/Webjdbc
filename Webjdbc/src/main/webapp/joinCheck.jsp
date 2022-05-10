<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
	// 인코딩	
	request.setCharacterEncoding("UTF-8");
	// 아이디, 비밀번호, 닉네임 값 가져오기(파라미터 수집)

	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String nick = request.getParameter("nick");

	Connection conn = null;
	PreparedStatement psmt = null;

	try {
		// JDBC
		// 1. oracle DB와 연결해줄 수 있는 lib import(WEB-INF > lib)
		// 2. oracle lib파일에서 DB와 연결할 수 있는 class 실행
		// 예외처리 : 자바에서 2종류 오류
		//			1) 컴파일 오류 - 문법적인 오류
		// 			2) 런타임 오류 - 실행을 해야지만 알 수 있는 오류
		//					    -> 예외처리문 사용(try ~ catch)

		Class.forName("oracle.jdbc.driver.OracleDriver");
		// 3. DB 경로, id/pw 인증
		// 							   @127.0.0.1 <- 여기에 프로젝트때 받은 주소 넣기
		String url = "jdbc:oracle:thin:@127.0.0.1:1521";
		String dbid = "hr";
		String dbpw = "hr";

		conn = DriverManager.getConnection(url, dbid, dbpw);
		if (conn != null) {
			System.out.print("연결 성공");
		} else {
			System.out.print("연결 실패");
		}

		// 4. SQL 명령문 준비
		// ? : 바인드변수 -> 사용자의 값을 sql로 전달할 수 있는 통로 역할
		String sql = "insert into member_web values(?,?,?)";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, id);
		psmt.setString(2, pw);
		psmt.setString(3, nick);

		// 5. SQL 명령문 실행
		// executeQuery() -> select문 - 테이블 변하지않는 경우
		// executeUpdate() -> insert, update, delete문 -> 테이블 구조 변화있는 경우
		int cnt = psmt.executeUpdate();

		if (cnt > 0) {
			// sql문 실행이 성공하면 메인으로 이동하기
			out.print(id + " 님 회원가입 성공했습니다.");
			out.print("<a href = 'Main.jsp'>메인으로 가기</a>");
		} else {
			// sql문 실행이 실패하면
			System.out.print("회원가입 실패!!");
			out.print("<a href = 'join.html'>회원가입 돌아가기</a>");
		}

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		// finally 문은 무조건 실행 된다!
		// 6. 연결 종료
		try {
			if (psmt != null)
		psmt.close();
			if (conn != null)
		conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	%>
</body>
</html>
