package service;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import model.dto.NotificationDTO;
import util.DBConnection;

public class NotificationService {

    private final DBConnection db = new DBConnection();

    public void addNotification(NotificationDTO noti) {
        SqlSession session = DBConnection.getSqlSession();
        try {
            session.insert("NotificationMapper.addNotification", noti);
            session.commit();
        } finally {
            session.close();
        }
    }

    public int getUnreadCount(String userId) {
        SqlSession session = DBConnection.getSqlSession();
        int count = session.selectOne("NotificationMapper.getUnreadCount", userId);
        session.close();
        return count;
    
}

    public List<NotificationDTO> getNotificationsByUser(String userId) {
        SqlSession session = DBConnection.getSqlSession();
        try {
            return session.selectList("NotificationMapper.getNotificationsByUser", userId);
        } finally {
            session.close();
        }
    }

    public void markAllAsRead(String userId) {
        SqlSession session = DBConnection.getSqlSession();
        try {
            session.update("NotificationMapper.markAllAsRead", userId);
            session.commit();
        } finally {
            session.close();
        }
    }
    
    public void deleteNotification(int notiId) {
        SqlSession session = DBConnection.getSqlSession();
        try {
            session.delete("NotificationMapper.deleteNotification", notiId);
            session.commit();
        } finally {
            session.close();
        }
    }

    public void markAsReadById(int notiId) {
        SqlSession session = DBConnection.getSqlSession();
        session.update("NotificationMapper.markAsReadById", notiId);
        session.commit();
        session.close();
    }

		
	

}
