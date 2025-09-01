package controller.community;

import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.dto.PostDTO;
import service.PostService;

@WebServlet("/CommunityListController")
public class CommunityListController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 파라미터 받기
		String category = request.getParameter("category");
		String keyword = request.getParameter("keyword");

		// 기본값 처리
		if (category == null || category.trim().equals(""))
			category = "all";

		if (keyword == null)
			keyword = "";

		int page = 1;
		int limit = 10;
		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		int offset = (page - 1) * limit;

		// 서비스 호출
		PostService postService = new PostService();

		int totalCount = postService.getTotalPostCount(category, keyword);
		List<PostDTO> postList = postService.getPostsWithPaging(category, keyword, offset, limit);

		// ✅ 카테고리 조건에 따른 인기글 불러오기
		List<PostDTO> topPosts;
		if ("all".equals(category)) {
			topPosts = postService.getTopPosts(); // 전체 인기글
		} else {
			topPosts = postService.getTopPostsByCategory(category); // 카테고리별 인기글
		}

		// ✅ postList에서 인기글 제외
		Set<Integer> topIds = topPosts.stream().map(PostDTO::getPostId).collect(Collectors.toSet());

		List<PostDTO> restPosts = postList.stream().filter(p -> !topIds.contains(p.getPostId()))
				.collect(Collectors.toList());

		int totalPages = (int) Math.ceil((double) totalCount / limit);

		// request에 담고 forward
		request.setAttribute("topPosts", topPosts); // 인기글
		request.setAttribute("postList", postList); // 페이징된 일반 글
		request.setAttribute("postList", postList);
		request.setAttribute("currentPage", page);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("category", category);
		request.setAttribute("keyword", keyword);

		request.getRequestDispatcher("community.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
