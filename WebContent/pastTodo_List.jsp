<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>완료한 TODO 목록</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	padding: 20px;
}

.todo-container {
	max-width: 1000px;
	margin: auto;
}
/* 클릭 가능한 제목 스타일 */
.clickable-subject {
	cursor: pointer;
	color: #007bff; /* 파란색 텍스트 */
	text-decoration: underline; /* 밑줄 */
}

.clickable-subject:hover {
	color: #0056b3; /* 호버 시 더 진한 파란색 */
}
/* 모달 내용 정렬 */
.modal-body p {
	margin-bottom: 5px;
}

.modal-body strong {
	display: inline-block;
	width: 100px; /* 라벨 너비 고정 */
}
</style>
</head>
<body>
	<div class="todo-container">
		<h2 class="text-center mb-4">✅ 완료한 TODO 목록</h2>

		<c:if test="${empty sessionScope.loginUser}">
			<p>로그인이 필요합니다.</p>
			<a href="../login.jsp" class="btn btn-primary">로그인하러 가기</a>
		</c:if>

		<c:if test="${not empty sessionScope.loginUser}">
			<table
				class="table table-bordered table-striped text-center align-middle">
				<thead class="table-light">
					<tr>
						<th>과목</th>
						<th>피드백</th>
						<th>작성일</th>
						<th>상태</th>
						<%-- ✅ 컬럼 헤더 변경 --%>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>

					<c:forEach var="todo" items="${pastTodoList}">
						<tr>

							<%-- ✅ 과목 제목을 클릭 가능하게 변경 (content, goal, total 전달) --%>
							<td class="clickable-subject"
								onclick='openContentModal(
                    "${fn:escapeXml(todo.subject)}",
                    "${fn:escapeXml(todo.content)}",
                    "${todo.goal}",
                    "${todo.total}"
                )'>
								${todo.subject}</td>
							<td><c:set var="escapedFeedback"
									value="${fn:escapeXml(todo.feedback)}" /> <c:choose>
									<c:when test="${empty todo.feedback}">
										<button type="button" class="btn btn-warning btn-sm"
											onclick='openFeedbackModal(${todo.todoId}, "", false)'>
											피드백 작성</button>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-info btn-sm"
											onclick='openFeedbackModal(${todo.todoId}, "${escapedFeedback}", true)'>
											피드백</button>
									</c:otherwise>
								</c:choose></td>
							<td><fmt:formatDate value="${todo.createdAt}"
									pattern="yyyy-MM-dd" /></td>
							<td>
								<%-- ✅ 상태 로직 변경 --%> <c:choose>
									<c:when
										test="${todo.total >= todo.totalMinutes and todo.totalMinutes > 0}">
                  완료
                </c:when>
									<c:when
										test="${todo.total < todo.totalMinutes and todo.deadline lt todayDate}">
										<%-- todayDate는 컨트롤러에서 넘겨줘야 함 --%>
                  기간 초과
                </c:when>
									<c:otherwise>
                  미완료
                </c:otherwise>
								</c:choose>
							</td>
							<td>
								<form method="post" action="todo"
									onsubmit="return confirm('정말 삭제하시겠습니까?');">
									<input type="hidden" name="action" value="delete" /> <input
										type="hidden" name="todoId" value="${todo.todoId}" />
									<button type="submit" class="btn btn-outline-danger btn-sm">삭제</button>
								</form>
							</td>
						</tr>
					</c:forEach>

					<c:if test="${empty pastTodoList}">
						<tr>
							<td colspan="5" class="text-muted">완료된 할 일이 없습니다.</td>
							<%-- colspan 변경 --%>
						</tr>
					</c:if>
				</tbody>
			</table>

			<div class="text-center mt-4">
				<a href="<c:url value='/todo?action=list' />" class="btn btn-dark">←
					TO DO LIST 돌아가기</a>
			</div>
		</c:if>
	</div>

	<!-- 📦 피드백 입력/보기 모달 -->
	<div class="modal fade" id="feedbackModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">피드백 입력</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="닫기"></button>
				</div>
				<div class="modal-body">
					<textarea id="feedbackText" class="form-control" rows="4"
						placeholder="피드백을 입력하세요."></textarea>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">닫기</button>
					<button type="button" class="btn btn-primary" id="saveFeedbackBtn"
						onclick="submitFeedback()">저장</button>
				</div>
			</div>
		</div>
	</div>

	<!-- ✅ 할 일 내용 보기 모달 수정 -->
	<div class="modal fade" id="contentModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="contentModalSubject"></h5>
					<%-- 과목 제목 표시 --%>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="닫기"></button>
				</div>
				<div class="modal-body">
					<p>
						<strong>내용:</strong> <span id="contentModalContent"></span>
					</p>
					<%-- 내용 표시 --%>
					<p>
						<strong>목표시간:</strong> <span id="contentModalGoal"></span>분
					</p>
					<%-- 목표시간 표시 --%>
					<p>
						<strong>누적공부시간:</strong> <span id="contentModalTotal"></span>분
					</p>
					<%-- 누적공부시간 표시 --%>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

	<script>
  let currentTodoId = null;
  let isReadOnly = false;

  function openFeedbackModal(todoId, feedback, readOnly) {
    currentTodoId = todoId;
    isReadOnly = readOnly;

    const textarea = document.getElementById('feedbackText');
    textarea.value = feedback.replaceAll('\\n', '\n');
    textarea.readOnly = readOnly;

    document.querySelector('#feedbackModal .modal-title').textContent =
      readOnly ? '작성된 피드백' : '피드백 입력';

    document.getElementById('saveFeedbackBtn').style.display = readOnly ? 'none' : 'inline-block';

    const modal = new bootstrap.Modal(document.getElementById('feedbackModal'));
    modal.show();
  }

  function submitFeedback() {
	    const feedback = document.getElementById('feedbackText').value.trim();
	    if (!feedback) {
	      alert("피드백을 입력해주세요.");
	      return;
	    }

	    console.log("DEBUG: Submitting feedback for todoId:", currentTodoId, "feedback:", feedback); // ✅ 1단계: 요청 시작

	    fetch("todo?action=feedback", {
	      method: "POST",
	      headers: {
	        "Content-Type": "application/x-www-form-urlencoded",
	      },
	      body: "todoId=" + encodeURIComponent(currentTodoId) + "&feedback=" + encodeURIComponent(feedback)
	    })
	    .then(response => {
	        console.log('DEBUG: Raw response object:', response); // ✅ 2단계: 원본 응답 객체 확인
	        console.log('DEBUG: Response status:', response.status); // ✅ 3단계: HTTP 상태 코드 확인
	        console.log('DEBUG: Response headers:', response.headers); // ✅ 4단계: 응답 헤더 확인

	        // 응답이 비어있거나 유효하지 않은 JSON일 경우를 대비한 추가 확인
	        if (!response.ok) { // HTTP 상태 코드가 200번대가 아닐 경우
	            console.error('ERROR: HTTP error! Status:', response.status);
	            return response.text().then(text => { // 텍스트로 응답 본문 읽기 시도
	                console.error('ERROR: Response text (if any):', text);
	                throw new Error(`HTTP error! Status: ${response.status}, Body: ${text}`);
	            });
	        }
	        
	        // 응답 본문이 비어있는지 확인 (json() 파싱 전에)
	        const contentType = response.headers.get("content-type");
	        if (contentType && contentType.indexOf("application/json") !== -1) {
	            return response.json(); // ✅ 5단계: JSON 파싱 시도
	        } else {
	            console.warn("WARNING: Server did not return JSON. Content-Type:", contentType);
	            return response.text().then(text => { // JSON이 아니면 텍스트로 읽기
	                console.log("DEBUG: Non-JSON response text:", text);
	                throw new Error("Server did not return JSON. Response: " + text);
	            });
	        }
	    })
	    .then(data => {
	        console.log('DEBUG: Parsed JSON data:', data); // ✅ 6단계: 파싱된 JSON 데이터 확인
	        
	        if (data.status === 'success') {
	            alert("피드백이 저장되었습니다.");
	            const modal = bootstrap.Modal.getInstance(document.getElementById('feedbackModal'));
	            modal.hide();
	            location.reload(); 
	        } else {
	            alert("피드백 저장에 실패했습니다.");
	        }
	    })
	    .catch(error => {
	        console.error('ERROR: Final catch block - Error during fetch or JSON parsing:', error); // ✅ 7단계: 최종 에러 객체 확인
	        alert("피드백 저장 중 오류가 발생했습니다.");
	    });
	}

  // ✅ 할 일 내용 보기 모달 함수 수정
function openContentModal(subject, content, goal, total) {
  console.log("DEBUG >>", { subject, content, goal, total });
  document.getElementById('contentModalSubject').textContent = subject;
  document.getElementById('contentModalContent').textContent = content;
  document.getElementById('contentModalGoal').textContent = goal;
  document.getElementById('contentModalTotal').textContent = total;
  const modal = new bootstrap.Modal(document.getElementById('contentModal'));
  modal.show();
}
</script>


	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
