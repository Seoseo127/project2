<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.apache.ibatis.io.Resources"%>
<%@ page import="org.apache.ibatis.session.SqlSession"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactory"%>
<%@ page import="org.apache.ibatis.session.SqlSessionFactoryBuilder"%>
<%@ page import="model.dto.UserDTO"%>
<%@ page import="java.io.Reader"%>
<%@ include file="/header.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>달력</title>
<style>
body {
	font-family: Arial, sans-serif;
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-top: 20px;
}

.calendar-container {
	width: 80%;
	max-width: 800px;
	border: 1px solid #ccc;
	border-radius: 8px;
	padding: 20px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.calendar-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.calendar-header h2 {
	margin: 0;
	font-size: 1.8em;
}

.nav-button {
	text-decoration: none;
	color: #007bff;
	font-size: 1.2em;
	padding: 5px 10px;
	border: 1px solid #007bff;
	border-radius: 5px;
	transition: background-color 0.3s, color 0.3s;
}

.nav-button:hover {
	background-color: #007bff;
	color: white;
}

.weekdays {
	display: grid;
	grid-template-columns: repeat(7, 1fr);
	text-align: center;
	font-weight: bold;
	background-color: #f0f0f0;
	padding: 10px 0;
	border-bottom: 1px solid #eee;
}

.weekdays div:first-child {
	color: red;
} /* 일요일 */
.weekdays div:last-child {
	color: blue;
} /* 토요일 */
.calendar-grid {
	display: grid;
	grid-template-columns: repeat(7, 1fr);
	gap: 1px;
	background-color: #eee; /* 그리드 라인 효과 */
	border: 1px solid #eee;
}

.day-cell {
	background-color: white;
	min-height: 100px;
	padding: 5px;
	text-align: right;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	align-items: flex-end;
	cursor: pointer;
}

.day-cell.other-month {
	background-color: #f9f9f9;
	cursor: default;
}

.day-cell.today {
	border: 2px solid #007bff;
	box-sizing: border-box; /* 테두리가 셀 크기에 포함되도록 */
}

.day-cell.has-event {
	background-color: #e6f7ff; /* 이벤트 있는 날짜 배경색 */
}

.day-link {
	text-decoration: none;
	color: inherit;
	display: flex;
	flex-direction: column;
	width: 100%;
	height: 100%;
	align-items: flex-end;
}

.day-number {
	font-weight: bold;
	font-size: 1.2em;
	margin-bottom: 5px;
}

.emojis {
	display: flex;
	flex-direction: column;
	align-items: flex-end;
	font-size: 0.9em;
	width: 100%; /* 이모지 영역이 셀 너비에 맞도록 */
}

.completed-emoji, .uncompleted-emoji {
	margin-top: 2px;
	padding: 2px 4px;
	border-radius: 3px;
	display: inline-block; /* 이모지 옆에 개수 표시 */
}

.completed-emoji {
	background-color: #e0ffe0; /* 연한 초록 */
}

.uncompleted-emoji {
	background-color: #ffe0e0; /* 연한 빨강 */
}

.no-login-message {
	text-align: center;
	margin-top: 20px;
	font-size: 1.1em;
	color: #555;
}

.no-login-message a {
	color: #007bff;
	text-decoration: none;
	font-weight: bold;
}

/* 모달 스타일 */
#todoModal {
	display: none;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 80%;
	max-width: 600px;
	background: white;
	border-radius: 10px;
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
	z-index: 99999;
	padding: 20px;
	max-height: 70vh;
	overflow-y: auto;
}

#modalBackdrop {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	z-index: 99995;
}

#todoModal button {
	margin-top: 20px;
	padding: 10px 20px;
	background-color: #6c757d;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	font-size: 1em;
	transition: background-color 0.3s ease;
}

#todoModal button:hover {
	background-color: #5a6268;
}
</style>
</head>
<body>

	<div class="calendar-container">
		<%
		// 1. 로그인된 사용자 정보
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
		String userId = (loginUser != null) ? loginUser.getUserId() : null;

		// 2. 표시할 연도/월 계산 (기본은 현재 날짜)
		Calendar currentCal = Calendar.getInstance();
		int currentYear = currentCal.get(Calendar.YEAR);
		int currentMonth = currentCal.get(Calendar.MONTH) + 1;

		String paramYear = request.getParameter("year");
		String paramMonth = request.getParameter("month");

		int displayYear = currentYear;
		int displayMonth = currentMonth;

		if (paramYear != null && paramMonth != null) {
			try {
				displayYear = Integer.parseInt(paramYear);
				displayMonth = Integer.parseInt(paramMonth);
				if (displayMonth < 1) {
			displayMonth = 12;
			displayYear--;
				} else if (displayMonth > 12) {
			displayMonth = 1;
			displayYear++;
				}
			} catch (NumberFormatException e) {
			}
		}

		// 3. 캘린더 기본 정보 계산
		Calendar cal = Calendar.getInstance();
		cal.set(displayYear, displayMonth - 1, 1);
		int startDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
		int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

		int prevMonth = displayMonth - 1;
		int prevYear = displayYear;
		if (prevMonth < 1) {
			prevMonth = 12;
			prevYear--;
		}
		int nextMonth = displayMonth + 1;
		int nextYear = displayYear;
		if (nextMonth > 12) {
			nextMonth = 1;
			nextYear++;
		}

		// 4. DB에서 완료/미완료 날짜별 개수 조회 및 누적 처리
		Map<String, Integer> completedCounts = new HashMap<>();
		Map<String, Integer> uncompletedCounts = new HashMap<>();

		List<Map<String, Object>> uncompletedList = null;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		if (userId != null) {
			SqlSession sqlSession = null;
			try {
				Reader reader = Resources.getResourceAsReader("util/config.xml");
				SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
				reader.close();

				sqlSession = sqlSessionFactory.openSession();

				Calendar startOfMonthCal = (Calendar) cal.clone();
				startOfMonthCal.set(Calendar.DAY_OF_MONTH, 1);
				startOfMonthCal.set(Calendar.HOUR_OF_DAY, 0);
				startOfMonthCal.set(Calendar.MINUTE, 0);
				startOfMonthCal.set(Calendar.SECOND, 0);
				startOfMonthCal.set(Calendar.MILLISECOND, 0);
				String startOfMonthDate = sdf.format(startOfMonthCal.getTime());

				Calendar endOfMonthCal = (Calendar) cal.clone();
				endOfMonthCal.set(Calendar.DAY_OF_MONTH, daysInMonth);
				endOfMonthCal.set(Calendar.HOUR_OF_DAY, 23);
				endOfMonthCal.set(Calendar.MINUTE, 59);
				endOfMonthCal.set(Calendar.SECOND, 59);
				endOfMonthCal.set(Calendar.MILLISECOND, 999);
				String endOfMonthDate = sdf.format(endOfMonthCal.getTime());

				Map<String, Object> params = new HashMap<>();
				params.put("userId", userId);
				params.put("startOfMonthDate", startOfMonthDate);
				params.put("endOfMonthDate", endOfMonthDate);

				List<Map<String, Object>> completedList = sqlSession.selectList("CALENDAR.selectCompletedCountsByMonth",
				params);
				for (Map<String, Object> row : completedList) {
			String clearDate = (String) row.get("CLEAR_DATE");
			Object countObj = row.get("COMPLETED_COUNT");
			int count = 0;
			if (countObj instanceof java.math.BigDecimal) {
				count = ((java.math.BigDecimal) countObj).intValue();
			} else if (countObj instanceof Integer) {
				count = (Integer) countObj;
			}
			completedCounts.put(clearDate, count);
				}

				uncompletedList = sqlSession.selectList("CALENDAR.selectActiveUncompletedTasksForMonth", params);

				Calendar tempCal = (Calendar) startOfMonthCal.clone();
				tempCal.set(Calendar.HOUR_OF_DAY, 0);
				tempCal.set(Calendar.MINUTE, 0);
				tempCal.set(Calendar.SECOND, 0);
				tempCal.set(Calendar.MILLISECOND, 0);

				Calendar endOfMonthCalForIter = (Calendar) endOfMonthCal.clone();
				endOfMonthCalForIter.set(Calendar.HOUR_OF_DAY, 0);
				endOfMonthCalForIter.set(Calendar.MINUTE, 0);
				endOfMonthCalForIter.set(Calendar.SECOND, 0);
				endOfMonthCalForIter.set(Calendar.MILLISECOND, 0);

				while (!tempCal.after(endOfMonthCalForIter)) {
			uncompletedCounts.put(sdf.format(tempCal.getTime()), 0);
			tempCal.add(Calendar.DAY_OF_MONTH, 1);
				}

				for (Map<String, Object> todo : uncompletedList) {
			Object createdAtObj = todo.get("CREATED_AT");
			Object deadlineObj = todo.get("DEADLINE");

			Date createdAt = null;
			if (createdAtObj instanceof java.sql.Timestamp) {
				createdAt = new Date(((java.sql.Timestamp) createdAtObj).getTime());
			} else if (createdAtObj instanceof java.util.Date) {
				createdAt = (java.util.Date) createdAtObj;
			}

			Date deadline = null;
			if (deadlineObj instanceof java.sql.Timestamp) {
				deadline = new Date(((java.sql.Timestamp) deadlineObj).getTime());
			} else if (deadlineObj instanceof java.util.Date) {
				deadline = (java.util.Date) deadlineObj;
			}

			Calendar todoStartDate = Calendar.getInstance();
			if (createdAt != null) {
				todoStartDate.setTime(createdAt);
			} else {
				todoStartDate.setTime(new Date(0));
			}
			todoStartDate.set(Calendar.HOUR_OF_DAY, 0);
			todoStartDate.set(Calendar.MINUTE, 0);
			todoStartDate.set(Calendar.SECOND, 0);
			todoStartDate.set(Calendar.MILLISECOND, 0);

			Calendar todoEndDate = Calendar.getInstance();
			if (deadline != null) {
				todoEndDate.setTime(deadline);
			} else {
				todoEndDate.set(2999, 11, 31);
			}
			todoEndDate.set(Calendar.HOUR_OF_DAY, 0);
			todoEndDate.set(Calendar.MINUTE, 0);
			todoEndDate.set(Calendar.SECOND, 0);
			todoEndDate.set(Calendar.MILLISECOND, 0);

			Calendar countStartDate = (Calendar) startOfMonthCal.clone();
			if (todoStartDate.after(countStartDate)) {
				countStartDate = todoStartDate;
			}

			Calendar countEndDate = (Calendar) endOfMonthCal.clone();
			countEndDate.set(Calendar.HOUR_OF_DAY, 0);
			countEndDate.set(Calendar.MINUTE, 0);
			countEndDate.set(Calendar.SECOND, 0);
			countEndDate.set(Calendar.MILLISECOND, 0);

			if (todoEndDate.before(countEndDate)) {
				countEndDate = todoEndDate;
			}

			if (countStartDate.after(countEndDate)) {
				continue;
			}

			Calendar dayIter = (Calendar) countStartDate.clone();
			while (!dayIter.after(countEndDate)) {
				String key = sdf.format(dayIter.getTime());
				if (uncompletedCounts.containsKey(key)) {
					uncompletedCounts.put(key, uncompletedCounts.get(key) + 1);
				}
				dayIter.add(Calendar.DAY_OF_MONTH, 1);
			}
				}

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (sqlSession != null)
			sqlSession.close();
			}
		}
		%>

		<div class="calendar-header">
			<a href="calendar_main.jsp?year=<%=prevYear%>&month=<%=prevMonth%>"
				class="nav-button">&lt; 이전 달</a>
			<h2><%=displayYear%>년
				<%=displayMonth%>월
			</h2>
			<a href="calendar_main.jsp?year=<%=nextYear%>&month=<%=nextMonth%>"
				class="nav-button">다음 달 &gt;</a>
		</div>

		<div class="weekdays">
			<div>일</div>
			<div>월</div>
			<div>화</div>
			<div>수</div>
			<div>목</div>
			<div>금</div>
			<div>토</div>
		</div>

		<div class="calendar-grid">
			<%-- 빈 칸 채우기 --%>
			<%
			for (int i = 1; i < startDayOfWeek; i++) {
			%>
			<div class="day-cell other-month"></div>
			<%
			}

			// 날짜 출력
			for (int day = 1; day <= daysInMonth; day++) {
			String dateKey = String.format("%04d-%02d-%02d", displayYear, displayMonth, day);
			int completedCnt = completedCounts.getOrDefault(dateKey, 0);
			int uncompletedCnt = uncompletedCounts.getOrDefault(dateKey, 0);

			String todayClass = "";
			if (displayYear == currentYear && displayMonth == currentMonth && day == currentCal.get(Calendar.DAY_OF_MONTH)) {
				todayClass = " today";
			}

			String eventClass = "";
			if (completedCnt > 0 || uncompletedCnt > 0) {
				eventClass = " has-event";
			}
			%>
			<div class="day-cell current-month<%=todayClass%><%=eventClass%>"
				data-date="<%=displayYear%>-<%=String.format("%02d", displayMonth)%>-<%=String.format("%02d", day)%>">
				<div class="day-link">
					<span class="day-number"><%=day%></span>
					<%
					if (userId != null) {
					%>
					<div class="emojis">
						<%
						if (completedCnt > 0) {
						%>
						<span class="completed-emoji" title="<%=completedCnt%>개 완료">✔️</span>
						<%
						}
						%>
						<%
						if (uncompletedCnt > 0) {
						%>
						<span class="uncompleted-emoji" title="<%=uncompletedCnt%>개 미완료">❌</span>
						<%
						}
						%>
					</div>
					<%
					} else {
					%>
					<div class="emojis"></div>
					<%
					}
					%>
				</div>
			</div>
			<%
			}
			%>
		</div>

		<%
		if (userId == null) {
		%>
		<div class="no-login-message">
			로그인해야 할 일 목록을 볼 수 있습니다. <a href="login.jsp">로그인하기</a>
		</div>
		<%
		}
		%>

	</div>

	<!-- 모달 -->
	<div id="todoModal">
		<div id="modalContent">로딩 중...</div>
		<button onclick="closeModal()">닫기</button>
	</div>
	<div id="modalBackdrop" onclick="closeModal()"></div>

	<script>
function closeModal() {
    document.getElementById("todoModal").style.display = "none";
    document.getElementById("modalBackdrop").style.display = "none";
}

document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".day-cell.current-month").forEach(function (cell) {
        // 다른 달 칸은 클릭 안되도록 함
        if (cell.classList.contains("other-month")) return;

        cell.addEventListener("click", function () {
            const date = this.getAttribute("data-date");
            if (!date) return;

            const [year, month, day] = date.split("-");

            const xhr = new XMLHttpRequest();
            xhr.open("GET", "todo_list_by_date.jsp?year=" + year + "&month=" + month + "&day=" + day, true);
            xhr.onload = function () {
                if (xhr.status === 200) {
                    document.getElementById("modalContent").innerHTML = xhr.responseText;
                    document.getElementById("todoModal").style.display = "block";
                    document.getElementById("modalBackdrop").style.display = "block";
                } else {
                    document.getElementById("modalContent").innerHTML = "할 일 목록을 불러오는데 실패했습니다.";
                    document.getElementById("todoModal").style.display = "block";
                    document.getElementById("modalBackdrop").style.display = "block";
                }
            };
            xhr.send();
        });
    });
});
</script>

</body>
</html>
