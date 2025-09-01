<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>📊 과목별 달성률</title>
<style>
body {
	font-family: 'Segoe UI', sans-serif;
	padding: 30px;
	background: #f8f9fa;
}

h2 {
	text-align: center;
	margin-bottom: 30px;
}

.bar-container {
	width: 400px;
	margin: 0 auto;
}

.bar-section {
	margin-bottom: 20px;
}

.subject {
	font-weight: bold;
	font-size: 18px;
}

.bar-background {
	background: #eee;
	border-radius: 5px;
	width: 100%;
	height: 24px;
	position: relative;
	overflow: hidden;
}

.bar-fill {
	height: 100%;
	/* text-align: right; */ /* ✅ 이 부분을 제거하거나 center로 변경 */
	/* padding-right: 8px; */ /* ✅ 이 부분을 제거하거나 줄여보기 */
	color: white;
	font-weight: bold;
	line-height: 24px;
	display: flex; /* ✅ flexbox 사용 */
	align-items: center; /* ✅ 세로 중앙 정렬 */
	justify-content: flex-end; /* ✅ 가로 오른쪽 정렬 */
	padding-right: 8px; /* ✅ 필요하다면 다시 추가하되, 여유 공간을 충분히 확보 */
	box-sizing: border-box; /* ✅ padding이 width에 포함되도록 */
}

.bar-background {
	background: #eee;
	border-radius: 5px;
	width: 100%;
	height: 24px;
	position: relative; /* ✅ 자식 요소를 절대 위치로 배치하기 위해 추가 */
	overflow: hidden;
}

.bar-fill {
	height: 100%;
	/* 기존의 text-align, padding-right, display:flex 관련 속성은 제거 */
	/* 글자가 bar-fill 안에 없으므로 필요 없음 */
}

.percent-text {
	position: absolute; /* ✅ 부모 요소(bar-background) 기준으로 절대 위치 */
	right: 8px; /* ✅ 오른쪽에서 8px 떨어진 위치 */
	top: 50%; /* ✅ 위에서 50% 위치 */
	transform: translateY(-50%); /* ✅ 세로 중앙 정렬 */
	font-weight: bold;
	line-height: 24px; /* 바의 높이와 동일하게 설정 */
	z-index: 1; /* ✅ 바 채움 위에 글자가 보이도록 설정 */
	/* color는 인라인 스타일로 동적으로 설정됨 */
}
</style>
</head>
<body>

	<h2>📊 과목별 달성률</h2>
	<div id="achievementChart" class="bar-container">
		<!-- 이 영역에 get_achievement_chart.jsp의 내용이 로드될 것임 -->
		<!-- 초기 로드를 위해 비어있거나 로딩 메시지를 넣을 수 있음 -->
		로딩 중...
	</div>

	<script>
	//차트 내용을 업데이트하는 함수
	function updateAchievementChart() {
	    const chartContainer = document.getElementById('achievementChart');
	    const xhr = new XMLHttpRequest();

	    // 1. 좌측 타이머 과목명 수집 (.subject-name 클래스가 과목명에 붙어있다고 가정)
	    const subjects = Array.from(document.querySelectorAll('.subject-name')).map(el => el.textContent.trim());

	    // 2. 파라미터 생성
	    const params = new URLSearchParams();
	    params.append('userId', 'hong01'); // 필요에 따라 동적 변경 가능
	    subjects.forEach(s => params.append('subjects', s));

	    // 3. AJAX GET 요청 (subjects 배열을 쿼리스트링으로 전달)
	    xhr.open('GET', '<%= request.getContextPath() %>/graph/get_achievement_chart.jsp?' + params.toString(), true);

	    xhr.onload = function() {
	        if (xhr.status === 200) {
	            chartContainer.innerHTML = xhr.responseText;
	            console.log('📊 차트 업데이트 완료!');
	        } else {
	            chartContainer.innerHTML = '차트 로드 실패.';
	            console.error('❌ 차트 업데이트 실패:', xhr.status);
	        }
	    };

	    xhr.onerror = function() {
	        chartContainer.innerHTML = '네트워크 오류.';
	        console.error('❌ 네트워크 오류로 차트 업데이트 실패');
	    };

	    xhr.send();
	}

	// 페이지 로드 시와 10초마다 차트 갱신
	document.addEventListener('DOMContentLoaded', updateAchievementChart);
	setInterval(updateAchievementChart, 10000);

    
</script>

</body>
</html>
