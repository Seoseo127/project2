<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.dto.ReportDTO, java.util.List" %>
<%@ include file="admin_header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    List<ReportDTO> approvedReports = (List<ReportDTO>) request.getAttribute("approvedReports");
    int currentPage = 1;
    int size = 10;
    try {
        currentPage = Integer.parseInt(request.getParameter("page"));
    } catch (Exception ignored) {}

    int start = (currentPage - 1) * size;
    int end = Math.min(start + size, approvedReports.size());
    List<ReportDTO> pagedList = approvedReports.subList(start, end);

    request.setAttribute("pagedList", pagedList);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", (int) Math.ceil((double) approvedReports.size() / size));
%>

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

    button {
        padding: 6px 12px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
    }

    button[name="action"][value="reject"] {
        background-color: #f87171;
        color: white;
    }

    button[name="action"][value="approve"] {
        background-color: #60a5fa;
        color: white;
    }
</style>

<h2>✔️ 처리된 신고 목록</h2>

<table>
    <tr>
        <th>신고 번호</th>
        <th>타입</th>
        <th>작성자</th>
        <th>신고자</th>
        <th>사유</th>
        <th>신고일</th>
        <th>상태</th>
        <th>반려/재승인</th>
    </tr>
    <c:forEach var="r" items="${pagedList}">
        <tr>
            <td>${r.reportId}</td>
            <td>
                <c:choose>
                    <c:when test="${r.targetType == 'post'}">
                        <a href="${pageContext.request.contextPath}/ViewPostController?postId=${r.targetId}">게시글</a>
                    </c:when>
                    <c:when test="${r.targetType == 'comment'}">
                        <a href="${pageContext.request.contextPath}/ViewPostController?postId=${r.postId}">댓글</a>
                    </c:when>
                    <c:otherwise>기타</c:otherwise>
                </c:choose>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/AdminUserDetailController?userId=${r.targetUserId}">
                    ${r.targetUserId}
                </a>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/AdminUserDetailController?userId=${r.reporterId}">
                    ${r.reporterId}
                </a>
            </td>
            <td>${r.content}</td>
            <td><fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
            <td>
                <c:choose>
                    <c:when test="${r.status == '승인'}">
                        <span style="color:red; font-weight:bold;">승인</span>
                    </c:when>
                    <c:when test="${r.status == '거부'}">
                        <span style="color:green; font-weight:bold;">취소</span>
                    </c:when>
                </c:choose>
            </td>
            <td>
                <form action="${pageContext.request.contextPath}/AdminReportProcessListController" method="post" style="display:inline;">
                    <input type="hidden" name="reportId" value="${r.reportId}" />
                    <c:choose>
                        <c:when test="${r.status == '승인'}">
                            <button type="submit" name="action" value="reject">신고 취소</button>
                        </c:when>
                        <c:when test="${r.status == '거부'}">
                            <button type="submit" name="action" value="approve">신고 승인</button>
                        </c:when>
                    </c:choose>
                </form>
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
