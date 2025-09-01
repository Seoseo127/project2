<%@ page contentType="text/html;charset=UTF-8" language="java"
	isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/header.jsp" />

<%
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");

String today = sdf.format(new java.util.Date());
request.setAttribute("today", today);
%>

<!DOCTYPE html>
<html>
<head>
<br>
<br>
<br>

  <meta charset="UTF-8">
  <title>공부 메인</title>
  <link rel="stylesheet" href="<c:url value='/css/study_timer.css' />">
  <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
  <script src="<c:url value='/js/timer.js' />"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #f8f9fa;
      margin: 0;
      padding: 30px;
    }

    .container {
      max-width: 1100px;
      margin: auto;
      background-color: #ffffff;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    .total-time, .summary-time {
      text-align: center;
      font-size: 18px;
      margin-bottom: 20px;
      color: #2c3e50;
    }

    .summary-time span {
      font-weight: bold;
      color: #007bff;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }

    thead {
      background-color: #f1f3f5;
    }

    th, td {
      border: 1px solid #dee2e6;
      padding: 12px;
      text-align: center;
      vertical-align: middle;
      font-size: 14px;
    }

    .btn {
      display: inline-block;
      padding: 6px 12px;
      font-size: 13px;
      font-weight: bold;
      text-align: center;
      text-decoration: none;
      border-radius: 5px;
      border: 1px solid transparent;
      cursor: pointer;
      transition: background-color 0.2s ease-in-out;
    }

    .btn-sm {
      padding: 4px 10px;
      font-size: 12px;
    }

    .btn-outline-success {
      color: #28a745;
      border: 1px solid #28a745;
      background-color: #fff;
    }

    .btn-outline-success:hover {
      background-color: #28a745;
      color: #fff;
    }

    .btn-outline-secondary {
      color: #6c757d;
      border: 1px solid #6c757d;
      background-color: #fff;
    }

    .btn-outline-secondary:hover {
      background-color: #6c757d;
      color: #fff;
    }

    .btn-outline-danger {
      color: #dc3545;
      border: 1px solid #dc3545;
      background-color: #fff;
    }

    .btn-outline-danger:hover {
      background-color: #dc3545;
      color: #fff;
    }

    .btn-info {
      background-color: #17a2b8;
      color: white;
      border: none;
    }

    .btn-info:hover {
      background-color: #117a8b;
    }

    .chart-container {
      width: 80%;
      max-width: 700px;
      margin: 0 auto;
    }

    .status-icon {
      font-size: 1.2em;
      margin-left: 5px;
      vertical-align: middle;
    }

    .timer-text {
      width: 100px;
      font-family: monospace;
      display: inline-block;
      vertical-align: middle;
    }
  </style>
</head>

<body>
	<div class="container">

		<!-- ✅ 전체 목표/누적 시간 표시 (상단) -->
		<div class="total-time">🎯 전체 목표 시간: ${totalGoal} / 📚 현재 공부 시간:
			${totalStudy}</div>

		<h4 class="mb-4">⏱ 과목별 공부시간</h4>
		<table class="table table-bordered align-middle">
			<thead class="table-light">
				<tr>
					<th>과목</th>
					<th>마감일</th>
					<th>목표시간</th>
					<th>누적시간</th>
					<th>타이머</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="timer" items="${timerList}">
					<tr data-subject="${timer.subject}"
						data-goal="${timer.totalMinutes}" data-total="${timer.total}">
						<td>${timer.subject}</td>
						<td><fmt:formatDate value="${timer.deadline}"
								pattern="yyyy-MM-dd" /></td>
						<td><fmt:formatNumber value="${timer.totalMinutes}" />분</td>
						<td>
							<div id="display-${timer.subject}" class="timer-text">00:00:00</div>

							<span class="status-icon" id="status-icon-${timer.subject}">
								<c:choose>
									<c:when
										test="${not empty timer.status and fn:trim(timer.status) eq '완료'}">
                    ✔️
                  </c:when>
									<c:when
										test="${not empty timer.status and fn:trim(timer.status) eq '미완료'}">
                    ❌
                  </c:when>
									<c:otherwise>
										<%-- status 값이 null이거나 예상치 못한 값일 경우 --%>
										<%-- ❓ --%>
									</c:otherwise>
								</c:choose>
						</span>
						</td>
						<td>
							<button class="btn btn-outline-success btn-sm"
								onclick="startTimer('${timer.subject}', ${timer.todoId})">▶</button>
							<button class="btn btn-outline-secondary btn-sm"
								onclick="pauseTimer('${timer.subject}')">⏸</button>
							<button class="btn btn-outline-danger btn-sm"
								onclick="stopTimer('${timer.subject}', ${timer.todoId})">⏹</button>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<!-- TO DO LIST 이동 버튼 -->
		<div class="mt-4">
			<a href="<c:url value='/todo?action=list' />" class="btn btn-info">TO
				DO LIST</a>
		</div>

		<!-- ✅ 달성률 차트 (Chart.js로 변경) -->
		<div class="chart-area mt-5">
			<h3>📊 과목별 달성률</h3>
			<div class="chart-container">
				<canvas id="achievementChart"></canvas>
			</div>
		</div>
	</div>

	<script>
// ✅ 그래프를 그리는 함수 정의
function drawAchievementChart() {
    console.log("그래프를 갱신합니다...");

    // ✅ AJAX 요청으로 최신 데이터 가져오기
    fetch("/PROJECT_2/timer?action=getChartData") // 컨트롤러의 새로운 액션 호출
        .then(response => response.json()) // JSON 형태로 응답 받기
        .then(rawTimerData => { // 받아온 데이터를 rawTimerData로 사용
            const timerLabels = [];
            const timerAchievements = [];
            const backgroundColors = [];
            const borderColors = [];

            // ✅ JavaScript에서 배열을 순회하며 차트 데이터 준비
            rawTimerData.forEach(function(timer) {
                timerLabels.push(timer.subject);
                const total = timer.total; 
                const totalMinutes = timer.totalMinutes;
                let achievement = 0;
                if (totalMinutes > 0) {
                    achievement = (total / totalMinutes) * 100;
                }
                timerAchievements.push(achievement);

                // 달성률에 따른 색상 설정 (기존 코드와 동일)
                if (achievement >= 100) {
                    backgroundColors.push('rgba(75, 192, 192, 0.6)');
                    borderColors.push('rgba(75, 192, 192, 1)');
                } else if (achievement >= 50) {
                    backgroundColors.push('rgba(255, 206, 86, 0.6)');
                    borderColors.push('rgba(255, 206, 86, 1)');
                } else {
                    backgroundColors.push('rgba(255, 99, 132, 0.6)');
                    borderColors.push('rgba(255, 99, 132, 1)');
                }
            });

            const ctx = document.getElementById('achievementChart');
            // ✅ 기존 차트 인스턴스가 있다면 파괴하고 새로 그림
            if (window.achievementChartInstance) {
                window.achievementChartInstance.destroy();
            }

            window.achievementChartInstance = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: timerLabels,
                    datasets: [{
                        label: '달성률 (%)',
                        data: timerAchievements,
                        backgroundColor: backgroundColors,
                        borderColor: borderColors,
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100,
                            title: { display: true, text: '달성률 (%)' },
                            ticks: { callback: function(value) { return value + '%'; } }
                        },
                        x: {
                            title: { display: true, text: '과목' }
                        }
                    }
                }
            });
        })
        .catch(error => console.error('그래프 데이터를 가져오는 중 오류 발생:', error));
}

// ✅ 페이지 로드 시 차트 그리기 함수 호출 및 10초마다 갱신 설정
document.addEventListener('DOMContentLoaded', function() {
    drawAchievementChart(); // 초기 로드 시 한 번 그리기
    setInterval(drawAchievementChart, 10000); // 10초마다 갱신
});
</script>
</body>
</html>
