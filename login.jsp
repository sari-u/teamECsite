<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- cssを使用するために、cssファイルを指定する -->
<link rel="stylesheet" href="./css/table.css">
<link rel="stylesheet" href="./css/message.css">
<link rel="stylesheet" href="./css/title.css">
<link rel="stylesheet" href="./css/header.css">
<title>ログイン</title>
</head>
<body>
	<!-- javascriptを使用するために、javascriptのファイルを指定する -->
	<script src="./js/login.js"></script>
	<!--header.jspをインクルードする -->
	<jsp:include page="header.jsp" />
	<div id="contents">
		<h1>ログイン画面</h1>

		<!-- ユーザーIDのエラーメッセージ -->
		<s:if
			test="userIdErrorMessageList !=null && userIdErrorMessageList.size()>0">
			<div class="error">
				<div class="error-message">
					<s:iterator value="userIdErrorMessageList">
						<s:property />
						<br>
					</s:iterator>
				</div>
			</div>
		</s:if>

		<!-- パスワードのエラーメッセージ -->
		<s:if
			test="passwordErrorMessageList !=null && passwordErrorMessageList.size()>0">
			<div class="error">
				<div class="error-message">
					<s:iterator value="passwordErrorMessageList">
						<s:property />
						<br>
					</s:iterator>
				</div>
			</div>
		</s:if>

		<s:if
			test="isNotUserInfoMessage !=null && !isNotUserInfoMessage.isEmpty()">
			<div class="error">
				<div class="error-message">
					<s:property value="isNotUserInfoMessage" />
				</div>
			</div>
		</s:if>

		<s:form id="loginForm">
			<table class="vertical-list-table">
				<tr>
					<!-- ユーザーID -->
					<th scope="row"><s:label value="ユーザーID" /></th>
					<!-- ユーザーID保存チェックフラグがあるとき -->
					<s:if test="#session.savedUserIdFlag==true">
						<!-- セッションのuserIdを表示 -->
						<td><s:textfield name="userId" class="txt"
								placeholder="ユーザーID" value='%{session.userId}'
								autocomplete="off" /></td>
					</s:if>
					<!-- ユーザーID保存チェックフラグがないとき -->
					<s:else>
						<td><s:textfield name="userId" class="txt"
								placeholder="ユーザーID" value='%{userId}' autocomplete="off" /></td>
					</s:else>
				</tr>
				<tr>
					<!-- パスワード  -->
					<th scope="row"><s:label value="パスワード" /></th>
					<td><s:password name="password" class="txt"
							placeholder="パスワード" autocomplete="off" /></td>
				</tr>
			</table>
			<!-- ユーザーID保存チェックボックス -->
			<div class="box">
				<!--セッションのユーザーID保存チェックフラグがある、かつ、セッションのユーザーIDがNULLでない、かつ、セッションのユーザーIDが空でない、またはユーザー保存チェックにあるとき  -->
				<s:if
					test="(#session.savedUserIdFlag==true && #session.userId !=null && !#session.userId.isEmpty()) || savedUserIdFlag==true">
					<!-- ユーザーID保存チェックにチェックが入っている状態にする -->
					<s:checkbox name="savedUserIdFlag" checked="checked" />
				</s:if>
				<s:else>
					<!-- ユーザーID保存チェックが入っていないチェックボックス -->
					<s:checkbox name="savedUserIdFlag" />
				</s:else>
				<s:label value="ユーザID保存" />
				<br>
			</div>
			<div class="submit_btn_box">
				<!-- ログインボタン -->
				<s:submit value="ログイン" class="submit_btn3" onclick="goLoginAction()" />
			</div>
			<div class="submit_btn_box">
				<div id="contents-btn_set">
					<!-- 新規ユーザー登録ボタン -->
					<s:submit value="新規ユーザー登録" class="submit_btn3"
						onclick="goCreateUserAction()" />
				</div>
			</div>

			<div class="submit_btn_box">
				<div id="contents-btn set">
					<!-- パスワード再設定ボタン -->
					<s:submit value="パスワード再設定" class="submit_btn3"
						onclick="goResetPasswordAction()" />
				</div>
			</div>
		</s:form>
	</div>

</body>
</html>