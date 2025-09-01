package controller.community;

import model.dto.PostDTO;
import service.PostService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;

@WebServlet("/community/write")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
		maxFileSize = 10 * 1024 * 1024, // 10MB
		maxRequestSize = 50 * 1024 * 1024 // 50MB
)
public class CreatePostController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");

		// ✅ 공유 드라이브 경로 (Z 드라이브로 매핑되어 있어야 함)
		// ✅ 파일 파트 처리
		Part filePart = req.getPart("uploadFile");
		String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
		String fileType = null;
		String filePath = null;

		if (fileName != null && !fileName.isEmpty()) {
			fileType = filePart.getContentType(); // 예: image/png, video/mp4, application/pdf

			// ✅ 파일 타입에 따라 하위 폴더 분기
			String baseDir = "Z:/";
			String subDir;

			if (fileType.startsWith("image")) {
				subDir = "upload_image";
			} else if (fileType.startsWith("video")) {
				subDir = "upload_video";
			} else {
				subDir = "upload_file"; // 일반 파일은 여기에
			}

			String uploadPath = baseDir + subDir;
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists())
				uploadDir.mkdirs();

			// ✅ 실제 파일 저장
			filePart.write(uploadPath + File.separator + fileName);

			// ✅ 웹 접근용 상대 경로 DB에 저장
			filePath = subDir + "/" + fileName;
		}

		// ✅ 폼 파라미터 처리
		String userId = req.getParameter("userId");
		String category = req.getParameter("category");
		String title = req.getParameter("title");
		String pContent = req.getParameter("pContent");

		// ✅ DTO 생성
		PostDTO dto = new PostDTO();
		dto.setUserId(userId);
		dto.setCategory(category);
		dto.setTitle(title);
		dto.setpContent(pContent);
		dto.setFilePath(filePath);
		dto.setFileType(fileType);

		// ✅ DB 등록
		boolean result = new PostService().createPost(dto);

		// ✅ 성공 시 목록으로 이동, 실패 시 alert 후 뒤로가기
		if (result) {
			resp.sendRedirect(req.getContextPath() + "/CommunityListController");
		} else {
			resp.setContentType("text/html; charset=UTF-8");
			PrintWriter out = resp.getWriter();
			out.println("<script>alert('등록 실패'); history.back();</script>");
		}
	}
}
