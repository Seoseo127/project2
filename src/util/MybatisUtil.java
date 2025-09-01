package util;

import java.io.InputStream;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MybatisUtil {
    private static SqlSessionFactory sqlSessionFactory;

    static {
        try {
        	System.out.println("📢 MyBatis 초기화 시작");
            String resource = "util/config.xml"; // MyBatis 설정 파일
            InputStream inputStream = Resources.getResourceAsStream(resource);
            System.out.println("✅ config.xml 로딩 완료");
            
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (Exception e) {
        	System.out.println("❌ MyBatis 초기화 실패");
            e.printStackTrace();
        }
    }
    
    public static org.apache.ibatis.session.SqlSession getSqlSession() {
        return sqlSessionFactory.openSession();
    }

    public static SqlSessionFactory getSqlSessionFactory() {
        return sqlSessionFactory;
    }
}
