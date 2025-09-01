<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.dto.ReportDTO, java.util.List" %>
<%@ include file="admin_header.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    List<ReportDTO> fullList = (List<ReportDTO>) request.getAttribute("reportList");
    int currentPage = 1;
    int size = 10;
    try {
        currentPage = Integer.parseInt(request.getParameter("page"));
    } catch (Exception ignored) {}

    int start = (currentPage - 1) * size;
    int end = Math.min(start + size, fullList.size());
    List<ReportDTO> pagedList = fullList.subList(start, end);

    request.setAttribute("pagedList", pagedList);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", (int) Math.ceil((double) fullList.size() / size));
%>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/menu_bar_admin.css">
<style>
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        background-color: #fff;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    th, td {
        padding: 12px 16px;
        text-align: center;
        border-bottom: 1px solid #eee;
    }

    th {
        background-color: #f0f4f8;
        font-weight: bold;
    }

    tr:hover {
        background-color: #f9fafb;
    }

    .pagination {
        margin-top: 30px;
        text-align: center;
    }

    .pagination a {
        display: inline-block;
        margin: 0 5px;
        padding: 6px 12px;
        background-color: #e2e8f0;
        color: #333;
        border-radius: 6px;
        text-decoration: none;
    }

    .pagination a.active {
        background-color: #3b82f6;
        color: white;
        font-weight: bold;
    }

    .pagination a:hover {
        background-color: #93c5fd;
    }

    h2 {
        margin-top: 30px;
    }
</style>
<style>
    /* 기존 table, pagination 등은 그대로 두고 아래 버튼 스타일만 추가해 */
    button {
        padding: 6px 12px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        margin: 2px;
    }

    button.approve {
        background-color: #60a5fa;
        color: white;
    }

    button.approve:hover {
        background-color: #3b82f6;
    }

    button.reject {
        background-color: #f87171;
        color: white;
    }

    button.reject:hover {
        background-color: #ef4444;
    }
</style>


<h2>📋 신고 목록</h2>

<table>
	<tr>
		<th>신고 번호</th>
		<th>사유</th>
		<th>신고일</th>
		<th>처리</th>
	</tr>

	<c:forEach var="r" items="${pagedList}">
		<tr>
			<td>${r.reportId}</td>
			<td>${r.content}</td>
			<td><fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
			<td>
				<c:choose>
					<c:when test="${r.status == '승인'}">
						<span style="color: red; font-weight: bold;">승인</span>
					</c:when>
					<c:when test="${r.status == '거부'}">
						<span style="color: green; font-weight: bold;">취소</span>
					</c:when>
					<c:otherwise>
						<button onclick="processReport(${r.reportId}, 'approve', this)">신고 승인</button>
						<button onclick="processReport(${r.reportId}, 'reject', this)">신고 취소</button>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</c:forEach>
</table>

<!-- ✅ 페이징 -->
<div class="pagination">
    <c:forEach var="i" begin="1" end="${totalPages}">
        <c:choose>
            <c:when test="${i == currentPage}">
                <a href="?page=${i}" class="active">${i}</a>
            </c:when>
            <c:otherwise>
                <a href="?page=${i}">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>

<script>
function processReport(reportId, action, btn) {
    if (!confirm("정말 처리하시겠습니까?")) return;
    fetch('${pageContext.request.contextPath}/AdminReportProcessController', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: new URLSearchParams({reportId: reportId, action: action})
    })
    .then(res => {
        if (!res.ok) throw new Error('처리 실패');
        btn.closest('tr').remove();
    })
    .catch(e => alert(e.message));
}
</script>

<script>
function goToReportedPost(reportId) {
    fetch('${pageContext.request.contextPath}/GetPostIdByReportIdController?reportId=' + reportId)
    .then(response => response.json())
    .then(data => {
        if (data.postId) {
            window.location.href = '${pageContext.request.contextPath}/ViewPostController?postId=' + data.postId;
        } else {
            alert('해당 게시글을 찾을 수 없습니다.');
        }
    })
    .catch(e => alert('오류 발생: ' + e.message));
}
</script>
