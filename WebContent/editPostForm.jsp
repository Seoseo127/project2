<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.dto.PostDTO" %>
<%
    PostDTO post = (PostDTO) request.getAttribute("post");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>📌 게시글 수정</title>
    <style>
        body {
            font-family: 'Malgun Gothic', sans-serif;
            max-width: 600px;
            margin: 80px auto;
            padding: 0 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 40px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        input[type="text"], select, textarea {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
        }

        textarea {
            resize: vertical;
            height: 200px;
        }

        button {
            background-color: #333;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 8px;
            cursor: pointer;
            float: right;
        }

        button:hover {
            background-color: #555;
        }

        .clear {
            clear: both;
        }
    </style>

    <script>
        function toggleStudentCategory() {
            const main = document.getElementById("mainCategory").value;
            const subGroup = document.getElementById("studentSubGroup");

            if (main === "학생") {
                subGroup.style.display = "block";
                const subValue = document.getElementById("studentSubSelect").value;
                document.getElementById("category").value = subValue;
            } else {
                subGroup.style.display = "none";
                document.getElementById("category").value = main;
            }
        }

        function updateCategory(select) {
            document.getElementById("category").value = select.value;
        }

        window.onload = function () {
            toggleStudentCategory();
            const savedCategory = "<%=post.getCategory()%>";
            const main = document.getElementById("mainCategory");
            const sub = document.getElementById("studentSubSelect");
            const studentCategories = ["고등학생", "대학생", "취준생", "직장인"];

            if (studentCategories.includes(savedCategory)) {
                main.value = "학생";
                sub.value = savedCategory;
            } else {
                main.value = savedCategory;
            }

            toggleStudentCategory();
        };
    </script>
</head>
<body>

<h2>📌 게시글 수정</h2>

<form action="updatePost.do" method="post" enctype="multipart/form-data">
    <input type="hidden" name="postId" value="<%=post.getPostId()%>">
    <input type="hidden" name="category" id="category" value="<%=post.getCategory()%>">

    <div class="form-group">
        <input type="text" name="title" value="<%=post.getTitle()%>" required>
    </div>

    <div class="form-group">
        <label>카테고리</label>
        <select id="mainCategory" onchange="toggleStudentCategory()">
            <option value="공부">공부</option>
            <option value="자유">자유</option>
            <option value="학생">학생</option>
        </select>
    </div>

    <div class="form-group" id="studentSubGroup" style="display: none;">
        <label>구분</label>
        <select id="studentSubSelect" onchange="updateCategory(this)">
            <option value="고등학생">고등학생</option>
            <option value="대학생">대학생</option>
            <option value="취준생">취준생</option>
            <option value="직장인">직장인</option>
        </select>
    </div>

    <div class="form-group">
        <textarea name="pContent" required><%=post.getpContent()%></textarea>
    </div>

    <div class="form-group">
        <input type="file" name="uploadFile" accept="image/*,video/*">
    </div>

    <% if (post.getFilePath() != null && !post.getFilePath().isEmpty()) { %>
    <p>현재 첨부파일:</p>
    <% if (post.getFileType() != null && post.getFileType().startsWith("image")) { %>
        <img src="/<%=post.getFilePath()%>" width="300">
    <% } else if (post.getFileType() != null && post.getFileType().startsWith("video")) { %>
        <video width="400" controls>
            <source src="/<%=post.getFilePath()%>" type="<%=post.getFileType()%>">
        </video>
    <% } else { %>
        <a href="/<%=post.getFilePath()%>" target="_blank">파일 보기</a>
    <% } %>
	<% } %>

    <br><br>
    <button type="submit">수정 완료</button>
    <div class="clear"></div>
</form>

<form action="CommunityListController" method="get" style="margin-top: 20px;">
    <input type="hidden" name="category" value="all">
    <input type="hidden" name="keyword" value="">
    <button type="submit">목록으로</button>
</form>

</body>
</html>
