package util;

import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class DBConnection {
    private static SqlSessionFactory factory;

    static {
        System.out.println("[DBConnection] 초기화 시작");
        try {
            factory = new SqlSessionFactoryBuilder()
                .build(Resources.getResourceAsReader("util/config.xml"));
            System.out.println("[DBConnection] config.xml 로딩 성공");
        } catch (Exception e) {
            System.out.println("[DBConnection] 초기화 실패!!");
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // 기존 방식
    public static SqlSessionFactory getFactory() {
        return factory;
    }

    // ✅ 세션 팩토리 리턴 (컨트롤러에서 사용 가능)
    public static SqlSessionFactory getSqlSessionFactory() {
        return factory;
    }

    // ✅ 간단 세션 열기용
    public static SqlSession getSqlSession() {
        return factory.openSession();
    }
}