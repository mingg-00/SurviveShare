package com.surviveshare.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LocaleServlet", urlPatterns = "/LocaleServlet")
public class LocaleServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String lang = request.getParameter("lang");
        if (lang == null || lang.isEmpty()) {
            lang = "ko";
        }
        HttpSession session = request.getSession();
        session.setAttribute("lang", lang);
        session.setAttribute("sessionScope.lang", lang);
        
        // Referer에서 경로 추출
        String referer = request.getHeader("Referer");
        String contextPath = request.getContextPath();
        String redirectPath = contextPath + "/index.jsp";
        
        if (referer != null && !referer.isEmpty()) {
            try {
                java.net.URL url = new java.net.URL(referer);
                String path = url.getPath();
                String query = url.getQuery();
                
                // 컨텍스트 경로 제거
                if (path.startsWith(contextPath)) {
                    path = path.substring(contextPath.length());
                }
                
                // 경로 정규화
                if (path.isEmpty() || path.equals("/")) {
                    redirectPath = contextPath + "/index.jsp";
                } else {
                    if (!path.startsWith("/")) {
                        path = "/" + path;
                    }
                    redirectPath = contextPath + path;
                    if (query != null && !query.isEmpty()) {
                        redirectPath += "?" + query;
                    }
                }
            } catch (Exception e) {
                // 에러 발생 시 기본값 사용
                redirectPath = contextPath + "/index.jsp";
            }
        }
        
        response.sendRedirect(redirectPath);
    }
}
