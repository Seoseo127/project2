package controller.community;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import model.dto.PostDTO;
import model.dto.UserDTO;
import service.PostService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.File;
import java.io.IOException;

@WebServlet("/updatePost.do")
public class UpdatePostController extends HttpServlet {
    private final PostService postService = new PostService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ✅ WebModule에 맞춘 외부 경로 (Z:/upload_*)
        String uploadBasePath = "Z:/";
        String subDir = "";
        String fileType = null;
        String filePath = null;
        int maxSize = 10 * 1024 * 1024;

        // 임시 저장 디렉토리 (Eclipse 내부 .metadata 경로로 쓰일 수 있음)
        String tempPath = request.getServletContext().getRealPath("/") + "tempUpload";
        File tempFolder = new File(tempPath);
        if (!tempFolder.exists()) tempFolder.mkdirs();

        MultipartRequest multi = new MultipartRequest(
                request, tempPath, maxSize, "UTF-8", new DefaultFileRenamePolicy());

        String postIdStr = multi.getParameter("postId");
        String title = multi.getParameter("title");
        String pContent = multi.getParameter("pContent");
        String category = multi.getParameter("category");
        String fileName = multi.getFilesystemName("uploadFile");
        String mimeType = multi.getContentType("uploadFile");

        System.out.println("📎 전달받은 파일명: " + fileName);
        System.out.println("📂 MIME 타입: " + mimeType);

        if (fileName != null) {
            String lower = fileName.toLowerCase();
            if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png")) {
                subDir = "upload_image";
            } else if (lower.endsWith(".mp4") || lower.endsWith(".avi")) {
                subDir = "upload_video";
            } else {
                subDir = "upload_file";
            }

            // ✅ 실제 업로드할 경로: Z:/upload_*
            String saveDirPath = uploadBasePath + subDir;
            File saveDir = new File(saveDirPath);
            if (!saveDir.exists()) saveDir.mkdirs();

            File tempFile = new File(tempPath, fileName);
            File targetFile = new File(saveDir, fileName);
            boolean moved = tempFile.renameTo(targetFile);
            System.out.println("📂 파일 이동 성공 여부: " + moved);

            filePath = subDir + "/" + fileName;
            fileType = mimeType;
        }

        PostDTO post = new PostDTO();
        post.setTitle(title);
        post.setpContent(pContent);

        if (postIdStr == null || postIdStr.trim().isEmpty()) {
            post.setUserId(loginUser.getUserId());
            post.setCategory(category);
            if (filePath != null) {
                post.setFilePath(filePath);
                post.setFileType(fileType);
            }
            postService.insertPost(post);
            response.sendRedirect("CommunityListController");

        } else {
            int postId = Integer.parseInt(postIdStr);
            post.setPostId(postId);
            post.setCategory(category);

            PostDTO origin = postService.getPostById(postId);
            post.setUserId(origin.getUserId());

            if (filePath != null) {
                post.setFilePath(filePath);
                post.setFileType(fileType);
            } else {
                post.setFilePath(origin.getFilePath());
                post.setFileType(origin.getFileType());
            }

            postService.updatePost(post);
            response.sendRedirect("ViewPostController?postId=" + postId);
        }
    }
}
