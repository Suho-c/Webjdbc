<%@page import="com.example.MemberDTO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
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
   // 0.인코딩
   request.setCharacterEncoding("UTF-8");

   // 1. 아이디와 비밀번호 가져오기
   String id = request.getParameter("id");
   String pw = request.getParameter("pw");
   
   Connection conn = null;   
   PreparedStatement psmt = null;
   ResultSet rs = null;
   
   
   
   try{
   // JDBC
   // 1. oracle DB와 연결해줄 수 있는 lib import(WEB_INF > lib)
   // 2. oracle lib 파일에서 DB와 연결할 수 있는 class 실행
   // 예외처리 : 자바에서 2종류 오류
   //          1) 컴파일 오류 - 문법적인 오류
   //          2) 런타임 오류 - 실행을 해야지만 알 수 있는 오류
   //                     -> 예외처리문 사용(try~catch)
   
   Class.forName("oracle.jdbc.driver.OracleDriver");
      
      // 3. DB 경로, id/pw 인증
      //                              프로젝트때 받을 주소
      String url = "jdbc:oracle:thin:@127.0.0.1:1521";
      String dbid = "hr";
      String dbpw = "hr";
               
         
      conn = DriverManager.getConnection(url, dbid, dbpw);
      if(conn != null){
         System.out.print("연결성공");
      }else{
         System.out.print("연결실패");
      }   
      
      // 4. SQL 명령문 준비
      // ? : 바인드변수 -> 사용자가 값을 sql로 전달할 수 있는 통로 역할 
      String sql = "select * from member_web where id = ? and pw = ?";
      psmt = conn.prepareStatement(sql);
      psmt.setString(1, id);
      psmt.setString(2, pw);
      
      // 5. SQL 명령문 실행
      // executeQuery() -> select문 - 테이블 변환지 않는 경우
      // executeUpdate() -> insert, update, delete문 - 테이블 구조 변화있는 경우
      rs = psmt.executeQuery();
      
      
      if(rs.next() == true){
         
         String uid = rs.getString("id"); // rs.getString 열 정보 가져오기
         String upw = rs.getString("pw");
         
         MemberDTO dto = new MemberDTO(uid,upw);
         // dto객체를 세션에 저장
         session.setAttribute("dto", dto);
         
         // id를 세션에 저장 
         session.setAttribute("id", id);   
         // 세션에 정보를 담고 나면 페이지 이동(Main.jsp) 
         response.sendRedirect("Main.jsp");
         
         
      }else {
         out.print("로그인 실패했습니다.");
         out.print("<a href = 'login.html'>로그인 다시하기</a>");
      }
      
      
      
   }catch(Exception e){
      e.printStackTrace();
   }finally{
      // finally문은 무조건 실행 된다!
      // 6. 연결 종료
      try{
      if(rs != null) rs.close();
      if(psmt != null) psmt.close();
      if(conn != null) conn.close();
   }catch(Exception e){
      e.printStackTrace();
      
   }
   }
   
   
   
   
   
   
   
   
   

%>




</body>
</html>