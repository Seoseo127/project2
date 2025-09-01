// js/timer.js

const timers = {};         // 과목별 누적 초 저장
const intervals = {};      // 타이머 setInterval ID
const saveIntervals = {};  // 자동 저장 setInterval ID
let totalTimeUpdateInterval = null; // ✅ const 대신 let으로 변경!

// 초 → 시:분:초 포맷
function formatTime(seconds) {
	seconds = parseInt(seconds);
	if (isNaN(seconds) || seconds < 0) seconds = 0;

	const hrs = String(Math.floor(seconds / 3600)).padStart(2, '0');
	const mins = String(Math.floor((seconds % 3600) / 60)).padStart(2, '0');
	const secs = String(seconds % 60).padStart(2, '0');
	return `${hrs}:${mins}:${secs}`;
}

// 이모지를 업데이트하는 함수 추가
function updateStatusEmoji (subject, status) {
	const statusIconSpan = document.getElementById(`status-icon-${subject}`);
	if (statusIconSpan) {
		statusIconSpan.innerHTML = ''; // 기존 이모지 제거
		if (status && status.trim() === '완료') {
			statusIconSpan.innerHTML = '✔️';
		} else if (status && status.trim() === '미완료') {
			statusIconSpan.innerHTML = '❌';
		}
	}
}

// ✅ 총 목표/공부 시간을 업데이트하는 함수
function updateTotalTimes() {
	$.get("/PROJECT_2/timer", { action: "getTotalTimes" }, function(res) {
		// 상단 총 시간 업데이트
		const topTotalTimeDiv = document.querySelector('.total-time');
		if (topTotalTimeDiv) {
			topTotalTimeDiv.innerHTML = `🎯 전체 목표 시간: ${res.totalGoal} / 📚 현재 공부 시간: ${res.totalStudy}`;
		}

		// 하단 요약 총 시간 업데이트
		const summaryTotalGoalSpan = document.querySelector('.summary-time span:first-child');
		const summaryTotalStudySpan = document.querySelector('.summary-time span:last-child');
		if (summaryTotalGoalSpan) {
			summaryTotalGoalSpan.innerText = res.totalGoal;
		}
		if (summaryTotalStudySpan) {
			summaryTotalStudySpan.innerText = res.totalStudy;
		}
		console.log(`[Total Times] 🎯 목표: ${res.totalGoal} / 📚 공부: ${res.totalStudy}`);
	}, "json");
}


// 타이머 시작
function startTimer(subject, todoId) {
	if (intervals[subject]) return; // 이미 실행 중이면 무시

	if (timers[subject] === undefined) timers[subject] = 0;
	const row = document.querySelector(`tr[data-subject="${subject}"]`);
	const goalMinutes = row ? parseInt(row.dataset.goal) : 0;

	// 1초마다 시간 증가
	intervals[subject] = setInterval(() => {
		timers[subject]++;
		document.getElementById(`display-${subject}`).innerText = formatTime(timers[subject]);

		const totalMinutes = Math.floor(timers[subject] / 60);

		// ✅ 목표 도달 시 DB에 완료처리 (중복 방지용 data-completed)
		// 타이머는 계속 흐르고 버튼은 유지되도록 수정
		if (goalMinutes > 0 && totalMinutes >= goalMinutes && !row.dataset.completed) {
			row.dataset.completed = "true"; // 중복처리 방지

			$.post("/PROJECT_2/timer", {
				action: "complete",
				subject: subject,
				todoId: todoId
			}, function() {
				// ✅ 목표 달성 시 배경색만 변경하고, 타이머는 계속 흐르며 버튼은 유지
				row.style.backgroundColor = "#e0ffe0"; // 목표 달성 시 연한 초록색으로 변경 (예시)
				// ✅ 알림이 한 번만 뜨도록 조건 추가
				if (!row.dataset.alertShown) {
					alert("✅ 목표 달성! 할 일이 완료 상태로 변경되었습니다. 계속 공부하세요!");
					row.dataset.alertShown = "true"; // 알림 띄웠음을 표시
				}
				// ✅ 목표 달성 시 이모지 즉시 갱신
				updateStatusEmoji(subject, '완료');
				updateTotalTimes(); // ✅ 총 시간도 즉시 갱신
			});
		}
	}, 1000);

	// ✅ 10초마다 자동 저장
	saveIntervals[subject] = setInterval(() => {
		const totalMinutes = Math.floor(timers[subject] / 60);
		$.post("/PROJECT_2/timer", {
			action: "saveTimer",
			subject: subject,
			minutes: totalMinutes,
			todoId: todoId  // ⬅ 꼭 포함해야 TODO_LIST에도 저장됨
		}, function(res) {
			if (res.responseStatus === 'completed') { // ✅ 응답 상태 확인
				// ✅ 자동 저장 중 목표 달성 시 배경색만 변경하고, 타이머는 계속 흐르며 버튼은 유지
				const row = document.querySelector(`tr[data-subject='${subject}']`);
				row.style.backgroundColor = "#e0ffe0"; // 목표 달성 시 연한 초록색으로 변경 (예시)
				// ✅ 알림이 한 번만 뜨도록 조건 추가
				if (!row.dataset.alertShown) {
					alert("✅ 누적 시간이 목표를 초과하여 할 일이 완료 상태로 변경되었습니다. 계속 공부하세요!");
					row.dataset.alertShown = "true"; // 알림 띄웠음을 표시
				}
			} else {
				console.log(`[${subject}] ⏳ 저장됨: ${totalMinutes}분`);
			}
			// ✅ 10초마다 서버로부터 받은 실제 todoStatus로 이모지 갱신
			updateStatusEmoji(subject, res.todoStatus);
			updateTotalTimes(); // ✅ 총 시간도 갱신
		}, "json");
	}, 10000); // 10초마다
}

// 타이머 일시정지
function pauseTimer(subject) {
	clearInterval(intervals[subject]);
	clearInterval(saveIntervals[subject]);
	intervals[subject] = null;
	saveIntervals[subject] = null;
}

// 수동 정지 + 저장
function stopTimer(subject, todoId) {
	pauseTimer(subject); // 먼저 타이머와 자동 저장 중지
	const totalMinutes = Math.floor(timers[subject] / 60);

	$.post("/PROJECT_2/timer", {
		action: "saveTimer",
		subject: subject,
		minutes: totalMinutes,
		todoId: todoId
	}, function(res) {
		// ✅ 목표 달성 여부와 상관없이 "시간 저장 완료" 알림을 띄우도록 수정
		alert("⏹ 시간 저장 완료");

		// ✅ 만약 목표 달성으로 완료 상태가 되었다면, 추가적인 알림을 띄우지 않고 배경색만 변경
		if (res.responseStatus === 'completed') { // ✅ 응답 상태 확인
			const row = document.querySelector(`tr[data-subject='${subject}']`);
			row.style.backgroundColor = "#e0ffe0"; // 목표 달성 시 연한 초록색으로 변경 (예시)
		}
		// ✅ 수동 정지 시에도 서버로부터 받은 실제 todoStatus로 이모지 갱신
		updateStatusEmoji(subject, res.todoStatus);
		updateTotalTimes(); // ✅ 총 시간도 갱신
	}, "json");
}

// ✅ 페이지 로드 시 STUDY_TIMER.TOTAL로 타이머 초기화
window.onload = function() {
	document.querySelectorAll('[data-subject]').forEach(el => {
		const subject = el.dataset.subject;
		const rawTotal = el.dataset.total;

		const totalMinutes = (!rawTotal || isNaN(rawTotal)) ? 0 : parseInt(rawTotal);
		const totalSeconds = totalMinutes * 60;

		timers[subject] = totalSeconds;
		document.getElementById(`display-${subject}`).innerText = formatTime(totalSeconds);
	});

	// ✅ 오늘 완료된 항목 회색 처리 (버튼은 유지)
	fetch("/PROJECT_2/timer?action=getTimers")
		.then(res => res.json())
		.then(data => {
			const today = new Date().toISOString().split("T")[0];
			data.forEach(timer => {
				if (timer.clear === today) {
					const box = document.getElementById(`display-${timer.subject}`);
					if (box) {
						const row = box.parentElement.parentElement;
						row.style.backgroundColor = "#eee"; // 완료된 항목은 회색으로
						pauseTimer(timer.subject); // 완료된 항목은 타이머 중지
						row.dataset.alertShown = "true"; // 페이지 로드 시 이미 완료된 항목은 알림 띄웠음을 표시
					}
				}
			});
		});

	// ✅ 페이지 로드 시 총 시간 초기 업데이트 및 10초마다 갱신 시작
	updateTotalTimes(); // 초기 로드 시 한번 업데이트
	totalTimeUpdateInterval = setInterval(updateTotalTimes, 10000); // 10초마다 갱신
};