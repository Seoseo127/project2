<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*, java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="model.dto.UserDTO"%>
<c:set var="user" value="${sessionScope.loginUser}" />
<%@ include file="/header.jsp"%>

<c:if test="${needLogin == true}">
	<script>
		alert("로그인이 필요한 페이지입니다.");
		location.href = "login.jsp";
	</script>
</c:if>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/menu_bar.css" />
<style>
body {
	background-color: #F7FBFE;
	font-family: 'Pretendard', sans-serif;
	margin: 0;
}

.container {
	display: flex;
	flex-direction: column;
	align-items: center;
	padding: 50px 20px;
}

.mypage-wrapper {
	text-align: center;
	width: 100%;
	max-width: 800px;
}

.mypage-wrapper h2 {
	font-size: 24px;
	font-weight: 700;
	margin-bottom: 30px;
	color: #111;
}

.card {
	background-color: #ffffff;
	border-radius: 1.5rem;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	padding: 2rem;
	margin-bottom: 2rem;
}

.card p {
	margin: 10px 0;
	font-size: 15px;
	color: #333;
}

.card p strong {
	color: #222;
}

.stats-container {
	display: flex;
	justify-content: center;
	gap: 2rem;
	flex-wrap: wrap;
	margin-top: 2rem;
}

.stat-card {
	background-color: #ffffff;
	border-radius: 1.5rem;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
	padding: 1.5rem;
	text-align: center;
	width: 160px;
	cursor: pointer;
	transition: all 0.2s;
}

.stat-card:hover {
	background: #f0f4ff;
	transform: translateY(-4px);
}

.stat-card h4 {
	font-size: 1rem;
	margin-bottom: 1rem;
	font-weight: 600;
	color: #222;
}

.stat-card span {
	font-size: 1.25rem;
	font-weight: bold;
	color: #3b82f6;
}

.btn {
	background-color: #3b82f6;
	color: white;
	padding: 0.6rem 1.2rem;
	border: none;
	border-radius: 0.75rem;
	font-size: 0.95rem;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.btn:hover {
	background-color: #2563eb;
}

#activityResult {
	margin-top: 30px;
	max-width: 800px;
	width: 100%;
}

/* ✅ 커스텀 팝업 스타일 */
#customAlert {
	display: none;
	position: fixed;
	top: 35%;
	left: 50%;
	transform: translateX(-50%);
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
	padding: 20px;
	z-index: 1000;
	width: 280px;
	text-align: center;
}

#overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.4);
	z-index: 999;
}

#customAlert button {
	margin-top: 16px;
	padding: 6px 14px;
	background: #3b82f6;
	color: #fff;
	border: none;
	border-radius: 6px;
	font-weight: bold;
	cursor: pointer;
}
</style>
</head>
<body>
	<div class="container">
		<div class="mypage-wrapper">
			<h2>${user.nickname}님의마이페이지</h2>

			<div class="card">
				<p>
					<strong>아이디:</strong> ${user.userId}
				</p>
				<p>
					<strong>닉네임:</strong> ${user.nickname}
				</p>
				<p>
					<strong>이메일:</strong> ${user.email}
				</p>
				<p>
					<strong>회원유형:</strong> ${user.userGrade}
				</p>
				<form action="check_pw.jsp" method="get">
					<button type="submit" class="btn">정보 수정</button>
				</form>
			</div>

			<c:choose>
				<c:when test="${param.action eq 'getMyPosts'}">
					<jsp:include page="my_post_list.jsp" />
				</c:when>
				<c:when test="${param.action eq 'getMyComments'}">
					<jsp:include page="my_comment_list.jsp" />
				</c:when>
			</c:choose>

			<div class="stats-container">
				<div class="stat-card" onclick="loadMyPosts()">
					<h4>내가 쓴 글</h4>
					<span>📄 ${postCount != null ? postCount : 0}개</span>
				</div>
				<div class="stat-card" onclick="loadMyComments()">
					<h4>내가 쓴 댓글</h4>
					<span>💬 ${commentCount != null ? commentCount : 0}개</span>
				</div>
				<div class="stat-card" onclick="loadMyScraps()">
					<h4>스크랩한 글</h4>
					<span id="scrapCount"> <span class="icon">🔖</span> <span
						class="count">${scrapCount != null ? scrapCount : 0}</span>개
					</span>
				</div>
			</div>

			<div id="activityResult"></div>
		</div>
	</div>

	<!-- ✅ 커스텀 팝업 -->
	<div id="overlay"></div>
	<div id="customAlert">
		<p id="alertMessage"
			style="margin: 0; font-size: 16px; font-weight: bold;"></p>
		<button onclick="closeAlert()">확인</button>
	</div>

	<script>
function loadMyPosts(page = 1) {
	fetch("user/ajax", {
		method: "POST",
		headers: { "Content-Type": "application/x-www-form-urlencoded" },
		body: "action=getMyPosts&page=" + page
	})
	.then(res => res.text())
	.then(html => {
		document.getElementById("activityResult").innerHTML = html;
	});
}

function loadMyComments(page = 1) {
	fetch("user/ajax", {
		method: "POST",
		headers: { "Content-Type": "application/x-www-form-urlencoded" },
		body: "action=getMyComments&page=" + page
	})
	.then(res => res.text())
	.then(html => {
		document.getElementById("activityResult").innerHTML = html;
	});
}

function loadMyScraps(page = 1) {
	fetch("user/ajax", {
		method: "POST",
		headers: { "Content-Type": "application/x-www-form-urlencoded" },
		body: "action=getMyScraps&page=" + page
	})
	.then(res => res.text())
	.then(html => {
		document.getElementById("activityResult").innerHTML = html;
	});
}

const contextPath = "${pageContext.request.contextPath}"; // JSP에서 contextPath 추출

function unscrap(postId) {
	showConfirm("스크랩을 취소하시겠습니까?", () => {
		fetch(contextPath + "/scrap", {
			method: "POST",
			headers: { "Content-Type": "application/x-www-form-urlencoded" },
			body: "postId=" + encodeURIComponent(postId) + "&add=false"
		})
		.then(async res => {
			const data = await res.json().catch(() => null);
			if (!res.ok || !data || data.success === false) {
				console.error("응답 오류 또는 실패:", data);
				showAlert("스크랩 취소 실패: " + (data?.message || "서버 응답 오류"));
				return;
			}
			showAlert(data.message, () => {
				// ✅ 카드 제거
				const postElement = document.getElementById("post-" + postId);
				if (postElement) postElement.remove();

				// ✅ 스크랩 수 감소 (안전하게)
				const scrapCountEl = document.getElementById("scrapCount");
				if (scrapCountEl) {
				const countSpan = scrapCountEl.querySelector(".count");

				if (countSpan) {
				let count = parseInt(countSpan.innerText, 10);
				if (isNaN(count)) count = 0;
				count = Math.max(0, count - 1);
				countSpan.innerText = count;
				} else {
				console.warn("⚠️ .count 요소를 찾을 수 없습니다");
				}
				} else {
				console.warn("❌ scrapCountEl 요소가 없습니다");
				}
			});
		})
		.catch(err => {
			console.error("스크랩 취소 오류:", err);
			showAlert("스크랩 취소 중 오류가 발생했습니다.");
		});
	});
}

// ✅ 커스텀 알림
function showAlert(message, callback) {
	const overlay = document.getElementById("overlay");
	const box = document.getElementById("customAlert");
	const messageEl = document.getElementById("alertMessage");

	if (!messageEl) {
		console.error("alertMessage 요소가 존재하지 않습니다.");
		return;
	}

	messageEl.textContent = message;

	// 버튼 정리 (기존 버튼 제거)
	const oldButtons = box.querySelectorAll("button");
	oldButtons.forEach(btn => btn.remove());

	// 확인 버튼 추가
	const okBtn = document.createElement("button");
	okBtn.textContent = "확인";
	okBtn.style.marginTop = "16px";
	okBtn.onclick = () => {
		closeAlert();
		if (callback) callback();
	};
	box.appendChild(okBtn);

	overlay.style.display = "block";
	box.style.display = "block";
}

// ✅ 커스텀 확인창
function showConfirm(message, onConfirm) {
	const overlay = document.getElementById("overlay");
	const box = document.getElementById("customAlert");
	const messageEl = document.getElementById("alertMessage");

	if (!messageEl) {
		console.error("alertMessage 요소가 존재하지 않습니다.");
		return;
	}

	messageEl.textContent = message;

	// 기존 버튼 제거 (단, 메시지 요소는 유지)
	const oldButtons = box.querySelectorAll("button");
	oldButtons.forEach(btn => btn.remove());

	const confirmBtn = document.createElement("button");
	confirmBtn.textContent = "확인";
	confirmBtn.style.marginRight = "8px";

	const cancelBtn = document.createElement("button");
	cancelBtn.textContent = "취소";
	cancelBtn.style.backgroundColor = "#888";

	confirmBtn.onclick = () => {
		closeAlert();
		onConfirm();
	};

	cancelBtn.onclick = () => {
		closeAlert();
	};

	const container = document.createElement("div");
	container.style.marginTop = "16px";
	container.appendChild(confirmBtn);
	container.appendChild(cancelBtn);
	box.appendChild(container);

	overlay.style.display = "block";
	box.style.display = "block";
}

function closeAlert() {
	document.getElementById("customAlert").style.display = "none";
	document.getElementById("overlay").style.display = "none";
}

</script>

</body>
</html>
