package controller.admin;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import model.dto.UserDTO;
import util.DBConnection;

@WebServlet("/AdminSuspendUserController")
public class AdminSuspendUserController extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDTO loginUser = (UserDTO) req.getSession().getAttribute("loginUser");
        if (loginUser == null || !"관리자".equals(loginUser.getUserGrade())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=needAdmin");
            return;
        }

        SqlSessionFactory factory = DBConnection.getSqlSessionFactory();
        try (SqlSession session = factory.openSession()) {
            List<UserDTO> suspendedUsers = session.selectList("user.getSuspendedUsers");
            req.setAttribute("suspendedUsers", suspendedUsers);
            
            System.out.println("정지된 회원 수: " + suspendedUsers.size());
            
            req.getRequestDispatcher("/admin/suspended_user_list.jsp").forward(req, resp);
        }
    }
}

