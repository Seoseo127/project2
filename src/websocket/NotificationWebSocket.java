// 1. NotificationWebSocket.java - WebSocket 엔드포인트
package websocket;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.*;

@ServerEndpoint("/notificationSocket")
public class NotificationWebSocket {
    private static Map<String, Session> userSessions = new HashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        // 클라이언트에서 연결 시 아무것도 안 함
    }

    @OnMessage
    public void onMessage(String userId, Session session) {
        userSessions.put(userId, session);
        System.out.println("✅ 웹소켓 연결됨: " + userId);
    }

    

    @OnClose
    public void onClose(Session session) {
        userSessions.values().remove(session);
    }

    public static void sendNotification(String userId, String message) {
        Session session = userSessions.get(userId);
        if (session != null && session.isOpen()) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}